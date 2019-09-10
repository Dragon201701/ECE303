// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: ISRs.c
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

// implementing Galois 16-bit LFSR  x^16 + x^14 + x^13 + x^11 + 1
#define LFSR_LENGTH			16
#define LFSR_BIT_MASK		((1 << LFSR_LENGTH) - 1)
#define LFSR_XOR_MASK		(((1 << 16) | (1 << 14) | (1 << 13) | (1 << 11)) >> 1)
#define LFSR_SEED_VALUE		3

// reduce LFSR update rate to Fs/DIVIDE_BY_N
#define DIVIDE_BY_N			10	

Uint32 LSFR_reg = LFSR_SEED_VALUE;

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
	Uint8 lsb;
	static Int32 divide_by_n = 0;			// used to reduce LFSR update rate
	
 	if(CheckForOverrun())					// overrun error occurred (i.e. halted DSP)
		return;								// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();		// get input data samples
	
	/* add your code starting here */

	if(--divide_by_n <= 0) {				// wait for divide-by-n_counter to expire
		divide_by_n = DIVIDE_BY_N;			// reset divide-by-n_counter
		LSFR_reg &= LFSR_BIT_MASK;			// mask off LFSR to desired length
		lsb = LSFR_reg & 1;					// store state of LS bit
		LSFR_reg >>= 1; 					// shift LFSR right
		if(lsb)
			LSFR_reg ^= LFSR_XOR_MASK; 		// XOR only if LS bit was 1

		WriteDigitalOutputs(LSFR_reg);		// write LS bits to digital outputs
	}
	
	CodecDataOut.UINT  = CodecDataIn.UINT;	// just do talk-through	

	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

