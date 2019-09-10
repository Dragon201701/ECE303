// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017
 
///////////////////////////////////////////////////////////////////////
// Filename: main.c
//
// Synopsis: Main program file for PPM demonstration code
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h"  

extern volatile Uint8 LedMask; // declared in PPM_ISRs.c

int main()
{    
	Uint8 PrevLedMask = 255; // force an initial LED update
	
	// initialize DSP board
  	DSP_Init();

	// main stalls here, interrupts drive operation 
  	while(1) { 
		if(PrevLedMask != LedMask) {	// did the LEDs change?
			PrevLedMask = LedMask;		// save new LED state
			WriteLEDs(PrevLedMask);		// and update LEDs
		}
  	}   
}


