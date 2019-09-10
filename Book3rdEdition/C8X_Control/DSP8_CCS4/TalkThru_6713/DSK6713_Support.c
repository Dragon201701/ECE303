// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2011

///////////////////////////////////////////////////////////////////////
// Filename: DSK6713_Support.c
//
// Synopsis: Functions to support basic initialization of the DSK
//           hardware resources.
//
///////////////////////////////////////////////////////////////////////

#include "DSK6713_Support.h"   
#include "DSP_Config.h"   


static float SampleFreq;

///////////////////////////////////////////////////////////////////////
// Purpose:   Returns the current sample frequency as determined by the 
//            DSK_Init function.
//
// Input:     None
//
// Returns:   Sample frequency in floating point format
//
// Calls:     None
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
float GetSampleFreq()
{
	return SampleFreq;
}

Uint32 ReadCodecData()
///////////////////////////////////////////////////////////////////////
// Purpose:   Read McBSP receive data
//
// Input:     None
//
// Returns:   Data from McBSP
//
// Calls:     Nothing 
//
// Notes:     Assumes data is ready
///////////////////////////////////////////////////////////////////////
{
	volatile McBSP *port = McBSP1_Base;			// McBSP1 used with codec daughtercards
 
	return port->drr;
}

void WriteCodecData(Uint32 data)
///////////////////////////////////////////////////////////////////////
// Purpose:   Write McASP transmit data
//
// Input:     data - data to write to McBSP
//
// Returns:   Nothing
//
// Calls:     Nothing 
//
// Notes:     Assumes transmitter is ready
///////////////////////////////////////////////////////////////////////
{
	volatile McBSP *port = McBSP1_Base;			// McBSP1 used with codec daughtercards
 
	port->dxr = data;
}

Uint32 CheckForOverrun()
///////////////////////////////////////////////////////////////////////
// Purpose:   Not required with the 6713
//
// Input:     None
//
// Returns:   0 (no overrun)
//
// Calls:     Nothing 
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{
	return 0;
}

Uint32 WriteLEDs(Uint8 led_bits)
///////////////////////////////////////////////////////////////////////
// Purpose:   Writes to user LEDs on board  
//
// Input:     None
//
// Returns:   1 on success, 0 on failure
//
// Calls:     Nothing 
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{
	Uint8 data;
		data = led_bits & USER_LED_MASK;	// LEDs are active-high
		*(Uint8 *)IO_PORT = data;
	return 1;
}

Int32  ReadSwitches()
///////////////////////////////////////////////////////////////////////
// Purpose:   Reads user DIP switches  
//
// Input:     None
//
// Returns:   Switch state
//
// Calls:     Nothing
//
// Notes:     Switches are active low - ON returns 0 in that bit
///////////////////////////////////////////////////////////////////////
{
	return (*(Uint8 *)IO_PORT) >> 4;
}

void InitDigitalOutputs()
///////////////////////////////////////////////////////////////////////
// Purpose:   Initializes digital output pins on board  
//            On the 6713 DSK, the user LEDs are used for this 
//            purpose since they are directly written to
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
	WriteLEDs(0);
}

void WriteDigitalOutputs(Uint8 data)
///////////////////////////////////////////////////////////////////////
// Purpose:   Writes to digital output pins on board  
//            On the 6713 DSK, the user LEDs are used for this 
//            purpose since they are directly written to
//
// Input:     data - value written to outputs
//
// Returns:   Nothing
//
// Calls:     Nothing 
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{
	WriteLEDs(data);
}

