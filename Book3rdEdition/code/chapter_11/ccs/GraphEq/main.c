// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017
 
///////////////////////////////////////////////////////////////////////
// Filename: main.c
//
// Synopsis: Main program file for graphic equalizer project
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h"   
#include "coeff.h"		// coefficients used by FIR filter
#include "coeff_lp.h"		// coefficients for equalizer
#include "coeff_bp1.h"
#include "coeff_bp2.h"
#include "coeff_bp3.h"
#include "coeff_hp.h"
 
volatile float new_gain_lp = 1, new_gain_bp1 = 1, new_gain_bp2 = 1;
volatile float new_gain_bp3 = 1, new_gain_hp = 1;
volatile float old_gain_lp = 0, old_gain_bp1 = 0, old_gain_bp2 = 0;
volatile float old_gain_bp3 = 0, old_gain_hp = 0;

void UpdateCoefficients()
{
	Int32 i;
	
	old_gain_lp  = new_gain_lp; // save new gain values
	old_gain_bp1 = new_gain_bp1;
	old_gain_bp2 = new_gain_bp2;
	old_gain_bp3 = new_gain_bp3;
	old_gain_hp  = new_gain_hp;
	
	for(i = 0; i <= N; i++) { // calculate new coefficients
		B[i] = (B_LP[i]  * old_gain_lp)  + (B_BP1[i] * old_gain_bp1)
			 + (B_BP2[i] * old_gain_bp2) + (B_BP3[i] * old_gain_bp3)
			 + (B_HP[i]  * old_gain_hp);
	}
}

int main()
{    
	UpdateCoefficients(); // update FIR filter coefficients
	
	// initialize DSP board
  	DSP_Init();
	
	// main stalls here, interrupts drive operation 
  	while(1) { 
  		// check if any gains have changed
		if((new_gain_lp != old_gain_lp) 
			|| (new_gain_bp1 != old_gain_bp1)
			|| (new_gain_bp2 != old_gain_bp2) 
			|| (new_gain_bp3 != old_gain_bp3)
			|| (new_gain_hp != old_gain_hp)) {
			UpdateCoefficients();
		}
  	}   
}


