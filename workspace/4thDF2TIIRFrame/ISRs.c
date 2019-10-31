// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: ISRs.c
//
// Synopsis: Interrupt service routines for OMAP-L138 EDMA 
//
// Modified April 2013 to "flip" the incoming samples properly -- chgw
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h" 
#include "math.h"
#include "frames.h"  
#include "4thIIRSOS.h"      // load the filter coefficients, B[n] ... extern
#include "DSPF_sp_biquad.h"
// frame buffer declarations
#define BUFFER_COUNT		1024   // buffer length in McASP samples (L+R)
#define BUFFER_LENGTH   	BUFFER_COUNT*2 // two Int16 read from McASP each time  
#define NUM_BUFFERS     	3     // don't change this! 

#pragma DATA_SECTION (buffer, "CE0"); // allocate buffers in SDRAM 
Int16 buffer[NUM_BUFFERS][BUFFER_LENGTH];
Int16 bufLeft[NUM_BUFFERS][BUFFER_LENGTH];
Int16 bufRight[NUM_BUFFERS][BUFFER_LENGTH];
// there are 3 buffers in use at all times, one being filled from the McBSP,
// one being operated on, and one being emptied to the McBSP
// ready_index --> buffer ready for processing
volatile Int16 buffer_ready = 0, over_run = 0, ready_index = 0;
float w[3] = {0.0,0.0,0.0};
float v[3] = {0.0,0.0,0.0};

// values used for EDMA channel initialization
#define EDMA_CONFIG_RX_OPTION				0x00100000	// TCINTEN, event 0
#ifdef DSPBOARDTYPE_TI_OMAPL138_LCDK
#define EDMA_CONFIG_RX_SRC_ADDR				((Uint32)(&(McASP0_Base->rbuf[14])))
#else
#define EDMA_CONFIG_RX_SRC_ADDR				((Uint32)(&(McASP0_Base->rbuf[12])))
#endif
#define EDMA_CONFIG_RX_SRC_DEST_B_INDEX		((4 << 16) + 0)	// src_b_index = 0, dest_b_index = 4
#define EDMA_CONFIG_RX_A_B_COUNT			((BUFFER_COUNT << 16) + 4)	// 4-byte transfers
#define EDMA_CONFIG_TX_OPTION				0x00101000	// TCINTEN, event 1
#ifdef DSPBOARDTYPE_TI_OMAPL138_LCDK
#define EDMA_CONFIG_TX_DEST_ADDR			((Uint32)(&(McASP0_Base->xbuf[13])))
#else
#define EDMA_CONFIG_TX_DEST_ADDR			((Uint32)(&(McASP0_Base->xbuf[11])))
#endif
#define EDMA_CONFIG_TX_SRC_DEST_B_INDEX		((0 << 16) + 4)	// src_b_index = 4, dest_b_index = 0
#define EDMA_CONFIG_TX_A_B_COUNT			EDMA_CONFIG_RX_A_B_COUNT
#define EDMA_CONFIG_EVENT_MASK				3	// using events 0 (rx) and 1 (tx)
#define EDMA_CONFIG_INTERRUPT_MASK			1	// interrupt on rx reload only

