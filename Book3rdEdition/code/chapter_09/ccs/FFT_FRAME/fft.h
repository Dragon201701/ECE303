// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2017

// fft.h 

// define the COMPLEX structure
typedef struct {
    float real, imag;
} COMPLEX;

void fft_c(int, COMPLEX*, COMPLEX*);
void init_W(int, COMPLEX*);
