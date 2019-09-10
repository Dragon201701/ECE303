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

// declared at file scope for visibility
// specific declarations for AM transmitter
#define Phase 0.0
const float Pi = 3.1415927; 
float desiredFreq = 6000.0;
Int32 bias = 32768;


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
	static float phase = Phase;
	float phaseIncrement = (2*Pi/GetSampleFreq())*desiredFreq;

 	if(CheckForOverrun())					// overrun error occurred (i.e. halted DSP)
		return;								// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();		// get input data samples
	
	/* add your code starting here */
	
	phase += phaseIncrement;	// calculate the next phase
	if (phase > 2*Pi) 		// maintain the phase between 0 and 2*pi
		phase -= 2*Pi;       
	
	CodecDataOut.Channel[LEFT] = (float) 0.5*(bias + CodecDataIn.Channel[LEFT])*sinf(phase); // AM generation
	CodecDataOut.Channel[RIGHT] = CodecDataOut.Channel[LEFT]; // copy the left channel to the right channel

	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