void Init_AIC23(Int32 codec)
///////////////////////////////////////////////////////////////////////
// Purpose:   Performs initialization of the 6713 DSK's onboard codec
//
// Input:     codec - selects which input mode of the AIC23
//            codec to use (line, mic 0db, mic 20db)
//
// Returns:   Nothing
//
// Calls:     Nothing
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{	
	#define NUM_AIC23_REGISTERS 10
	McBSP *port  = McBSP0_Base;
	volatile Int32 i, j;
	Uint16 AIC23_data[NUM_AIC23_REGISTERS] = {
		// line inputs have ~6db attentuation network on DSK
    	(0<<9) | 0x01b, // reg 0 - left line volume (+6 db)
    	(1<<9) | 0x01b, // reg 1 - right line volume (+6 db)
    	(2<<9) | 0x0f9, // reg 2 - left headphone volume (0 db)
    	(3<<9) | 0x0f9, // reg 3 - right headphone volume (0 db)
    	(4<<9) | 0x012, // reg 4 - analog audio path (DAC on, line input)
    	(5<<9) | 0x000, // reg 5 - digital audio path (no deemphasis)
    	(6<<9) | 0x000, // reg 6 - power down (all on)
    	(7<<9) | 0x053, // reg 7 - digital audio interface (DSP mode)
    	(8<<9) | 0x001, // reg 8 - sample rate (48kHz)
    	(9<<9) | 0x001  // reg 9 - digital interface (activate)
	};
	
	// set AIC23 input mode (defaults to line in)
	switch(codec) {
		case DSK6713_MicInput_0db:
			AIC23_data[4] = (4<<9) | 0x014; // reg 4 - analog audio path (DAC on, mic input, 0db)
			break;
		case DSK6713_MicInput_20db:
			AIC23_data[4] = (4<<9) | 0x015; // reg 4 - analog audio path (DAC on, mic input, +20db)
			break;
	}

	port->spcr = 0;          	// reset port
	port->pcr  = 0x00000A0A; 	// fsxm/clkx outputs, spi format
	port->rcr  = 0x00000000;
	port->xcr  = 0x00000040; 	// single 16-bit word
	port->srgr = 0x20100F04; 	// fs on write, 16-bits,  
	port->spcr = 0x00C00000; 	// start fsg 
	for(i = 0;i < 1000;i++)		// delay
		;
	port->spcr = 0x00C11000; 	// enable tx, clkstp for spi

	while(!(port->spcr & 0x00020000)) // wait for tx complete
		;
	port->dxr = (15<<9) | 0x00; // force codec reset
	for(i = 0;i < 100000;i++)	// delay
		;

	for(i = 0;i < NUM_AIC23_REGISTERS;i++) { // program codec registers
		while(!(port->spcr & 0x00020000)) // wait for tx complete
			;
		port->dxr = AIC23_data[i]; // write codec registers
	}
	
	while(!(port->spcr & 0x00020000)) // wait for tx complete
		;
	//reset AIC23 sample rate if needed (init defaults to 48kHz)
	switch(SampleRate6713) {
		case DSK6713_FS96KHZ:
			port->dxr = (8<<9) | 0x01D; // 96kHz
			SampleFreq = 96000.0;	 
			break;
		case DSK6713_FS88KHZ:
			port->dxr = (8<<9) | 0x03F; // 88.2kHz
			SampleFreq = 88200.0;	 
			break;
		case DSK6713_FS44KHZ:
			port->dxr = (8<<9) | 0x023; // 44.1kHz
			SampleFreq = 44100.0;	 
			break;
		case DSK6713_FS32KHZ:
			port->dxr = (8<<9) | 0x019; // 32kHz
			SampleFreq = 32000.0;	 
			break;
		case DSK6713_FS8KHZ:
			port->dxr = (8<<9) | 0x00D; // 8kHz
			SampleFreq = 8000.0;	 
			break;
		default:
			SampleFreq = 48000.0;	 
			break;
	}
	
	Init_McBSP(McBSP1_Base, AIC23_mode); // initialize data link codec
}				 


void DSP_Init()
///////////////////////////////////////////////////////////////////////
// Purpose:   Performs basic hardware initialization of the DSK 
//            interrupts, serial ports
//
// Input:     Nothing
//
// Returns:   Nothing
//
// Calls:     Init_6713PLL(), Init_AIC23()
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{
  	CSR=0x100;			        		// disable all interrupts
  	IER=0;
	
	Init_6713PLL();								// set up 6713 PLL
	*(volatile Uint32*)IMH = 0x35803DC3; 		// assign McBSP1 to INT11/12	
	Init_AIC23(CodecType);						// initialize codec using McBSP0 

  	IER |= 0x1002;  					// enable McBSP Rx interrupts (12)
  	ICR = 0xffff;       				// clear all pending interrupts
  	CSR |= 1;           				// set GIE
}

void DSP_Init_EDMA()
///////////////////////////////////////////////////////////////////////
// Purpose:   Performs basic hardware initialization of the DSK 
//            interrupts, serial ports(for use with EDMA)
//
// Input:     Nothing
//
// Returns:   Nothing
//
// Calls:     Init_6713PLL(), Init_AIC23()
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{
  	CSR=0x100;			        	// disable all interrupts
  	IER=0;
	
	Init_6713PLL();
	Init_AIC23(CodecType);			// initialize codec using McBSP0 

  	IER |= 0x0102;  				// enable EDMA interrupt (INT8)
  	ICR = 0xffff;       			// clear all pending interrupts
  	CSR |= 1;           			// set GIE
}


