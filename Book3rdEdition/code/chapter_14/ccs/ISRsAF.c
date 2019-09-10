// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: ISRsAF.c
//
// Synopsis: Interrupt service routine for adaptive filtering
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
	/* These variables were declared as global to keep them in scope for troubleshooting */
	#define N 19 /* Filter order */
	float r[N+1]; /* Declare array for noise samples */
	float x   = 0.0; /* Declare variable for voice and interference */
	float w[N+1]; /* Declare array for filter coefficients */
	float e   = 0.0; /* Declare variable for the error signal */
	int reset = 1;	/* reset flag */

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
	float mu = 0.01; /* convergence factor */
	float scaleFactor = 3.05e-5; /* scale factor to keep the input values < 1 */
	float y = 0.0; /* filtered noise */
	int i; /* index for looping */

 	if(CheckForOverrun())					// overrun error occurred (i.e. halted DSP)
		return;								// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();		// get input data samples
	
	/* add your code starting here */
	// read in the two channels of data
	r[0] = scaleFactor*CodecDataIn.Channel[ LEFT]; /* interference (correlated noise) */
	x    = scaleFactor*CodecDataIn.Channel[RIGHT]; /* voice + interference */

	/* use a watch window to reset the filter by changing "reset" to 1 */
	if (reset == 1) {
		for(i=0; i<=N; i++) {
			w[i] = 0;
		}
		reset = 0;
	}

	/* adaptively filter the interference signal */
	y = 0;
	for(i=0; i<=N; i++)	{
		y += w[i] * r[N-i];
	}

	/* error signal is the filtered voice output */
	e = x - y;

	/* Widrow-Hoff LMS algorithm: update the coefficients */
	for(i=0; i<=N; i++)	{
		w[i] += 2*mu*e*r[N-i];
	}

	/* prepare the r array for the next input sample */
	for(i=N; i>0 ;i--)	{
		r[i] = r[i-1];
	}

	/* scale the denoised signal for output */
	CodecDataOut.Channel[ LEFT] = 32000*e;
	CodecDataOut.Channel[RIGHT] = 32000*e;

	/* end your code here */

	WriteCodecData(CodecDataOut.UINT); // send output data to port
}

