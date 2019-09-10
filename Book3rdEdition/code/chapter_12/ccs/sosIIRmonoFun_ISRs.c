// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: sosIIRmonoFun_ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
  
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

float G = 0.248341078962541;  // filter's gain
float B[3] = {1.0, 2.0, 1.0}; // numerator coefficients
float A[3] = {1.0, -0.184213803077536, 0.177578118927698};  // denominator coefficients
float w[3] = {0.0, 0.0, 0.0}; // filter's state

float IIR_SOS_DF2(float x, float B[], float A[], float G, float w[])
{
	float y;

	w[0] = x - A[1]*w[1] - A[2]*w[2];
	y = G*(B[0]*w[0] + B[1]*w[1] + B[2]*w[2]);

	w[2] = w[1];	// setup for the next input
	w[1] = w[0];	// setup for the next input
	return y;
}

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
	float x, y;

 	if(CheckForOverrun())	// overrun error occurred (i.e. halted DSP)
		return;				// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();	// get input data samples
	
	/* I added my IIR filter routine here */
	x = CodecDataIn.Channel[LEFT];		// current input value

	y = IIR_SOS_DF2(x, B, A, G, w);	    // call the DF-II, sos filter function

	CodecDataOut.Channel[LEFT]   = y;	// setup the LEFT  value
	CodecDataOut.Channel[RIGHT]  = y;	// the LEFT output value is written to the RIGHT channel
	/* end of my IIR filter routine	*/

	WriteCodecData(CodecDataOut.UINT);	// send output data to  port
}