void EDMA_Init()
////////////////////////////////////////////////////////////////////////
// Purpose:   Configure EDMA controller to perform all McASP servicing. 
//            EDMA is setup so buffer[2] is outbound to McASP, buffer[0] is 
//            available for processing, and buffer[1] is being loaded.
//            Both the EDMA transmit and receive events are set to automatically
//            reload upon completion, cycling through the 3 buffers. 
//            The EDMA completion interrupt occurs when a buffer has been filled
//            by the EDMA from the McASP.
//            The EDMA interrupt service routine updates the ready buffer index, 
//            and sets the buffer ready flag which is being polled by the main 
//            program loop
//
// Input:     None
//
// Returns:   Nothing
//
// Calls:     Nothing
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{
	EDMA_params* param;

	// McASP tx event params
	param = (EDMA_params*)EDMA3_0_PARAM(EDMA3_EVENT_MCASP0_TX);
	param->option = EDMA_CONFIG_TX_OPTION;
	param->source = (Uint32)(&buffer[2][0]);
	param->a_b_count = EDMA_CONFIG_TX_A_B_COUNT;
	param->dest = EDMA_CONFIG_TX_DEST_ADDR;
	param->src_dest_b_index = EDMA_CONFIG_TX_SRC_DEST_B_INDEX;
	param->link_reload = (BUFFER_COUNT << 16) + (EDMA3_0_PARAM(64) & 0xFFFF);
	param->c_count = 1;
	
	// set up first tx link param
	param = (EDMA_params*)EDMA3_0_PARAM(64);
	param->option = EDMA_CONFIG_TX_OPTION;
	param->source = (Uint32)(&buffer[0][0]);
	param->a_b_count = EDMA_CONFIG_TX_A_B_COUNT;
	param->dest = EDMA_CONFIG_TX_DEST_ADDR;
	param->src_dest_b_index = EDMA_CONFIG_TX_SRC_DEST_B_INDEX;
	param->link_reload = (BUFFER_COUNT << 16) + (EDMA3_0_PARAM(65) & 0xFFFF);
	param->c_count = 1;
	
	// set up second tx link param
	param = (EDMA_params*)EDMA3_0_PARAM(65);
	param->option = EDMA_CONFIG_TX_OPTION;
	param->source = (Uint32)(&buffer[1][0]);
	param->a_b_count = EDMA_CONFIG_TX_A_B_COUNT;
	param->dest = EDMA_CONFIG_TX_DEST_ADDR;
	param->src_dest_b_index = EDMA_CONFIG_TX_SRC_DEST_B_INDEX;
	param->link_reload = (BUFFER_COUNT << 16) + (EDMA3_0_PARAM(66) & 0xFFFF);
	param->c_count = 1;
	
	// set up third tx link param
	param = (EDMA_params*)EDMA3_0_PARAM(66);
	param->option = EDMA_CONFIG_TX_OPTION;
	param->source = (Uint32)(&buffer[2][0]);
	param->a_b_count = EDMA_CONFIG_TX_A_B_COUNT;
	param->dest = EDMA_CONFIG_TX_DEST_ADDR;
	param->src_dest_b_index = EDMA_CONFIG_TX_SRC_DEST_B_INDEX;
	param->link_reload = (BUFFER_COUNT << 16) + (EDMA3_0_PARAM(64) & 0xFFFF);
	param->c_count = 1;
	
	
	// McASP rx event params
	param = (EDMA_params*)(EDMA3_0_PARAM(EDMA3_EVENT_MCASP0_RX));
	param->option = EDMA_CONFIG_RX_OPTION;
	param->source = EDMA_CONFIG_RX_SRC_ADDR;
	param->a_b_count = EDMA_CONFIG_RX_A_B_COUNT;
	param->dest = (Uint32)(&buffer[1][0]);
	param->src_dest_b_index = EDMA_CONFIG_RX_SRC_DEST_B_INDEX;
	param->link_reload = (BUFFER_COUNT << 16) + (EDMA3_0_PARAM(67) & 0xFFFF);
	param->c_count = 1;
	
	// set up first rx link param
	param = (EDMA_params*)EDMA3_0_PARAM(67);
	param->option = EDMA_CONFIG_RX_OPTION;
	param->source = EDMA_CONFIG_RX_SRC_ADDR;
	param->a_b_count = EDMA_CONFIG_RX_A_B_COUNT;
	param->dest = (Uint32)(&buffer[2][0]);
	param->src_dest_b_index = EDMA_CONFIG_RX_SRC_DEST_B_INDEX;
	param->link_reload = (BUFFER_COUNT << 16) + (EDMA3_0_PARAM(68) & 0xFFFF);
	param->c_count = 1;
	
	// set up second rx link param
	param = (EDMA_params*)EDMA3_0_PARAM(68);
	param->option = EDMA_CONFIG_RX_OPTION;
	param->source = EDMA_CONFIG_RX_SRC_ADDR;
	param->a_b_count = EDMA_CONFIG_RX_A_B_COUNT;
	param->dest = (Uint32)(&buffer[0][0]);
	param->src_dest_b_index = EDMA_CONFIG_RX_SRC_DEST_B_INDEX;
	param->link_reload = (BUFFER_COUNT << 16) + (EDMA3_0_PARAM(69) & 0xFFFF);
	param->c_count = 1;
	
	// set up third rx link param
	param = (EDMA_params*)EDMA3_0_PARAM(69);
	param->option = EDMA_CONFIG_RX_OPTION;
	param->source = EDMA_CONFIG_RX_SRC_ADDR;
	param->a_b_count = EDMA_CONFIG_RX_A_B_COUNT;
	param->dest = (Uint32)(&buffer[1][0]);
	param->src_dest_b_index = EDMA_CONFIG_RX_SRC_DEST_B_INDEX;
	param->link_reload = (BUFFER_COUNT << 16) + (EDMA3_0_PARAM(67) & 0xFFFF);
	param->c_count = 1;
	
	// configure EDMA to start servicing events
	*(volatile Uint32 *)EDMA3_0_CC_ECR  = EDMA_CONFIG_EVENT_MASK;	// clear pending events
	*(volatile Uint32 *)EDMA3_0_CC_EESR = EDMA_CONFIG_EVENT_MASK;	// enable events 
	*(volatile Uint32 *)EDMA3_0_CC_DRAE1 = EDMA_CONFIG_EVENT_MASK;	// enable events for region 1
	*(volatile Uint32 *)EDMA3_0_CC_IESR = EDMA_CONFIG_INTERRUPT_MASK; 	// enable CPU interrupt
}

