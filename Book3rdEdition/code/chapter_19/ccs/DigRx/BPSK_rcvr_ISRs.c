// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: BPSK_rcvr_ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include "hilbert.h" 
#include "math.h"
#include "matched_120.h"
  
// Data is received as 2 16-bit words (left/right) packed into one
// 32-bit word.  The union allows the data to be accessed as a single 
// entity when transferring to and from the serial port, but still be 
// able to manipulate the left and right channels independently.

#define LEFT  0
#define RIGHT 1

volatile union {
	Uint32 UINT;
	Int16 Channel[2];
} CodecDataIn, CodecDataOut;


/* add any global variables here */
float alpha_PLL = 0.01; // loop filter parameter
float beta_PLL = 0.002; // loop filter parameter

float alpha_ML = 0.1;   // loop filter parameter
float beta_ML = 0.02;   // loop filter parameter

float twoPi = 6.2831853072;    // 2pi
float piBy2 = 1.57079632679;   // pi/2
float piBy10 = 0.314159265359; // pi/10
float piBy100 = 0.0314159265359; // pi/100
float scaleFactor = 3.0517578125e-5;
float gain = 3276.8;

float x[N+1] = {0,0,0,0,0,0,0}; // input signal
float sReal = 0;  // real part of the analytical signal
float sImag = 0;  // imag part of the analytical signal

float phaseDetectorOutputReal[M+1] = {0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0};  // real part of the analytical signal
float phaseDetectorOutputImag = 0;
float vcoOutputReal = 1;
float vcoOutputImag = 0;
float q_loop = 0;     // input to the loop filter
float sigma_loop = 0; // part of the PLL loop filter
float PLL_loopFilterOutput = 0;
float phi = 0; // phase accumulator value

float *pLeft = phaseDetectorOutputReal;
float *p = 0; 
float matchedfilterout[3] = {0,0,0};

float diffoutput = 0;
float sigma_ML = 0;  // part of the ML loop filter
float ML_loopFilterOutput = 0;
float accumulator = 0;
float adjustment = 0;
float data = 0;
volatile float ML_on_off = 1;

Int32 i = 0;
Int32 sync = 0;


interrupt void Codec_ISR()
///////////////////////////////////////////////////////////////////////
// Purpose:   Codec interface interrupt service routine  
//
// Input:     None
//
// Returns:   Nothing
//
// Calls:     CheckForOverrun, ReadCodecData, WriteCodecData
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{                    
	/* add any local variables here */

 	if(CheckForOverrun())					// overrun error occurred (i.e. halted DSP)
		return;								// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();		// get input data samples
	
	/* add your code starting here */

	// my algorithm starts here ...
	// bring in input value
	x[0]  = CodecDataIn.Channel[LEFT];  // current LEFT input value

	// execute Hilbert transform and group delay compensation
	sImag = (x[0] - x[6])*B_hilbert[0] + (x[2] - x[4])*B_hilbert[2];
	sReal = x[3]*scaleFactor; // scale and account for the group delay
	
	// setup x for the next input
	for(i = N; i >0; i--) {
		x[i] = x[i-1];  
	}
	
	sImag *= scaleFactor;
	
	// execute the PLL           
	vcoOutputReal = cosf(phi);
	vcoOutputImag = sinf(phi);
	phaseDetectorOutputReal[0] = sReal*vcoOutputReal + sImag*vcoOutputImag;	
	phaseDetectorOutputImag = sImag*vcoOutputReal - sReal*vcoOutputImag;
	q_loop = phaseDetectorOutputReal[0] * phaseDetectorOutputImag;
	sigma_loop += beta_PLL*q_loop;  
	PLL_loopFilterOutput = sigma_loop + alpha_PLL*q_loop;
	phi += piBy2 + PLL_loopFilterOutput;
	
	while(phi > twoPi) {
	    phi -= twoPi;  // modulo 2pi operation for accumulator
	}
		
	// execute the matched filter (MF)
	*pLeft  = phaseDetectorOutputReal[0];  

	matchedfilterout[0] = 0;				
	p = pLeft;					
	if(++pLeft > &phaseDetectorOutputReal[M])
	    pLeft = phaseDetectorOutputReal;			
	for (i = 0; i <= M; i++) {	// do LEFT channel FIR	
	        matchedfilterout[0] += *p-- * B_MF[i]; 
        	if(p < phaseDetectorOutputReal)         
            		p = &phaseDetectorOutputReal[M];      
	}

	// execute the differentiation filter
	diffoutput = matchedfilterout[0] - matchedfilterout[2];
	
	// execute the ML timing recovery loop
	sync = 0;
	if(accumulator >= twoPi) {
		sync = 20000;
		data = -1;
		if(matchedfilterout[0] >= 0) { // recover data
		    data = 1;
		} 		
		adjustment = data*diffoutput;
		sigma_ML += beta_ML*adjustment;  
		// prevents timing adjustments of more than +/- 1 sample
		if (sigma_ML > piBy10) {
		    sigma_ML = piBy10;
		}
		else if (sigma_ML < -piBy10) {
		    sigma_ML = -piBy10;
		}				
		ML_loopFilterOutput = sigma_ML + alpha_ML*adjustment;

		// prevents timing adjustments of more than +/- 0.1 sample
		if (ML_loopFilterOutput > piBy100) {
		    ML_loopFilterOutput = piBy100;
		}
		else if (ML_loopFilterOutput < -piBy100) {
		    ML_loopFilterOutput = -piBy100;
		}
		if (ML_on_off == 1) {
		    accumulator -= (twoPi + ML_loopFilterOutput);
		}
		else {
		    accumulator -= twoPi;
		}
	}
	
	// increment the accumulator
	accumulator += piBy10;

	// setup matchedfilterout for the next input	
	matchedfilterout[2] = matchedfilterout[1];
	matchedfilterout[1] = matchedfilterout[0];			
		
 	CodecDataOut.Channel[LEFT] = sync; // O-scope trigger pulse
	CodecDataOut.Channel[RIGHT] = gain * matchedfilterout[1];	
	// ... my algorithm ends here

	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

