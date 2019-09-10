/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_funFilter_api.h
 *
 * MATLAB Coder version            : 2.8
 * C/C++ source code generated on  : 23-Jul-2015 18:17:32
 */

#ifndef ___CODER_FUNFILTER_API_H__
#define ___CODER_FUNFILTER_API_H__

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_funFilter_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern real32_T funFilter(real32_T xLeft[4], real32_T B[4], int16_T N);
extern void funFilter_api(const mxArray *prhs[3], const mxArray *plhs[2]);
extern void funFilter_atexit(void);
extern void funFilter_initialize(void);
extern void funFilter_terminate(void);
extern void funFilter_xil_terminate(void);

#endif

/*
 * File trailer for _coder_funFilter_api.h
 *
 * [EOF]
 */