void Init_McBSP(McBSP *port, Int32 mode)
///////////////////////////////////////////////////////////////////////
// Purpose:   Initializes McBSP to support the selected codec. For stereo
//            codecs, the port is configured so that both 16-bit 
//            channel's data is packed into a single 32-bit word
//
// Input:     mode - selected codec to support
//
// Returns:   Nothing
//
// Calls:     Nothing
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{   
	switch(mode) {
	case PCM0_Master_mode:	// PCM300X format 0, master
		port->spcr = 0;          /* reset port */
		port->pcr  = 0x00000A03; /* fsx/clkx output, fsr, clkr input */                          
		/* srg set up for clks/8, 32 bits, fsr width = 16bits */
		port->srgr = (1 << 28) + (31 << 16) + (15 << 8) + (7);
		port->rcr  = 0x000400A0; /* 1-phase, 32-bits */
		port->xcr  = 0x000400A0; 
		/* delay */
		port->spcr = 0x00400000; /* start srg */ 
		/* delay */
		port->spcr = 0x00C00000; /* start fsg */ 
		/* delay */
		port->spcr = 0x00C10001; /* enable tx/rx */
		port->dxr  = 0;
		break;
	case PCM0_Slave_mode:	// PCM300X format 0, slave
		port->spcr = 0;          /* reset port */
		port->pcr  = 0x00000003; /* fsx/clkx/fsr/clkr input */                          
		port->srgr = 0;  		 /* srgr disabled */
		port->rcr  = 0x000400A0; /* 1-phase, 32-bits */
		port->xcr  = 0x000400A0; 
		port->spcr = 0x00010001; /* enable tx/rx */
		port->dxr  = 0;
		break;	
	case PCM0_Slave_Inverted_mode:	// PCM300X format 0, slave with inverted signals
		port->spcr = 0;          /* reset port */
		port->pcr  = 0x00000000; /* fs/clk input */                          
		port->srgr = 0;  		 /* srgr disabled */
		port->rcr  = 0x000400A0; /* 1-phase, 32-bits */
		port->xcr  = 0x000400A0; 
		port->spcr = 0x00010001; /* enable tx/rx */
		port->dxr  = 0;
		break;
	case AIC23_mode: // using AIC23 codec in DSP mode
		port->spcr = 0;          /* reset port */
		port->pcr  = 0x0000000f; /* fsx/clkx/fsr/clkr input, fs active low */                          
		port->srgr = 0;  		 /* srgr disabled */
		port->rcr  = 0x000400A0; /* 1-phase, 32-bits */
		port->xcr  = 0x000400A0; 
		port->spcr = 0x00010001; /* enable tx/rx */
		port->dxr  = 0;
		break;	
	case AD535_mode: 
	default:
		port->spcr = 0;
		port->pcr  = 0;
		port->rcr  = 0x10040;
		port->xcr  = 0x10040;
		port->spcr = 0x12001;  
		port->dxr  = 0;
		break;
	}
}

// defines for 6713 PLL registers
#define PLL_BASE_ADDR   0x01b7c000
#define PLL_PID         (PLL_BASE_ADDR + 0x000)
#define PLL_CSR         (PLL_BASE_ADDR + 0x100)
#define PLL_MULT        (PLL_BASE_ADDR + 0x110)
#define PLL_DIV0        (PLL_BASE_ADDR + 0x114)
#define PLL_DIV1        (PLL_BASE_ADDR + 0x118)
#define PLL_DIV2        (PLL_BASE_ADDR + 0x11C)
#define PLL_DIV3        (PLL_BASE_ADDR + 0x120)
#define PLL_OSCDIV1     (PLL_BASE_ADDR + 0x124)
#define CSR_PLLEN          0x00000001
#define CSR_PLLPWRDN       0x00000002
#define CSR_PLLRST         0x00000008 
#define CSR_PLLSTABLE      0x00000040
#define DIV_ENABLE         0x00008000

void Init_6713PLL()
///////////////////////////////////////////////////////////////////////
// Purpose:   Configures the 6713 PLL for 225MHz clock
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
	*(Uint32 *)PLL_CSR = 		0x00000048; 	// Set the PLL back to power on reset state
	*(Uint32 *)PLL_DIV3 = 		0x00008001;
	*(Uint32 *)PLL_DIV2 = 		0x00008001;
	*(Uint32 *)PLL_DIV1 = 		0x00008000;
	*(Uint32 *)PLL_DIV0 = 		0x00008000;
	*(Uint32 *)PLL_MULT = 		0x00000007;
	*(Uint32 *)PLL_MULT = 		0x00000007;
	*(Uint32 *)PLL_OSCDIV1 = 	0x00080007;
	*(Uint32 *)PLL_DIV0 = 		DIV_ENABLE + 0; // now set for 225MHz
	*(Uint32 *)PLL_MULT = 		9;
	*(Uint32 *)PLL_OSCDIV1 = 	DIV_ENABLE + 4;
	*(Uint32 *)PLL_DIV3 = 		DIV_ENABLE + 4;
	*(Uint32 *)PLL_DIV2 = 		DIV_ENABLE + 3;
	*(Uint32 *)PLL_DIV1 = 		DIV_ENABLE + 1;
	*(Uint32 *)PLL_CSR = 		0x00000040; 	// out of reset
	*(Uint32 *)PLL_CSR = 		0x00000041;  	// enable
}
