// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include "math.h"
#include "frames.h"  
  
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
// frame buffer declarations
//#define BUFFER_LENGTH   	96000	// buffer length in samples
#define BUFFER_LENGTH       64   // buffer length in samples
#define NUM_CHANNELS    	2		// supports stereo audio 
#define NUM_BUFFERS     	3		// don't change 
#define INITIAL_FILL_INDEX	0		// start filling this buffer
#define INITIAL_DUMP_INDEX	1		// start dumping this buffer

#pragma DATA_SECTION (buffer, "CE0"); // allocate buffers in external SDRAM 
volatile float buffer[NUM_BUFFERS][2][BUFFER_LENGTH];
// there are 3 buffers in use at all times, one being filled,
// one being operated on, and one being emptied
// fill_index   --> buffer being filled by the ADC
// dump_index --> buffer being written to the DAC
// ready_index --> buffer ready for processing
Uint8 buffer_ready = 0, over_run = 0, ready_index = 2;
void blockaverage(float *block){
    float sum = 0;
    int i = 0;
    for(i = 0; i < 64; i++)
        sum+=block[i];
    float average = sum/64;
    for(i = 0; i < 64; i++)
        block[i] = average;
}
void ZeroBuffers() 
////////////////////////////////////////////////////////////////////////
// Purpose:   Sets all buffer locations to 0.0 
// Input:     None
// Returns:   Nothing
// Calls:     Nothing
// Notes:     None
///////////////////////////////////////////////////////////////////////
{
    Uint32 i = BUFFER_LENGTH * NUM_BUFFERS * NUM_CHANNELS;

    volatile float *p = buffer[0][0];

    while(i--)
        *p++ = 0.0;
}

void ProcessBuffer()
///////////////////////////////////////////////////////////////////////
// Purpose:   Processes the data in buffer[ready_index] and stores
//  		  the results back into the buffer 
// Input:     None
// Returns:   Nothing
// Calls:     Nothing
// Notes:     None
///////////////////////////////////////////////////////////////////////
{   
	Uint32 i;
    volatile float *pL = buffer[ready_index][LEFT];
    volatile float *pR = buffer[ready_index][RIGHT];
    float temp;       
  
 // zero out left channel 
   for(i=0;i < BUFFER_LENGTH;i++){ 
		*pL = 0.0;
        pL++;
   }  

 
 // zero out right channel 
   for(i=0;i < BUFFER_LENGTH;i++){ 
		*pR = 0.0;
        pR++;
   }    

   blockaverage(pL);
   blockaverage(pR);
/* reverb on right channel   
   for(i=0;i < BUFFER_LENGTH-4;i++){ 
		*pR = *pR + (0.9 * pR[2]) + (0.45 * pR[4]);
        pR++;
   }              */
 
  
/* addition and subtraction 
   for(i=0;i < BUFFER_LENGTH;i++){ 
      temp = *pL;        
      *pL = temp + *pR; // left = L+R
      *pR = temp - *pR; // right = L-R 
      pL++;
      pR++;
    }   */
             
                   
/* add a sinusoid    
   for(i=0;i < BUFFER_LENGTH;i++){ 
      *pL = *pL + 1024*sinf(0.5*i);
      pL++;
    }    
*/                  
                   
/* AM modulation 
    for(i=0;i < BUFFER_LENGTH;i++){
      *pR = *pL * *pR; // right = L*R 
      *pL = *pL + *pR; // left = L*(1+R) 
      pL++;
      pR++;
    } 
*/
    buffer_ready = 0;
}

///////////////////////////////////////////////////////////////////////
// Purpose:   Access function for buffer ready flag 
//
// Input:     None
//
// Returns:   Non-zero when a buffer is ready for processing
//
// Calls:     Nothing
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
int IsBufferReady()
{
    return buffer_ready;
}

///////////////////////////////////////////////////////////////////////
// Purpose:   Access function for buffer overrun flag 
//
// Input:     None
//
// Returns:   Non-zero if a buffer overrun has occurred
//
// Calls:     Nothing
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
int IsOverRun()
{
    return over_run;
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
    static Uint8 fill_index = INITIAL_FILL_INDEX; // index of buffer to fill
    static Uint8 dump_index = INITIAL_DUMP_INDEX; // index of buffer to dump
    static Uint32 sample_count = 0; // current sample count in buffer

 	if(CheckForOverrun())					// overrun error occurred (i.e. halted DSP)
		return;								// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();		// get input data samples
	
	/* add your code starting here */

    // store input in buffer
    buffer[fill_index][ LEFT][sample_count] = CodecDataIn.Channel[ LEFT];
    buffer[fill_index][RIGHT][sample_count] = CodecDataIn.Channel[RIGHT];
    
 	// bound output data before packing
	// use saturation of SPINT to limit to 16-bits
	CodecDataOut.Channel[ LEFT] = _spint(buffer[dump_index][ LEFT][sample_count] * 65536) >> 16;
	CodecDataOut.Channel[RIGHT] = _spint(buffer[dump_index][RIGHT][sample_count] * 65536) >> 16;
    // pack output data without bounding 
//  CodecDataOut.channel[ LEFT] = buffer[dump_index][LEFT][sample_count];
//  CodecDataOut.channel[RIGHT] = buffer[dump_index][RIGHT][sample_count];

   // update sample count and swap buffers when filled 
    if(++sample_count >= BUFFER_LENGTH) {
        sample_count = 0;
        ready_index = fill_index;
        if(++fill_index >= NUM_BUFFERS)
            fill_index = 0;
        if(++dump_index >= NUM_BUFFERS)
            dump_index = 0;
        if(buffer_ready == 1) // set a flag if buffer isn't processed in time 
            over_run = 1;
        buffer_ready = 1;
    }


	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

