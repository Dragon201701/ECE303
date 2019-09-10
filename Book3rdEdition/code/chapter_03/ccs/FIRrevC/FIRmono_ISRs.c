// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

/*  function prototype  */
float dotProduct(float *m, float *n, int count);

#include "DSP_Config.h" 
#include "coeff.h"	// load the filter coefficients, B[n] ... extern
  
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
float xRight[N+1], yRight;
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
	
	/* I added my mono FIR filter routine here */
	xRight[0] = CodecDataIn.Channel[RIGHT]; // current RIGHT input value

	yRight = dotProduct(xRight, B, N);		// perform the RIGHT dot-product
	
	for (i = N; i > 0; i--) {
		xRight[i] = xRight[i-1]; 			// setup xRight[] for the next input
	}
	
	CodecDataOut.Channel[LEFT]  = yRight; 	// setup the LEFT value	
	CodecDataOut.Channel[RIGHT] = yRight;	// setup the RIGHT value	
	/* end of my mono FIR filter routine */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

// Dot-product function
float dotProduct(float *m, float *n, int count)
{   int i;
    float sum = 0.0;
    
    for (i = 0; i <= count; i++)
    {
       sum += m[i]*n[i];
    }
    return(sum);
}               
