// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: ISRs_QPSK_Rx.c
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
Int32 i, di, dq;
Int32 fourcount = 0; 
Int32 costable[4] = {1, 0, -1, 0};
Int32 sintable[4] = {0, 1, 0, -1};

float Output_Q[5] = {0, 0, 0, 0, 0};
float Output_I[5] = {0, 0, 0, 0, 0};

/* IIR-based matched filters using four second order sections (SOS) */
float SOS_Gain = -0.005691614547251;

float Stage1_B[3] = {1.0, -0.669057621555000, -0.505837557192856};
float Stage2_B[3] = {1.0, -1.636373970290336,  0.793253123708712};
float Stage3_B[3] = {1.0, -2.189192793892326,  1.206129332609970};
float Stage4_B[3] = {1.0, -1.927309142277217,  0.981006820709641};

float Stage1_A[3] = {1.0, -1.898291587416584, 0.901843187948439};
float Stage2_A[3] = {1.0, -1.898520943904540, 0.909540256532186};
float Stage3_A[3] = {1.0, -1.906315962519294, 0.928697673452646};
float Stage4_A[3] = {1.0, -1.920806676700677, 0.957209542544347};

float Stage1_Q[3] = {0, 0, 0};
float Stage2_Q[3] = {0, 0, 0};
float Stage3_Q[3] = {0, 0, 0};
float Stage4_Q[3] = {0, 0, 0};
	
float Stage1_I[3] = {0, 0, 0};
float Stage2_I[3] = {0, 0, 0};
float Stage3_I[3] = {0, 0, 0};
float Stage4_I[3] = {0, 0, 0};

float I, Q;
float Iscaled[3] = {0, 0, 0};
float Qscaled[3] = {0, 0, 0};
float Isampled, Qsampled;
float magnitude;
float reference = 15000.0;	// reference value
float error;				// error signal
float AGCgain = 1.0;		// initial system gain
float scaledError;			// error signal scaled by the AGC loop gain
float alpha = 1.0e-7;       // approximately 0.002/reference

float phase = 0.5; // initial phase for the timing recovery loop
float phaseInc = 0.314159265358979; // phase increment (2pi/20)
float phaseGain = 0.2e-6;   // gain that controls the symbol timing loop

