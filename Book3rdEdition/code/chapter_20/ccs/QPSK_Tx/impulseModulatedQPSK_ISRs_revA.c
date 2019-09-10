// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: impulseModulatedQPSK_ISRs_revA.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include "coeff.h"   // load the filter coefficients, B[n] ... extern
#include <stdlib.h>  // needed to call the rand() function
  
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
#define QPSK_SCALE  10000
const Int32 samplesPerSymbol = 20;

const float QPSK_LUT[4][2] = {
// left (quadrature), right (in-phase),   names[index]
{     1 * QPSK_SCALE,  1 * QPSK_SCALE}, /* QPSK_LUT[0]  */
{     1 * QPSK_SCALE, -1 * QPSK_SCALE}, /* QPSK_LUT[1]  */
{    -1 * QPSK_SCALE,  1 * QPSK_SCALE}, /* QPSK_LUT[2]  */
{    -1 * QPSK_SCALE, -1 * QPSK_SCALE}, /* QPSK_LUT[3]  */
};

float output_gain = 1.0;
float xI[6];
float xQ[6];
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
	Int32 symbol;
	Int32 i;

 	if(CheckForOverrun())					// overrun error occurred (i.e. halted DSP)
		return;								// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();		// get input data samples
	
	/* add your code starting here */

	// I added my impulse modulated, QPSK routine here
	if (counter == 0) {
		symbol = rand() & 3; /* generate 2 random bits */
		xI[0]  = QPSK_LUT[symbol][RIGHT];  // lookup the I symbol
		xQ[0]  = QPSK_LUT[symbol][ LEFT];  // lookup the Q symbol
	}

	output = 0;
	switch(counter & 3) {
	case  0: // perform the I impulse modulation based on the FIR filter, B[N] 
		for (i = 0; i < 6; i++) {
			output += xI[i]*B[counter + 20*i]; // perform the "I" dot-product
		}
		break;
	case 1: // perform the Q impulse modulation based on the FIR filter, B[N] 
		for (i = 0; i < 6; i++) {
			output -= xQ[i]*B[counter + 20*i]; // perform the "Q" dot-product
		}
		break;
	case 2: // perform the -I impulse modulation based on the FIR filter, B[N] 
		for (i = 0; i < 6; i++) {
			output -= xI[i]*B[counter + 20*i]; // perform the "-I" dot-product
		}
		break;
	default: // perform the -Q impulse modulation based on the FIR filter, B[N] 
		for (i = 0; i < 6; i++) {
			output += xQ[i]*B[counter + 20*i]; // perform the "-Q" dot-product
		}
		break;
	}
	if (counter == (samplesPerSymbol - 2)) {
		/* shift xI[] in preparation to receive the next I input */
		for (i = 5; i > 0; i--) {
			xI[i] = xI[i-1];  // setup xI[] for the next input value
		}
	}
	else if (counter >= (samplesPerSymbol - 1)) {
		counter = -1;  // reset in preparation for the next set of bits
		/* shift xQ[] in preparation to receive the next Q input */
		for (i = 5; i > 0; i--) {
			xQ[i] = xQ[i-1];  // setup xQ[] for the next input value
		}
	}

	counter++;

	CodecDataOut.Channel[LEFT]  = output_gain*output; // setup the LEFT output value	
	CodecDataOut.Channel[RIGHT] = CodecDataOut.Channel[LEFT]; // copy to RIGHT
    // end of my impulse modulated, QPSK routine here

	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

