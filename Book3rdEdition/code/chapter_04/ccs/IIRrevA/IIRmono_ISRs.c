// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include “DFII Transpose.h”
  
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
// #define N 1		// IIR filter order

//float B[N+1] = {1.0, -1.0};  // numerator coefficients
//float A[N+1] = {1.0, -0.9};  // denominator coefficients
float x[N+1] = {0.0, 0.0};   // input value (buffered)
float y[N+1] = {0.0, 0.0};   // output values (buffered)

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
	
        /* I added my FIR filter routine here */ 
        xLeft[0]  = CodecDataIn.Channel[LEFT];	// current LEFT input value
	xRight[0] = CodecDataIn.Channel[RIGHT];	// current RIGHT input value

	yLeft  = 0;				// initialize the LEFT output value
	yRight = 0;				// initialize the RIGHT output value
       
       yLeft =xLeft[0]*B[0];                 // get the first value of the yLeft for A[0]=1

	for (i = 0; i <= N-1; i++) {
		yLeft  += xLeft[i]*B[i] - yLeft*A[i];	     // perform the LEFT dot-product
	     //	yRight += xRight[i]*B[i];	            // perform the RIGHT dot-product
	}
	
	for (i = N; i > 0; i--) {
		xLeft[ i] = xLeft[ i-1];        // setup xLeft[] for the next input
            // xRight[i] = xRight[i-1];     	// setup xRight[] for the next input
	}
	
	CodecDataOut.Channel[LEFT]  = yLeft;	// setup the LEFT value	
	CodecDataOut.Channel[RIGHT] = xRight[0];	// setup the RIGHT value



	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

