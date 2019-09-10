/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: funFilter.c
 *
 * MATLAB Coder version            : 2.8
 * C/C++ source code generated on  : 23-Jul-2015 18:17:32
 */

/* Include Files */
#include "funFilter.h"

/* Function Definitions */

/*
 * initializes the output value
 * Arguments    : float xLeft[4]
 *                const float B[4]
 *                short N
 * Return Type  : float
 */
float funFilter(float xLeft[4], const float B[4], short N)
{
  float yLeft;
  short i;
  yLeft = 0.0F;

  /*  performs the dot product of B and x */
  for (i = 1; i <= (short)(N + 1); i++) {
    yLeft += B[i - 1] * xLeft[i - 1];
  }

  /*  shift the stored x samples to the right */
  for (i = N; i > 0; i--) {
    xLeft[(short)(i + 1) - 1] = xLeft[i - 1];
  }

  return yLeft;
}

/*
 * File trailer for funFilter.c
 *
 * [EOF]
 */
