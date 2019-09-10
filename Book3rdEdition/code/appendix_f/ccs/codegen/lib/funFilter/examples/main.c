/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: main.c
 *
 * MATLAB Coder version            : 2.8
 * C/C++ source code generated on  : 23-Jul-2015 18:17:32
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include Files */
#include "funFilter.h"
#include "main.h"
#include "funFilter_terminate.h"
#include "funFilter_initialize.h"

/* Function Declarations */
static void argInit_1x4_real32_T(float result[4]);
static short argInit_int16_T(void);
static float argInit_real32_T(void);
static void main_funFilter(void);

/* Function Definitions */

/*
 * Arguments    : float result[4]
 * Return Type  : void
 */
static void argInit_1x4_real32_T(float result[4])
{
  int b_j1;

  /* Loop over the array to initialize each element. */
  for (b_j1 = 0; b_j1 < 4; b_j1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result[b_j1] = argInit_real32_T();
  }
}

/*
 * Arguments    : void
 * Return Type  : short
 */
static short argInit_int16_T(void)
{
  return 0;
}

/*
 * Arguments    : void
 * Return Type  : float
 */
static float argInit_real32_T(void)
{
  return 0.0F;
}

/*
 * Arguments    : void
 * Return Type  : void
 */
static void main_funFilter(void)
{
  float xLeft[4];
  float fv0[4];
  float yLeft;

  /* Initialize function 'funFilter' input arguments. */
  /* Initialize function input argument 'xLeft'. */
  argInit_1x4_real32_T(xLeft);

  /* Initialize function input argument 'B'. */
  /* Call the entry-point 'funFilter'. */
  argInit_1x4_real32_T(fv0);
  yLeft = funFilter(xLeft, fv0, argInit_int16_T());
}

/*
 * Arguments    : int argc
 *                const char * const argv[]
 * Return Type  : int
 */
int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  funFilter_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_funFilter();

  /* Terminate the application.
     You do not need to do this more than one time. */
  funFilter_terminate();
  return 0;
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
