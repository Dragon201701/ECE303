// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2011
 
///////////////////////////////////////////////////////////////////////
// Filename: DSK6713_Support.h
//
// Synopsis: Declarations for DSK6713_Support.c
//
///////////////////////////////////////////////////////////////////////

#ifndef	DSK6713_SUPPORT_H_INCLUDED
#define DSK6713_SUPPORT_H_INCLUDED

#include "tistdtypes.h"
#include <c6x.h>
#include "c6x11dsk.h"  

// enumeration of supported codecs and 6713 sample rates
enum CODEC_VERSION {DSK6713_LineInput, DSK6713_MicInput_0db, DSK6713_MicInput_20db};
enum SAMPLE_RATE_6713 {DSK6713_FS48KHZ, DSK6713_FS96KHZ, DSK6713_FS88KHZ, DSK6713_FS44KHZ, DSK6713_FS32KHZ, DSK6713_FS8KHZ};

// mcbsp mode selections
enum MCBSP_MODES {AD535_mode, PCM0_Master_mode, PCM0_Slave_mode, PCM0_Slave_Inverted_mode, AIC23_mode};
// enumeration for WriteLEDs
enum {USER_LED0=1, USER_LED1 = 2, USER_LED2 = 4, USER_LED3 = 8, USER_LED_MASK = 15};

// function prototypes

// defined in DSK_Support.c
 void  DSP_Init();
 void  DSP_Init_EDMA();
 void  Init_McBSP(McBSP *, Int32);
 void  Init_AIC23(Int32);
float  GetSampleFreq();
void   Init_6713PLL();
Uint32 WriteLEDs(Uint8);
Int32  ReadSwitches();
void   InitDigitalOutputs();
void   WriteDigitalOutputs(Uint8);

Uint32 ReadCodecData();
void   WriteCodecData(Uint32);
Uint32 CheckForOverrun();

// defined in StartUp.c (in application directory)
void  StartUp();


#endif
