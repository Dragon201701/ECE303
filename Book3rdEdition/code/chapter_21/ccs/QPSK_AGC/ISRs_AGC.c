// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
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
Int32 i;
Int32 fourcount = 0; 
Int32 costable[4] = {1, 0, -1, 0};
Int32 sintable[4] = {0, 1, 0, -1};

float Output_Q[5] = {0, 0, 0, 0, 0};
float Output_I[5] = {0, 0, 0, 0, 0};

/* IIR-based matched filters using second order sections (SOS) */
float SOS_Gain = -0.005691614547251;

float Stage1_B[3] = {1.0, -0.669057621555000, -0.505837557192856};
float Stage2_B[3] = {1.0, -1.636373970290336,  0.793253123708712};
float Stage3_B[3] = {1.0, -2.189192793892326,  1.206129332609970};
float Stage4_B[3] = {1.0, -1.927309142277217,  0.981006820709641};

float Stage1_A[3] = {1.0, -1.898291587416584, 0.901843187948439};
float Stage2_A[3] = {1.0, -1.898520943904540, 0.909540256532186};
float Stage3_A[3] = {1.0, -1.906315962519294, 0.928697673452646};
float Stage4_A[3] = {1.0, -1.920806676700677, 0.957209542544347};

float Stage1_Q[3] = {0, 0, 0};
float Stage2_Q[3] = {0, 0, 0};
float Stage3_Q[3] = {0, 0, 0};
float Stage4_Q[3] = {0, 0, 0};
	
float Stage1_I[3] = {0, 0, 0};
float Stage2_I[3] = {0, 0, 0};
float Stage3_I[3] = {0, 0, 0};
float Stage4_I[3] = {0, 0, 0};

float I, Q;
float magnitude;
float reference = 15000.0;	// reference value
float error;				// error signal
float AGCgain = 1.0;		// initial system gain
float scaledError;
float alpha = 1e-7;         // approximately 0.002/reference

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

 	if(CheckForOverrun())	// overrun error occurred (i.e. halted DSP)
		return;				// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();	// get input data samples
	
	/* add your code starting here */
	// multiplication by the free running oscillators	
	Output_I[0] = SOS_Gain*CodecDataIn.Channel[LEFT]*sintable[fourcount];
	Output_Q[0] = SOS_Gain*CodecDataIn.Channel[LEFT]*costable[fourcount];
	
	// 8th order, IIR-based matched filters 
	Stage1_Q[0] = Stage1_A[0]*Output_Q[0] - 
		Stage1_A[1]*Stage1_Q[1] - Stage1_A[2]*Stage1_Q[2];
	Output_Q[1] = Stage1_B[0]*Stage1_Q[0] + 
		Stage1_B[1]*Stage1_Q[1] + Stage1_B[2]*Stage1_Q[2];
	
	Stage1_I[0] = Stage1_A[0]*Output_I[0] - 
		Stage1_A[1]*Stage1_I[1] - Stage1_A[2]*Stage1_I[2];
	Output_I[1] = Stage1_B[0]*Stage1_I[0] + 
		Stage1_B[1]*Stage1_I[1] + Stage1_B[2]*Stage1_I[2];
	
	Stage2_Q[0] = Stage2_A[0]*Output_Q[1] - 
		Stage2_A[1]*Stage2_Q[1] - Stage2_A[2]*Stage2_Q[2];
	Output_Q[2] = Stage2_B[0]*Stage2_Q[0] + 
		Stage2_B[1]*Stage2_Q[1] + Stage2_B[2]*Stage2_Q[2];
	Stage2_I[0] = Stage2_A[0]*Output_I[1] - 
		Stage2_A[1]*Stage2_I[1] - Stage2_A[2]*Stage2_I[2];
	Output_I[2] = Stage2_B[0]*Stage2_I[0] + 
		Stage2_B[1]*Stage2_I[1] + Stage2_B[2]*Stage2_I[2];
	
	Stage3_Q[0] = Stage3_A[0]*Output_Q[2] - 
		Stage3_A[1]*Stage3_Q[1] - Stage3_A[2]*Stage3_Q[2];
	Output_Q[3] = Stage3_B[0]*Stage3_Q[0] + 
		Stage3_B[1]*Stage3_Q[1] + Stage3_B[2]*Stage3_Q[2];
	Stage3_I[0] = Stage3_A[0]*Output_I[2] - 
		Stage3_A[1]*Stage3_I[1] - Stage3_A[2]*Stage3_I[2];
	Output_I[3] = Stage3_B[0]*Stage3_I[0] + 
		Stage3_B[1]*Stage3_I[1] + Stage3_B[2]*Stage3_I[2];
	
	Stage4_Q[0] = Stage4_A[0]*Output_Q[3] - 
		Stage4_A[1]*Stage4_Q[1] - Stage4_A[2]*Stage4_Q[2];
	Output_Q[4] = Stage4_B[0]*Stage4_Q[0] + 
		Stage4_B[1]*Stage4_Q[1] + Stage4_B[2]*Stage4_Q[2];
	Stage4_I[0] = Stage4_A[0]*Output_I[3] - 
		Stage4_A[1]*Stage4_I[1] - Stage4_A[2]*Stage4_I[2];
	Output_I[4] = Stage4_B[0]*Stage4_I[0] + 
		Stage4_B[1]*Stage4_I[1] + Stage4_B[2]*Stage4_I[2];
	
	// update the filter's state
	for (i=0; i<2; i++) {
        Stage1_Q[2-i] = Stage1_Q[(2-i)-1];
		Stage2_Q[2-i] = Stage2_Q[(2-i)-1];
		Stage3_Q[2-i] = Stage3_Q[(2-i)-1];
		Stage4_Q[2-i] = Stage4_Q[(2-i)-1];

		Stage1_I[2-i] = Stage1_I[(2-i)-1];
		Stage2_I[2-i] = Stage2_I[(2-i)-1];
		Stage3_I[2-i] = Stage3_I[(2-i)-1];
		Stage4_I[2-i] = Stage4_I[(2-i)-1];
	}
	
	// apply the AGC gain
	I = AGCgain*Output_I[4];
    Q = AGCgain*Output_Q[4];
    
    // calculate the new AGC gain
    magnitude = sqrtf(I*I + Q*Q);
    error = reference - magnitude;
    scaledError = alpha * error;
    AGCgain = AGCgain + scaledError;
    
    // increment the counter ... 0, 1, 2, 3, ... repeat
    fourcount++;
    if (fourcount > 3)	{
    	fourcount = 0;
    }
	
	// output I and Q for a "versus" plot on an oscilloscope
   	CodecDataOut.Channel[RIGHT] = I;
	CodecDataOut.Channel[LEFT]  = Q;
	/* end your code here */
	
	WriteCodecData(CodecDataOut.UINT); // send output data to  port
}
