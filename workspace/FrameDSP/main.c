// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017
 
///////////////////////////////////////////////////////////////////////
// Filename: main.c
//
// Synopsis: Main program file for demonstration code
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h"   
#include "frames.h" 

int main()
{    
	
	// initialize all buffers to 0
	ZeroBuffers();

	// initialize DSP board
  	DSP_Init();

	// main stalls here, interrupts drive operation 
  	while(1) { 
        if(IsBufferReady()) // process buffers in background
            ProcessBuffer();
  	}   
}


