// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: frames.h
//
// Synopsis: Frame buffering/processing function declarations
//
///////////////////////////////////////////////////////////////////////

// defined in ISRs.c
void ZeroBuffers();
void ProcessBuffer();
int IsBufferReady();
int IsOverRun();
void EDMA_Init();
