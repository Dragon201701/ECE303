// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: rectangularBPSK_ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include <stdlib.h>	/* needed to call the rand() function */
  
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
Int32 counter = 0; // counter within a symbol period
Int32 symbol;	 // current bit value ... 0 or 1
Int32 data[2] = {-20000, 20000}; // table lookup bit value
Int32 x;			       // bit's scaled value
Int32 samplesPerSymbol = 20;     // number of samples per symbol
Int32 cosine[4] = {1, 0, -1, 0}; // cos functions possible values
Int32 output;		       // BPSK modulator's output


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

	// I added my rectangular BPSK routine here
    if (counter == 0) {	     // time for a new bit
        symbol = rand() & 1; // equivalent to rand() % 2
		x = data[symbol];    // table lookup of the next data value
	}

	output = x*cosine[counter & 3]; // calculate the output value

	if (counter == (samplesPerSymbol - 1)) { // end of the symbol
    	counter = -1; 
    }

    counter++;
	
	CodecDataOut.Channel[LEFT]  = output; // setup the LEFT  value	
	CodecDataOut.Channel[RIGHT] = output; // setup the RIGHT value
	// end of my rectangular BPSK routine

	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

