/* 4thIIRSOS.c                              */
/* SOS filter coefficients                  */
/* exported from MATLAB using SOS2c.m  */
/* order is {b0, b1, b2, a0, a1, a2}          */


#include "4thIIRSOS.h"

float B[B_SECTIONS][6] = {
{   0.0331984,    0.0663969,    0.0331984,  1,     -1.61173,     0.744521}, /* B[0] */
{   0.0281188,    0.0562375,    0.0281188,  1,     -1.36512,     0.477592}, /* B[1] */
};
