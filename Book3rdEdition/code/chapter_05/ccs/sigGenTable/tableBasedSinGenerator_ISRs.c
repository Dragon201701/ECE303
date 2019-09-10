// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include <math.h>   
  
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
#define NumTableEntries 100
#define Phase			0.0

float desiredFreq = 6000.0;
float SineTable[NumTableEntries];

void FillSineTable()
{   
	Int32 i;
	
	for(i = 0; i < NumTableEntries; i++) // fill table values
		SineTable[i] = sinf(i * (float)(6.283185307 / NumTableEntries));  
}



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
	static float index = Phase;
	float sine;


 	if(CheckForOverrun())					// overrun error occurred (i.e. halted DSP)
		return;								// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();		// get input data samples
	
	/* ISR's algorithm begins here */
	index += desiredFreq;					// calculate the next phase
	if (index >= GetSampleFreq()) 			// keep phase between 0-2*pi
		index -= GetSampleFreq();       
	
	sine = SineTable[(int)(index / GetSampleFreq() * NumTableEntries)];
	CodecDataOut.Channel[LEFT]  = 32767*sine; // scale the result
	CodecDataOut.Channel[RIGHT] = CodecDataOut.Channel[LEFT]; 
	/* ISR's algorithm ends here */	

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

