// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: impulseModulatedBPSK_ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include "coeff.h"	// load the filter coefficients, B[n] ... extern
#include <stdlib.h>	// needed to call the rand() function
  
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
Int32 counter = 0;
Int32 samplesPerSymbol = 20;
Int32 symbol;
Int32 data[2] = {-15000, 15000};
Int32 cosine[4] = {1, 0, -1, 0};
Int32 i;

float x[10];
float y;
float output;

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

	// I added my IM BPSK routine here
    if (counter == 0) {
		symbol = rand() & 1; // a faster version of rand() % 2
		x[0] = data[symbol]; // read the table
	}

    // perform impulse modulation based on the FIR filter, B[N] 
    y  = 0;

    for (i = 0; i < 10; i++) {
		y +=  x[i]*B[counter + 20*i];	// perform the dot-product
	}
    
    if (counter == (samplesPerSymbol - 1)) {
    	counter = -1; 

		/* shift x[] in preparation for the next symbol */
 		for (i = 9; i > 0; i--) {
			x[i] = x[i - 1];          // setup x[] for the next input
		}
   	}

   	counter++;

	output = y*cosine[counter & 3];
	
	CodecDataOut.Channel[LEFT]  = output; // setup the LEFT  value	
	CodecDataOut.Channel[RIGHT] = output; // setup the RIGHT value
	// end of my IM BPSK routine

	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

