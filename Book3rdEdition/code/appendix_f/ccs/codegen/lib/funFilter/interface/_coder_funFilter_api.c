/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_funFilter_api.c
 *
 * MATLAB Coder version            : 2.8
 * C/C++ source code generated on  : 23-Jul-2015 18:17:32
 */

/* Include Files */
#include "tmwtypes.h"
#include "_coder_funFilter_api.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true, false, 131418U, NULL, "funFilter",
  NULL, false, { 2045744189U, 2170104910U, 2743257031U, 4284093946U }, NULL };

/* Function Declarations */
static real32_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId))[4];
static const mxArray *b_emlrt_marshallOut(const real32_T u);
static int16_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *N, const
  char_T *identifier);
static int16_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static real32_T (*e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[4];
static real32_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *xLeft,
  const char_T *identifier))[4];
static void emlrt_marshallOut(const real32_T u[4], const mxArray *y);
static int16_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId);

/* Function Definitions */

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real32_T (*)[4]
 */
static real32_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId))[4]
{
  real32_T (*y)[4];
  y = e_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
/*
 * Arguments    : const real32_T u
 * Return Type  : const mxArray *
 */
  static const mxArray *b_emlrt_marshallOut(const real32_T u)
{
  const mxArray *y;
  const mxArray *m0;
  y = NULL;
  m0 = emlrtCreateNumericMatrix(1, 1, mxSINGLE_CLASS, mxREAL);
  *(real32_T *)mxGetData(m0) = u;
  emlrtAssign(&y, m0);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *N
 *                const char_T *identifier
 * Return Type  : int16_T
 */
static int16_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *N, const
  char_T *identifier)
{
  int16_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  y = d_emlrt_marshallIn(sp, emlrtAlias(N), &thisId);
  emlrtDestroyArray(&N);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : int16_T
 */
static int16_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  int16_T y;
  y = f_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real32_T (*)[4]
 */
static real32_T (*e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[4]
{
  real32_T (*ret)[4];
  int32_T iv1[2];
  int32_T i0;
  for (i0 = 0; i0 < 2; i0++) {
    iv1[i0] = 1 + 3 * i0;
  }

  emlrtCheckBuiltInR2012b(sp, msgId, src, "single", false, 2U, iv1);
  ret = (real32_T (*)[4])mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}
/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *xLeft
 *                const char_T *identifier
 * Return Type  : real32_T (*)[4]
 */
  static real32_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *xLeft,
  const char_T *identifier))[4]
{
  real32_T (*y)[4];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  y = b_emlrt_marshallIn(sp, emlrtAlias(xLeft), &thisId);
  emlrtDestroyArray(&xLeft);
  return y;
}

/*
 * Arguments    : const real32_T u[4]
 *                const mxArray *y
 * Return Type  : void
 */
static void emlrt_marshallOut(const real32_T u[4], const mxArray *y)
{
  static const int32_T iv0[2] = { 1, 4 };

  mxSetData((mxArray *)y, (void *)u);
  emlrtSetDimensions((mxArray *)y, iv0, 2);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : int16_T
 */
static int16_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId)
{
  int16_T ret;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "int16", false, 0U, 0);
  ret = *(int16_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const mxArray *prhs[3]
 *                const mxArray *plhs[2]
 * Return Type  : void
 */
void funFilter_api(const mxArray *prhs[3], const mxArray *plhs[2])
{
  real32_T (*xLeft)[4];
  real32_T (*B)[4];
  int16_T N;
  real32_T yLeft;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  prhs[0] = emlrtProtectR2012b(prhs[0], 0, true, -1);
  prhs[1] = emlrtProtectR2012b(prhs[1], 1, false, -1);

  /* Marshall function inputs */
  xLeft = emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "xLeft");
  B = emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "B");
  N = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[2]), "N");

  /* Invoke the target function */
  yLeft = funFilter(*xLeft, *B, N);

  /* Marshall function outputs */
  emlrt_marshallOut(*xLeft, prhs[0]);
  plhs[0] = prhs[0];
  plhs[1] = b_emlrt_marshallOut(yLeft);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void funFilter_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  funFilter_xil_terminate();
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void funFilter_initialize(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void funFilter_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/*
 * File trailer for _coder_funFilter_api.c
 *
 * [EOF]
 */
