// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: PPM_ISRs3.c
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
	float maxOutput;
	Uint8 workingLedMask;  				
	
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
		
		maxOutput = _fabsf(outputLeft);
		if(maxOutput < _fabsf(outputRight))
			maxOutput = _fabsf(outputRight);
			
		if (maxOutput > 32767) {
			LED_3_counter = RESET;
			LED_2_counter = RESET * 2;
			LED_1_counter = RESET * 3;
		}
		else if (maxOutput > 32000) {
			if(LED_2_counter < RESET)
				LED_2_counter = RESET;
			if(LED_1_counter < RESET * 2)
				LED_1_counter = RESET * 2;
		}
		else if (maxOutput > 28000) {
			if(LED_1_counter < RESET)
				LED_1_counter = RESET;
		}
		
		workingLedMask = 0; // all LEDs off
		if (LED_3_counter) {
			LED_3_counter--;
			workingLedMask |= LED3_BIT;  // LED3 on
		}
				
		if (LED_2_counter) {
			LED_2_counter--;
			workingLedMask |= LED2_BIT;  // LED2 on
		}
				
		if (LED_1_counter) {
			LED_1_counter--;
			workingLedMask |= LED1_BIT;  // LED1 on
		}
		
		LedMask = workingLedMask;			// update LED mask for main()
		
		CodecDataOut.Channel[ LEFT] = outputLeft;
		CodecDataOut.Channel[RIGHT] = outputRight;
	}
	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

