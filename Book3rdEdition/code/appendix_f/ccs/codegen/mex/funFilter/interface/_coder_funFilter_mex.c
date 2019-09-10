/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_funFilter_mex.c
 *
 * Code generation for function '_coder_funFilter_mex'
 *
 */

/* Include files */
#include "funFilter.h"
#include "_coder_funFilter_mex.h"
#include "funFilter_terminate.h"
#include "_coder_funFilter_api.h"
#include "funFilter_initialize.h"
#include "funFilter_data.h"

/* Function Declarations */
static void funFilter_mexFunction(int32_T nlhs, mxArray *plhs[2], int32_T nrhs,
  const mxArray *prhs[3]);

/* Function Definitions */
static void funFilter_mexFunction(int32_T nlhs, mxArray *plhs[2], int32_T nrhs,
  const mxArray *prhs[3])
{
  int32_T n;
  const mxArray *inputs[3];
  const mxArray *outputs[2];
  int32_T b_nlhs;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 3, 4, 9,
                        "funFilter");
  }

  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 9,
                        "funFilter");
  }

  /* Temporary copy for mex inputs. */
  for (n = 0; n < nrhs; n++) {
    inputs[n] = prhs[n];
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(&st);
    }
  }

  /* Call the function. */
  funFilter_api(inputs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);

  /* Module termination. */
  funFilter_terminate();
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  /* Initialize the memory manager. */
  mexAtExit(funFilter_atexit);

  /* Module initialization. */
  funFilter_initialize();

  /* Dispatch the entry-point. */
  funFilter_mexFunction(nlhs, plhs, nrhs, prhs);
}

/* End of code generation (_coder_funFilter_mex.c) */
