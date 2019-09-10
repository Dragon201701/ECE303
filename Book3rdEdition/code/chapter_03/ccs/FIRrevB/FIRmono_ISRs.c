// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: FIRmono_ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

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
float xLeft[N+1];
float yLeft;
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
	
	/* I added my FIR filter routine here */
	xLeft[0]  = CodecDataIn.Channel[LEFT];	// current LEFT input value
	yLeft = 0;				// initialize the output value

	for (i = 0; i <= N; i++) {
		yLeft += xLeft[i]*B[i];		// perform the dot-product
	}
	
	for (i = N; i > 0; i--) {
		xLeft[i] = xLeft[i-1];		// shift for the next input
	}
	
	CodecDataOut.Channel[LEFT]  = yLeft;	// output the value	
	/* end of my routine */


	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

