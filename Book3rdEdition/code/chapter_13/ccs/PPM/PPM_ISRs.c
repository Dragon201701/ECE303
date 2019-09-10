// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: PPM_ISRs.c
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
Int32 DecimationFactor = 1;
Int32 NumBitsToUse = 16;
Int32 LED_1_counter = 0;
Int32 LED_2_counter = 0;
Int32 LED_3_counter = 0;

float scaleFactor = 1.0;
float outputLeft = 0.0;
float outputRight = 0.0;

volatile Int16 TruncationMask;

#define RESET 4800	// turns the LED off after "RESET" number of samples
#define LED1_BIT 1	// define bits for each LED
#define LED2_BIT 2
#define LED3_BIT 4	// note that this has no effect on the OMAP-L138 board

volatile Uint8 LedMask = 0; // used by main() to update the LEDs

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
	static Int32 DecimationIndex = 0;

 	if(CheckForOverrun())					// overrun error occurred (i.e. halted DSP)
		return;								// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();		// get input data samples
	
	/* add your code starting here */
	// decimate signal by DecimationFactor	
	if(++DecimationIndex >= DecimationFactor) { // use sample?
		DecimationIndex = 0;		// reset decimation index
		TruncationMask = 0xFFFF << (16 - NumBitsToUse); // create truncation mask
		
		outputLeft = scaleFactor*(CodecDataIn.Channel[ LEFT] & TruncationMask);
		outputRight = scaleFactor*(CodecDataIn.Channel[RIGHT] & TruncationMask);
		
		// LED 1 logic
		if ((abs(outputLeft) > 28000)||(abs(outputRight) > 28000)) {
			LedMask |= LED1_BIT;  // LED1 on
			LED_1_counter = RESET;
		}
		else {
			if (LED_1_counter > 0) 
				LED_1_counter -= 1;
			else 
				LedMask &= ~LED1_BIT;  // LED1 off
		}
		
		// LED 2 logic
		if ((abs(outputLeft) > 32000)||(abs(outputRight) > 32000)) {
			LedMask |= LED2_BIT;  // LED2 on
			LED_2_counter = RESET;
		}
		else {
			if (LED_2_counter > 0) 
				LED_2_counter -= 1;
			else 
				LedMask &= ~LED2_BIT;  // LED2 off

		}
		
		// LED 3 logic
		if ((abs(outputLeft) > 32767)||(abs(outputRight) > 32767)) {
			LedMask |= LED3_BIT;  // LED3 on
			LED_3_counter = RESET;
		}
		else {
			if (LED_3_counter > 0) 
				LED_3_counter -= 1;
			else 
				LedMask &= ~LED3_BIT;  // LED3 off
		}
		
		CodecDataOut.Channel[ LEFT] = outputLeft;
		CodecDataOut.Channel[RIGHT] = outputRight;
	}
	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

