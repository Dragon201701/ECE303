// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

// This code calculates the fft of an N point complex data sequence, x[N].

//   The fft of real input values can be calculated by omitting the 
//   x[].imag declarations. The fft results (the N complex numbers) are 
//   returned in x[N]. This algorithm is based on the discussion in,

//   "C Algorithms for Real-Time DSP", by Paul M. Embree
//   Prentice-Hall PTR, copyright 1995.

#include <math.h>
#include <stdio.h>
#include "fft.h"

#define PI 3.14159265358979323846
	
void fft_c(int n, COMPLEX *x, COMPLEX *W)
{
    COMPLEX u, temp, tm;
    COMPLEX *Wptr;

    int i, j, k, len, Windex; 

	/* start fft */
    Windex = 1;
    for(len = n/2 ; len > 0 ; len /= 2) {
        Wptr = W;
        for (j = 0 ; j < len ; j++) {
            u = *Wptr;
            for (i = j ; i < n ; i = i + 2*len) {
                temp.real = x[i].real + x[i+len].real;
                temp.imag = x[i].imag + x[i+len].imag;
                tm.real = x[i].real - x[i+len].real;
                tm.imag = x[i].imag - x[i+len].imag;             
                x[i+len].real = tm.real*u.real - tm.imag*u.imag;
                x[i+len].imag = tm.real*u.imag + tm.imag*u.real;
                x[i] = temp;
                
            }
            Wptr = Wptr + Windex;
        }
        Windex = 2*Windex;
    }
	
	/* rearrange data by bit reversing */
	j = 0;
	for (i = 1; i < (n-1); i++) {
		k = n/2;
		while(k <= j) {
			j -= k;
			k /= 2;
		}
		j += k;
		if (i < j) {
			temp = x[j];
			x[j] = x[i];
			x[i] = temp;
		}
	}
}

void init_W(int n, COMPLEX *W)
{
    int i;

	float a = 2.0*PI/n;

    for(i = 0 ; i < n ; i++) {
        W[i].real = (float) cos(-i*a);
        W[i].imag = (float) sin(-i*a);
    }
}
