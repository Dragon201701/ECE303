/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_funFilter_api.c
 *
 * Code generation for function '_coder_funFilter_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "funFilter.h"
#include "_coder_funFilter_api.h"
#include "funFilter_data.h"

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
static real32_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId))[4]
{
  real32_T (*y)[4];
  y = e_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
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

static int16_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  int16_T y;
  y = f_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

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

static void emlrt_marshallOut(const real32_T u[4], const mxArray *y)
{
  static const int32_T iv0[2] = { 1, 4 };

  mxSetData((mxArray *)y, (void *)u);
  emlrtSetDimensions((mxArray *)y, iv0, 2);
}

static int16_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId)
{
  int16_T ret;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "int16", false, 0U, 0);
  ret = *(int16_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void funFilter_api(const mxArray *prhs[3], const mxArray *plhs[2])
{
  real32_T (*xLeft)[4];
  real32_T (*B)[4];
  int16_T N;
  real32_T yLeft;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  prhs[0] = emlrtProtectR2012b(prhs[0], 0, true, -1);

  /* Marshall function inputs */
  xLeft = emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "xLeft");
  B = emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "B");
  N = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[2]), "N");

  /* Invoke the target function */
  yLeft = funFilter(&st, *xLeft, *B, N);

  /* Marshall function outputs */
  emlrt_marshallOut(*xLeft, prhs[0]);
  plhs[0] = prhs[0];
  plhs[1] = b_emlrt_marshallOut(yLeft);
}

/* End of code generation (_coder_funFilter_api.c) */
