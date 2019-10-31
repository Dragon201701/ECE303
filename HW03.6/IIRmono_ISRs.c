// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include "LP-8th-750of48K.h"
#include "IIR4th.h"
  
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
// #define N 1		// IIR filter order

//float B[N+1] = {1.0, -1.0};  // numerator coefficients
//float A[N+1] = {1.0, -0.9};  // denominator coefficients
//float x[N+1] = {0.0, 0.0};   // input value (buffered)
//float y[N+1] = {0.0, 0.0};   // output values (buffered)

float x, xLeft[5], yLeft,  xRight[N] , yRight[N], y;
float w[4][3] = {{0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}};
Int32 i;
Int32 j;
Int32 k;
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

  	float A[3] = {0.0, 0.0, 0.0};
  	float B[3] = {0.0, 0.0, 0.0};


    xLeft[0]  = CodecDataIn.Channel[LEFT];	// current LEFT input value
	xRight[0] = CodecDataIn.Channel[RIGHT];	// current RIGHT input value


	    y = 0;              // initialize the LEFT output value


	    y = xRight[0]*D[0]; // get the first value of the yLeft for A[0]=1

	    for (i = 1; i <= N- 1; i++) {
	        y  +=  xRight[i]*D[i] - yRight[i]*C[i];        // perform the LEFT dot-product
	         // yRight += xRight[i]*B[i];               // perform the RIGHT dot-product
	    }
	    yRight[0] = y;
	    for (i = N; i > 0; i--) {
	        xRight[ i] = xRight[ i-1];        // setup xLeft[] for the next input
	            // xRight[i] = xRight[i-1];         // setup xRight[] for the next input
	        yRight[i]= yRight[i-1];
	    }

	    yLeft  = 0;               // initialize the LEFT output value
	                  // initialize the RIGHT output value
	for (i = 3; i >=0; i--) {
		//yLeft  += xLeft[i]*B[i] - yLeft*A[i];	     // perform the LEFT dot-product
	     //	yRight += xRight[i]*B[i];	            // perform the RIGHT dot-product
		for(j=0; j<=2; j++){
		    A[j] = SOS_1[i][j+3];
		    B[j] = SOS_1[i][j];
		}



		    w[i][0] = xLeft[i] - A[1]*w[i][1] - A[2]*w[i][2];
		            yLeft = B[0]*w[i][0]+B[1]*w[i][1]+B[2]*w[i][2];

		                                      w[i][2] = w[i][1];
		                                      w[i][1] = w[i][0];

		                                      xLeft[i +1]= yLeft;


	}
	 for(i = 3; i>0; i--){
	     xLeft[i] = xLeft[i -1];
	 }


	CodecDataOut.Channel[LEFT]  = yLeft;	// setup the LEFT value
	CodecDataOut.Channel[RIGHT] = y ;	// setup the RIGHT value



	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

