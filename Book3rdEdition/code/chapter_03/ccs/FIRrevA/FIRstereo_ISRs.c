// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: FIRstereo_ISRs.c
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

#define N 3			// FIR filter order

float B[N+1] = {0.25, 0.25, 0.25, 0.25};
float xLeft[N+1], xRight[N+1], yLeft, yRight;

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
	
	/* I added my stereo FIR filter routine here */
	xLeft[0]  = CodecDataIn.Channel[LEFT];		// current LEFT input value
	xRight[0] = CodecDataIn.Channel[RIGHT];		// current RIGHT input value
	yLeft  = 0;					// initialize the LEFT output value
	yRight = 0;					// initialize the RIGHT output value

	for (i = 0; i <= N; i++) {
		yLeft  += xLeft[ i]*B[i];		// perform the LEFT dot-product
		yRight += xRight[i]*B[i];		// perform the RIGHT dot-product
	}
	
	for (i = N; i > 0; i--) {
		xLeft[ i] = xLeft[ i-1];          	// setup xLeft[] for the next input
		xRight[i] = xRight[i-1];     	    // setup xRight[] for the next input
	}
	
	CodecDataOut.Channel[LEFT]  = yLeft;		// setup the LEFT value	
	CodecDataOut.Channel[RIGHT] = yRight;		// setup the RIGHT value	
	/* end of my stereo FIR filter routine */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

