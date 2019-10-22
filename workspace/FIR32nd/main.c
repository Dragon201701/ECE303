// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017
 
///////////////////////////////////////////////////////////////////////
// Filename: main.c
//
// Synopsis: Main program file for frame-based processing using EDMA
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include "frames.h" 

int main()
{    
	// initialize all buffers to 0
	ZeroBuffers();
	
	// initialize EDMA controller 
	EDMA_Init();
	
	// initialize DSP and codec to use EDMA
  	DSP_Init_EDMA();

             // call to StartUp not needed here

	// main loop here, process buffer when ready 
  	while(1) { 
        if(IsBufferReady()) // process buffers in background
            ProcessBuffer();
  	}   
}


