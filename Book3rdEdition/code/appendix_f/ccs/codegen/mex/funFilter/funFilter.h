/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * funFilter.h
 *
 * Code generation for function 'funFilter'
 *
 */

#ifndef __FUNFILTER_H__
#define __FUNFILTER_H__

/* Include files */
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "blas.h"
#include "rtwtypes.h"
#include "funFilter_types.h"

/* Function Declarations */
extern real32_T funFilter(const emlrtStack *sp, real32_T xLeft[4], const
  real32_T B[4], int16_T N);

#ifdef __WATCOMC__

#pragma aux funFilter value [8087];

#endif
#endif

/* End of code generation (funFilter.h) */
