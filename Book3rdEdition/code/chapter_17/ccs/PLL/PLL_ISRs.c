// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: PLL_ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include "coeff.h"	// load the filter coefficients, B[n] ... extern
#include <math.h>  
  
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
float alpha =  0.01;			// loop filter parameter 
float beta  = 0.002; 			// loop filter parameter 
float Fmsg  = 12000;			// vco rest frequency 
float Fs = 48000;				// sample frequency 
float x[N+1] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}; // input signal
float sReal;					// real part of the analytic signal 
float sImag;       				// imag part of the analytic signal 
float q = 0;					// input to the loop filter
float sigma = 0;				// part of the loop filter's output
float loopFilterOutput = 0;
float phi = 0;					// phase accumulator value 
float pi = 3.14159265358979;
float phaseDetectorOutputReal;	
float phaseDetectorOutputImag;

float vcoOutputReal = 1;
float vcoOutputImag = 0;
float scaleFactor = 3.0517578125e-5;

Int32 i;

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

	// I added my PLL routine here
	x[0] = CodecDataIn.Channel[LEFT]; // current LEFT input value
	sImag = 0;		// initialize the dot-product result
    
	for (i = 0; i <= N; i+=2) {	// indexing by 2, B[odd] = 0
		sImag += x[i]*B[i];	// perform the dot-product
	}

    sReal = x[15]*scaleFactor;	// grpdelay of the filter is 15 samples

	for (i = N; i > 0; i--) {
		x[i] = x[i-1];		// setup x[] for the next input
	}
		
	sImag *= scaleFactor;	// scale prior to loop filter

    // execute the D-PLL (the loop)
    vcoOutputReal = cosf(phi);
    vcoOutputImag = sinf(phi);
    phaseDetectorOutputReal = sReal*vcoOutputReal + sImag*vcoOutputImag;
    phaseDetectorOutputImag = sImag*vcoOutputReal - sReal*vcoOutputImag;
	q = phaseDetectorOutputReal * phaseDetectorOutputImag;
	sigma += beta*q; 
	loopFilterOutput = sigma + alpha*q;
	phi += 2*pi*Fmsg/Fs + loopFilterOutput;

	while (phi > 2*pi) {
		phi -= 2*pi;	// modulo 2pi operation 
	}

    // setup CODEC output values 
	CodecDataOut.Channel[LEFT]  = 32768*sReal; // input signal
	CodecDataOut.Channel[RIGHT] = 32768*phaseDetectorOutputReal; // msg
	// end of my PLL routine

	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

