/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * funFilter.c
 *
 * Code generation for function 'funFilter'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "funFilter.h"
#include "eml_int_forloop_overflow_check.h"
#include "funFilter_data.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 7, "funFilter",
  "C:\\Users\\Thad\\Desktop\\funFilter.m" };

static emlrtRSInfo b_emlrtRSI = { 12, "funFilter",
  "C:\\Users\\Thad\\Desktop\\funFilter.m" };

static emlrtRSInfo c_emlrtRSI = { 20, "eml_int_forloop_overflow_check",
  "C:\\Program Files\\MATLAB\\R2015a\\toolbox\\eml\\lib\\matlab\\eml\\eml_int_forloop_overflow_check.m"
};

static emlrtBCInfo emlrtBCI = { 1, 4, 13, 5, "xLeft", "funFilter",
  "C:\\Users\\Thad\\Desktop\\funFilter.m", 0 };

static emlrtBCInfo b_emlrtBCI = { 1, 4, 13, 18, "xLeft", "funFilter",
  "C:\\Users\\Thad\\Desktop\\funFilter.m", 0 };

static emlrtBCInfo c_emlrtBCI = { 1, 4, 8, 21, "B", "funFilter",
  "C:\\Users\\Thad\\Desktop\\funFilter.m", 0 };

static emlrtBCInfo d_emlrtBCI = { 1, 4, 8, 26, "xLeft", "funFilter",
  "C:\\Users\\Thad\\Desktop\\funFilter.m", 0 };

/* Function Definitions */
real32_T funFilter(const emlrtStack *sp, real32_T xLeft[4], const real32_T B[4],
                   int16_T N)
{
  real32_T yLeft;
  int32_T i1;
  int16_T b;
  boolean_T b0;
  int16_T i;
  int32_T i2;
  int32_T i3;
  int32_T i4;
  int32_T i5;
  int32_T i6;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;

  /*  initializes the output value */
  yLeft = 0.0F;

  /*  performs the dot product of B and x */
  i1 = N + 1;
  if (i1 > 32767) {
    i1 = 32767;
  }

  b = (int16_T)i1;
  st.site = &emlrtRSI;
  if (1 > b) {
    b0 = false;
  } else {
    b0 = (b > 32766);
  }

  if (b0) {
    b_st.site = &c_emlrtRSI;
    check_forloop_overflow_error(&b_st, true);
  }

  i = 1;
  while (i <= b) {
    i1 = i;
    i2 = i;
    if ((i1 >= 1) && (i1 < 4)) {
      i3 = i1;
    } else {
      i3 = emlrtDynamicBoundsCheckR2012b(i1, 1, 4, &c_emlrtBCI, sp);
    }

    if ((i2 >= 1) && (i2 < 4)) {
      i4 = i2;
    } else {
      i4 = emlrtDynamicBoundsCheckR2012b(i2, 1, 4, &d_emlrtBCI, sp);
    }

    yLeft += B[i3 - 1] * xLeft[i4 - 1];
    i++;
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  /*  shift the stored x samples to the right */
  st.site = &b_emlrtRSI;
  i = N;
  while (i > 0) {
    i1 = i + 1;
    if (i1 > 32767) {
      i1 = 32767;
    }

    i2 = i;
    if (i1 < 4) {
      i5 = i1;
    } else {
      i5 = emlrtDynamicBoundsCheckR2012b(i1, 1, 4, &emlrtBCI, sp);
    }

    if (i2 < 4) {
      i6 = i2;
    } else {
      i6 = emlrtDynamicBoundsCheckR2012b(i2, 1, 4, &b_emlrtBCI, sp);
    }

    xLeft[i5 - 1] = xLeft[i6 - 1];
    i--;
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  return yLeft;
}

/* End of code generation (funFilter.c) */
