// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

/* hilbert.c                            */
/* FIR filter coefficients              */
/* exported by MATLAB using FIR_dump2c  */

#include "hilbert.h"

float B_hilbert[N+1] = {
-0.067285646188, /* h[0] */
-0.000000000000, /* h[1] */
-0.567062082690, /* h[2] */
0.000000000000,	 /* h[3] */
0.567062082690,	 /* h[4] */
0.000000000000,	 /* h[5] */
0.067285646188,	 /* h[6] */
};
