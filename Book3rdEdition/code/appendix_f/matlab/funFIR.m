%  This m-file is used to convolve xLeft[n] and B[n] without
%  using the MATLAB filter command.  This is one of the 
%  first steps toward being able to implement a real-time 
%  FIR filter in DSP hardware. This m-file uses a function to calculate 
%  the output value, yLeft[0].
%
%  In sample-by-sample filtering, you are only trying to
%  accomplish 2 things,
%
%  1.  Calculate the current output value, yLeft[0], based on 
%      just having received a new input sample, xLeft[0].
%  2.  Setup for the arrivial of the next input sample.
%
%  This is a BRUTE FORCE approach!
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2001, 2015
%  completed on 13 December 2001 revision 1.0
%  updated to a function-based script on 21 July 2015 revision 1.1

% Simulation inputs
xLeft = single([1 2 3 0]);         % input vector xLeft
N = int16(3);                      % order of the filter = length(B) - 1
B = single([0.25 0.25 0.25 0.25]); % FIR filter coefficients B[n]
yLeft = single(0);                 % declare the output variable y

% Calculated terms (functionalized)
[xLeft, yLeft] = funFilter(xLeft, B, N);

% Simulation outputs
xLeft                              % notice that xLeft(1) = xLeft(2)
yLeft                              % average of the last 4 input values