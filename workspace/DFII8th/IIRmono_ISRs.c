// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include "DFII8th.h"
  
// Data is received as 2 16-bit words (left/right) packed into one
// 32-bit word.  The union allows the data to be accessed as a single 
// entity when transferring to and from the serial port, but still be 
// able to manipulate the left and right channels independently.

#define LEFT  1
#define RIGHT 0

volatile union {
	Uint32 UINT;
	Int16 Channel[2];
} CodecDataIn, CodecDataOut;


/* add any global variables here */
 #define N 4		// IIR filter order

//float B[N+1] = {1.0, -1.0};  // numerator coefficients
//float A[N+1] = {1.0, -0.9};  // denominator coefficients
//float x[N+1] = {0.0, 0.0};   // input value (buffered)
//float y[N+1] = {0.0, 0.0};   // output values (buffered)
float xLeft[N+1], xRight[N+1], yLeft, yRight;
//float xLeft, xRight;
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


 	if(CheckForOverrun())					// overrun error occurred (i.e. halted DSP)
		return;								// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();		// get input data samples
	
    /* I added my FIR filter routine here */
    //xLeft[0]  = CodecDataIn.Channel[LEFT];	// current LEFT input value
	//xRight[0] = CodecDataIn.Channel[RIGHT];	// current RIGHT input value
	float w[4][3];
	float out[4] = {0.0, 0.0, 0.0,0.0};
	float in[4] = {0.0, 0.0, 0.0,0.0};
	xLeft[0] = CodecDataIn.Channel[LEFT];
	//float x = input;
	//float ref = ;
	//float y = 0.0;
	//yLeft  = 0;				// initialize the LEFT output value
	//yRight = 0;				// initialize the RIGHT output value

	int i = 0, j = 0;
	for(i = 0; i < 4; i++)
	    for (j = 0; j < 3; j++)
	        w[i][j] = 0.0;
	int o = 0;
	for(o = N-1; o >= 0; o--){
	    w[o][0] = xLeft[o] - tmp[o][4] * w[o][1] - tmp[o][5] * w[o][2];
	    out[o] = tmp[o][0] * w[o][0] + tmp[o][1] * w[o][1] + tmp[o][2] * w[o][2];
	    w[o][2] = w[o][1];
	    w[o][1] = w[o][0];

	}
	int k = 0;
	/*for (k = 1; k < 3; k++)
	    in[k] = out [k-1];*/
    //yLeft =xLeft[0]*B[0];                 // get the first value of the yLeft for A[0]=1

	/*for (i = 0; i <= N-1; i++) {
		yLeft  += xLeft[i]*B[i] - yLeft*A[i];	     // perform the LEFT dot-product
	     //	yRight += xRight[i]*B[i];	            // perform the RIGHT dot-product
	}*/
	
	for (i = N; i > 0; i--) {
		xLeft[ i] = xLeft[ i-1];        // setup xLeft[] for the next input
            // xRight[i] = xRight[i-1];     	// setup xRight[] for the next input
	}
	
	CodecDataOut.Channel[LEFT]  = out[3];   // setup the LEFT value
	//CodecDataOut.Channel[RIGHT] = xRight[0];  // setup the RIGHT value
	CodecDataOut.Channel[RIGHT] = CodecDataIn.Channel[RIGHT];    // setup the RIGHT value
	WriteCodecData(CodecDataOut.UINT);      // send output data to  port




}

