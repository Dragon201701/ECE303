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
#define LFSR_LENGTH_LEFT			7
#define LFSR_LENGTH_RIGHT            16
#define LFSR_BIT_MASK_LEFT		((1 << LFSR_LENGTH_LEFT) - 1)
#define LFSR_BIT_MASK_RIGHT      ((1 << LFSR_LENGTH_RIGHT) - 1)
#define LFSR_XOR_MASK_LEFT		(((1 << 7) | (1 << 6)) >> 1)
#define LFSR_XOR_MASK_RIGHT       (((1 << 16) | (1 << 14) | (1 << 13) | (1 << 11)) >> 1)
#define LFSR_SEED_VALUE		3

// reduce LFSR update rate to Fs/DIVIDE_BY_N
//#define DIVIDE_BY_N			10
#define DIVIDE_BY_N         10
Uint32 LSFR_reg_Right = LFSR_SEED_VALUE;
Uint32 LSFR_reg_Left = LFSR_SEED_VALUE;

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
	Uint8 lsb, rsb;
	static Int32 divide_by_n = 0;			// used to reduce LFSR update rate
	
 	if(CheckForOverrun())					// overrun error occurred (i.e. halted DSP)
		return;								// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();		// get input data samples
	
	/* add your code starting here */

	if(--divide_by_n <= 0) {				// wait for divide-by-n_counter to expire
		divide_by_n = DIVIDE_BY_N;			// reset divide-by-n_counter
		LSFR_reg_Right &= LFSR_BIT_MASK_RIGHT;			// mask off LFSR to desired length
		LSFR_reg_Left &= LFSR_BIT_MASK_LEFT;
		lsb = LSFR_reg_Left & 1;					// store state of LS bit
		rsb = LSFR_reg_Right & 1;
		LSFR_reg_Left >>= 1; 					// shift LFSR right
		LSFR_reg_Right >>= 1;
		if(lsb)
			LSFR_reg_Left ^= LFSR_XOR_MASK_LEFT; 		// XOR only if LS bit was 1
		if(rsb)
		    LSFR_reg_Right ^= LFSR_XOR_MASK_RIGHT;      // XOR only if LS bit was 1

		//WriteDigitalOutputs(LSFR_reg);		// write LS bits to digital outputs
	}
	//CodecDataOut.Channel[LEFT] = ((LSFR_reg > 0)? 0x2000:0xE000) * CodecDataIn.Channel[LEFT];
	CodecDataOut.Channel[LEFT] = LSFR_reg_Left;
	CodecDataOut.Channel[RIGHT]  = ((LSFR_reg_Right > 0)? 0x7000:0x1000) * LSFR_reg_Right;
	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

