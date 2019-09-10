// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017
 
///////////////////////////////////////////////////////////////////////
// Filename: DSP_Config.h
//
// Synopsis: Declarations for configuring the DSK6713 parameters
//
///////////////////////////////////////////////////////////////////////

#ifndef	DSP_Config_H_INCLUDED
#define DSP_Config_H_INCLUDED

#include "DSK6713_Support.h"  

// declarations for basic codec selection

// uncomment just the line for the codec in use
#define CodecType 		DSK6713_LineInput		// 6713 DSK using line input
//#define CodecType 		DSK6713_MicInput_0db	// 6713 DSK using microphone input, no preamp
//#define CodecType 		DSK6713_MicInput_20db	// 6713 DSK using microphone input, +20db preamp

// uncomment just the line for the sample rate when using the 6713 DSK
#define SampleRate6713 		DSK6713_FS48KHZ		// 6713 DSK at 48kHz sample rate
//#define SampleRate6713 		DSK6713_FS96KHZ		// 6713 DSK at 96kHz sample rate
//#define SampleRate6713 		DSK6713_FS88KHZ		// 6713 DSK at 88.2kHz sample rate
//#define SampleRate6713 		DSK6713_FS44KHZ		// 6713 DSK at 44.1kHz sample rate
//#define SampleRate6713 		DSK6713_FS32KHZ		// 6713 DSK at 32kHz sample rate
//#define SampleRate6713 		DSK6713_FS8KHZ		// 6713 DSK at 8kHz sample rate


#endif
