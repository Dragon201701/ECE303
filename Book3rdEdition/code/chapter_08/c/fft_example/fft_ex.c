// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2011, 2017

////////////////////////////////////////////////////////////////
// Filename: fft_ex.c
//
// Synopsis: Example FFT routine. Can run on nearly any CPU that
//   supports a C compiler. This code calculates the FFT 
//   (decimation-in-time) of an N point complex data sequence.
//
//   This algorithm is based on the discussion in
//   "C Algorithms for Real-Time DSP", by Paul M. Embree
//   Prentice-Hall PTR, copyright 1995.
//
// Note: This is NOT a real-time program
////////////////////////////////////////////////////////////////

#include <math.h>
#include <stdio.h>

// define the COMPLEX structure 
// floats used as DSP target is intended; could be double on PC
typedef struct {
    float real, imag;
} COMPLEX;

// function prototypes 
void fft_c(int n, COMPLEX *x, COMPLEX *W);
void init_W(int n, COMPLEX *W);

#define PI 3.1415926535897932
#define N 16  // hardcoded for this example

// hardcode a simple input sequence for this example
//   this can be changed to any power-of-two length sequence
COMPLEX x[N] = {
    {0, 0}, // x[0]
    {1, 0}, // x[1]
    {2, 0}, // x[2]
    {3, 0}, // x[3]
    {4, 0}, // x[4]
    {5, 0}, // x[5]
    {6, 0}, // x[6]
    {7, 0}, // x[7]
    {0, 0}, // x[8]
    {0, 0}, // x[9]
    {0, 0}, // x[10]
    {0, 0}, // x[11]
    {0, 0}, // x[12]
    {0, 0}, // x[13]
    {0, 0}, // x[14]
    {0, 0}  // x[15]
    };
    
COMPLEX W[N];  // for twiddle factors
////////////////////////////////////////////

void main()  // not a real-time program
{
    int i;

    // initialize real and imaginary parts of the twiddle factors 
    init_W(N, W);
    
    // calculate the FFT of x[N] 
    fft_c(N, x, W);

    // display the results  
    printf("\n  i    real part    imag part \n\n");
    for(i = 0 ; i < N ; i++) 
        printf("%3d %12.5f %12.5f \n", i, x[i].real, x[i].imag);
    printf("\n");
}

void fft_c(int n, COMPLEX *x, COMPLEX *W)
///////////////////////////////////////////////////////////////////////
// Purpose:   Calculate the radix-2 decimation-in-time FFT.
//
// Input:     n: length of FFT, x: input array of complex numbers,
//            W: array of precomputed twiddle factors
//
// Returns:   values in array x are replaced with result
//
// Calls:     Nothing
//
// Notes:     Bit-reversed address reordering of the sequence 
//            is performed in this function.
///////////////////////////////////////////////////////////////////////
{
    COMPLEX u, temp, tm;
    COMPLEX *Wptr;

    int i, j, k, len, Windex; 
    
    // perform fft butterfly
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
    
    // rearrange data by bit reversed addressing 
    // this step must occur after the fft butterfly
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
    
}  // end of fft_c function

void init_W(int n, COMPLEX *W)
///////////////////////////////////////////////////////////////////////
// Purpose:   Calculate the twiddle factors needed by the FFT.
//
// Input:     n: length of FFT, W: array to store twiddle factors
//
// Returns:   values are stored in array W
//
// Calls:     Nothing
//
// Notes:     Floats used rather than double as this is intended
//            for a DSP CPU target.  Could change to double.
///////////////////////////////////////////////////////////////////////
{
    int i;

    float a = 2.0*PI/n;

    for(i = 0 ; i < n ; i++) {
        W[i].real = (float) cos(-i*a);
        W[i].imag = (float) sin(-i*a);
    }
}