float thetaGain = 1.0e-7;   // gain that controls the de-rotation loop
float st = 1.0;				// sin(theta)
float ct = 1.0;				// cos(theta)
float phaseAdj = 0;			// phase adjustment associated with theta
float symTimingAdj[14] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}; // symbol timing
float theta = 0;			// constellation de-rotation angle
float thetaAdj;

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

 	if(CheckForOverrun())	// overrun error occurred (i.e. halted DSP)
		return;				// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();	// get input data samples
	
	/* add your code starting here */
	// demodulate ... multiplication by the free running oscillators	
	Output_I[0] = SOS_Gain*CodecDataIn.Channel[LEFT]*sintable[fourcount];
	Output_Q[0] = SOS_Gain*CodecDataIn.Channel[LEFT]*costable[fourcount];
	
	// 8th order, IIR-based matched filters 
	Stage1_Q[0] = Stage1_A[0]*Output_Q[0] - 
		Stage1_A[1]*Stage1_Q[1] - Stage1_A[2]*Stage1_Q[2];
	Output_Q[1] = Stage1_B[0]*Stage1_Q[0] + 
		Stage1_B[1]*Stage1_Q[1] + Stage1_B[2]*Stage1_Q[2];
	
	Stage1_I[0] = Stage1_A[0]*Output_I[0] - 
		Stage1_A[1]*Stage1_I[1] - Stage1_A[2]*Stage1_I[2];
	Output_I[1] = Stage1_B[0]*Stage1_I[0] + 
		Stage1_B[1]*Stage1_I[1] + Stage1_B[2]*Stage1_I[2];
	
	Stage2_Q[0] = Stage2_A[0]*Output_Q[1] - 
		Stage2_A[1]*Stage2_Q[1] - Stage2_A[2]*Stage2_Q[2];
	Output_Q[2] = Stage2_B[0]*Stage2_Q[0] + 
		Stage2_B[1]*Stage2_Q[1] + Stage2_B[2]*Stage2_Q[2];
	Stage2_I[0] = Stage2_A[0]*Output_I[1] - 
		Stage2_A[1]*Stage2_I[1] - Stage2_A[2]*Stage2_I[2];
	Output_I[2] = Stage2_B[0]*Stage2_I[0] + 
		Stage2_B[1]*Stage2_I[1] + Stage2_B[2]*Stage2_I[2];
	
	Stage3_Q[0] = Stage3_A[0]*Output_Q[2] - 
		Stage3_A[1]*Stage3_Q[1] - Stage3_A[2]*Stage3_Q[2];
	Output_Q[3] = Stage3_B[0]*Stage3_Q[0] + 
		Stage3_B[1]*Stage3_Q[1] + Stage3_B[2]*Stage3_Q[2];
	Stage3_I[0] = Stage3_A[0]*Output_I[2] - 
		Stage3_A[1]*Stage3_I[1] - Stage3_A[2]*Stage3_I[2];
	Output_I[3] = Stage3_B[0]*Stage3_I[0] + 
		Stage3_B[1]*Stage3_I[1] + Stage3_B[2]*Stage3_I[2];
	
	Stage4_Q[0] = Stage4_A[0]*Output_Q[3] - 
		Stage4_A[1]*Stage4_Q[1] - Stage4_A[2]*Stage4_Q[2];
	Output_Q[4] = Stage4_B[0]*Stage4_Q[0] + 
		Stage4_B[1]*Stage4_Q[1] + Stage4_B[2]*Stage4_Q[2];
	Stage4_I[0] = Stage4_A[0]*Output_I[3] - 
		Stage4_A[1]*Stage4_I[1] - Stage4_A[2]*Stage4_I[2];
	Output_I[4] = Stage4_B[0]*Stage4_I[0] + 
		Stage4_B[1]*Stage4_I[1] + Stage4_B[2]*Stage4_I[2];
	
	// update the matched filter's state
	for (i=0; i<2; i++) {
        Stage1_Q[2-i] = Stage1_Q[(2-i)-1];
		Stage2_Q[2-i] = Stage2_Q[(2-i)-1];
		Stage3_Q[2-i] = Stage3_Q[(2-i)-1];
		Stage4_Q[2-i] = Stage4_Q[(2-i)-1];

		Stage1_I[2-i] = Stage1_I[(2-i)-1];
		Stage2_I[2-i] = Stage2_I[(2-i)-1];
		Stage3_I[2-i] = Stage3_I[(2-i)-1];
		Stage4_I[2-i] = Stage4_I[(2-i)-1];
	}
	
	// apply the AGC gain
	Iscaled[0] = AGCgain*Output_I[4];
    Qscaled[0] = AGCgain*Output_Q[4];
    
    // calculate the new AGC gain
    magnitude = sqrtf(Iscaled[0]*Iscaled[0] + Qscaled[0]*Qscaled[0]);
    error = reference - magnitude;
    scaledError = alpha * error;
    AGCgain = AGCgain + scaledError;

    // increment the counter ... 0, 1, 2, 3, ... repeat
    fourcount++;
    if (fourcount > 3) {fourcount = 0;}
        
    phase = phase + phaseInc;
    // timing recovery and de-rotation control loops
    if(phase > 6.283185307179586) {
    	// GPIO control ... turn ON GPIO pin 6
     	WriteDigitalOutputs(1);
        phase -= 6.283185307179586;

        // de-rotation
        st = sinf(theta);
        ct = cosf(theta);
        Isampled = Iscaled[0]*ct - Qscaled[0]*st;
        Qsampled = Qscaled[0]*ct + Iscaled[0]*st;
    
        // slicer ... bit decisions
        if(Isampled > 0) {di = 1;}
        else {di = -1;}
        
        if(Qsampled > 0) {dq = 1;}
        else {dq = -1;}
    
        // de-rotation control ... calculate the new theta
        thetaAdj = (di*Qsampled - dq*Isampled)*thetaGain;
        theta = theta - thetaAdj;
        if(theta > 6.283185307179586) {theta -= 6.283185307179586;}
    
        // symbol timing adjustment
        symTimingAdj[0] = di*(Iscaled[0] - Iscaled[2]) + dq*(Qscaled[0] - Qscaled[2]);

        // MA filter of symTimingAdj (loop filter for the error signal)
        phaseAdj = 0;
        for (i = 0; i < 14; i++) {phaseAdj += symTimingAdj[i];}
        phaseAdj *= phaseGain/14;
        for (i = 13; i > 0; i--) {symTimingAdj[i] = symTimingAdj[i-1];}
	    phase -= phaseAdj;
        
        // GPIO control ... turn OFF GPIO pin 6
		WriteDigitalOutputs(0);
    }
    
    I = Iscaled[0]*ct - Qscaled[0]*st;
    Q = Qscaled[0]*ct + Iscaled[0]*st;
    
    // update memory
    Iscaled[2] = Iscaled[1];
    Iscaled[1] = Iscaled[0];
    Qscaled[2] = Qscaled[1];
    Qscaled[1] = Qscaled[0];
    
	CodecDataOut.Channel[RIGHT] = I;
	CodecDataOut.Channel[LEFT]  = Q;
	/* end your code here */
	
	WriteCodecData(CodecDataOut.UINT); // send output data to  port
}