void ZeroBuffers() 
////////////////////////////////////////////////////////////////////////
// Purpose:   Sets all buffer locations to 0 
//
// Input:     None
//
// Returns:   Nothing
//
// Calls:     Nothing
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{
	Int32 i = BUFFER_COUNT * NUM_BUFFERS;
	Int32 *p = (Int32 *)buffer;

	while(i--)
		*p++ = 0;
}

void ProcessBuffer()
///////////////////////////////////////////////////////////////////////
// Purpose:   Processes the data in buffer[ready_index] and stores
//            the results back into the buffer 
//            Data is packed into the buffer, alternating right/left
//              Be careful of the order of packing
//
// Input:     None
//
// Returns:   Nothing
//
// Calls:     Nothing
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{   
	Int16 *pBuf = buffer[ready_index];
    // extra buffer room for convolution "edge effects"
    // N is filter order from coeff.h
	static float Left[BUFFER_COUNT+N]={0}, Right[BUFFER_COUNT+N]={0};
	float *pL = Left, *pR = Right;
	float y;
	float yLeft, yRight;
	float a[2][3], b[2][3];
	float tmp;
	float input;

	Int32 i, j, k;

    // offset pointers to start filling after N elements
	pR += N;
	pL += N;

    for(i = 0;i < BUFFER_COUNT;i++) { // extract data to float buffers
    // order is important here: must go right first then left
    	*pR++ = *pBuf++;
    	*pL++ = *pBuf++;
    }

    // reinitialize pointer before FOR loop
    pBuf = buffer[ready_index];

////////////////////////////////////////
// Implement FIR filter
// Ensure COEFF.C is part of project
////////////////////////////////////////  
    for(j = 0; j < 3; j++){
    	a[0][j] = B[0][j+3];
    	a[1][j] = B[1][j+3];
    	b[0][j] = B[0][j];
    	b[1][j] = B[1][j];
    }

    for(i=0;i < BUFFER_COUNT;i++){
    	yLeft  = 0;                      // initialize the LEFT output value
    	yRight = 0;                      // initialize the RIGHT output value

      /*for(j=0,k=i+N;j <= N;j++,k--){ 
        yLeft  += Left[k] * B[j];        // perform the LEFT dot-product
        yRight += Right[k] * B[j];        // perform the RIGHT dot-product
      }*/
    //	v[0] = Right[i+2] - Right[i+1]*a[0][1]*v[1] - Right[i]*a[0][2]*v[2];
    	// tmp = b[0][0]*v[0] + b[0][1]*v[1] + b[0][2]*v[2];


    	/*w[0] = tmp - a[1][1]*w[1] - a[1][2]*w[2];
    	y = b[1][0]*w[0] + b[1][1]*w[1] + b[1][2]*w[2];

    	w[2] = w[1];
    	w[1] = w[0];
    	v[2] = v[1];
    	v[1] = v[0];*/
    	for(j = 0; j < 2; j++){
                v[0] = Right[i+j] - a[0][1] * v[1] - a[0][2] * v[2];
                tmp = v[0] * b[0][0] + v[1] * b[0][1] + v[2] * b[0][2];
                w[0] = tmp - a[1][1] * w[1] - a[1][2] * w[2];
                y = w[0] * b[1][0] + w[1] * b[1][1] + w[2] * b[1][2];
                w[2] = w[1];
                w[1] = w[0];
                v[2] = v[1];
                v[1] = v[0];
    	}

    	yRight = Right[i];
    	yLeft = Left[i];

    	// pack into buffer after bounding (must be right then left)
    	*pBuf++ = _spint(yRight * 65536) >> 16;
    	*pBuf++ = _spint(yLeft * 65536) >> 16;

    }  

   // save end values at end of buffer array for next pass
   //  by placing at beginning of buffer array
    for(i=BUFFER_COUNT,j=0;i < BUFFER_COUNT+N;i++,j++){ 
    	Left[j]=Left[i];
    	Right[j]=Right[i];
    }

//////// end of FIR routine ///////////  

    // reinitialize pointer
    pBuf = buffer[ready_index];
    buffer_ready = 0; // signal we are done
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

interrupt void EDMA_ISR()
///////////////////////////////////////////////////////////////////////
// Purpose:   EDMA interrupt service routine.  Invoked on every buffer 
//            completion 
//
// Input:     None
//
// Returns:   Nothing
//
// Calls:     Nothing
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{
	*(volatile Uint32 *)EDMA3_0_CC_ICR = EDMA_CONFIG_INTERRUPT_MASK; // clear interrupt
	if(++ready_index >= NUM_BUFFERS) // update buffer index
		ready_index = 0;
	if(buffer_ready == 1) // set a flag if buffer isn't processed in time 
		over_run = 1;
	buffer_ready = 1; // mark buffer as ready for processing
}

