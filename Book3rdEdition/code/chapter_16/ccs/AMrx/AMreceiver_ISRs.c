// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: AMreceiver_ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include "coeff.h"  
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
float x[N];					// received AM signal values
float y;					// Hilbert Transforming (HT) filter's output
float envelope[2];			// real envelope
float output[2] = {0,0};	// output of the D.C. blocking filter
float r = 0.99;				// pole location for the D.C. blocking filter
Int32 i;					// integer index

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

	/* algorithm begins here */
	x[0] = CodecDataIn.Channel[RIGHT];// current AM signal value
	y = 0;				 // initialize the filter's output value

	for (i = 0; i < N; i++) {
		y += x[i]*B[i];		 // perform the HT (dot-product)
	}

	envelope[0] = sqrtf(y*y + x[16]*x[16]); // real envelope

	/* implement the D.C. blocking filter */
	output[0] = r*output[1] + (float)0.5 * (r + 1)*(envelope[0] - envelope[1]);

	for (i = N-1; i > 0; i--) {
		x[i] = x[i-1];		   // setup for the next input
	}

	envelope[1] = envelope[0]; // setup for the next input
	output[1]   = output[0];   // setup for the next input

	CodecDataOut.Channel[ LEFT] = output[0]; // setup the LEFT  value	
	CodecDataOut.Channel[RIGHT] = output[0]; // setup the RIGHT value	
	/* algorithm ends here */

	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

