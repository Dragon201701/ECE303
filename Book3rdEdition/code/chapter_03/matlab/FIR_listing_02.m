%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ This m-file is used to convolve x[n] and B[n] without
%/ using the MATLAB filter command.  This is one of the 
%/ first steps toward being able to implement a real-time 
%/ FIR filter in DSP hardware.
%/
%/ In sample-by-sample filtering, you are only trying to
%/ accomplish 2 things,
%/
%/ 1.  Calculate the current output value, y[0], based on 
%/     just having received a new input sample, x[0].
%/ 2.  Setup for the arrivial of the next input sample.
%/
%/ This is a BRUTE FORCE approach!
%/
%//////////////////////////////////////////////////////////////////////

% Simulation inputs
x = [1 2 3 0];              % input vector x = x[0] x[-1] x[-2] x[-3]
N = 3;                      % order of the filter = length(B) - 1
B = [0.25 0.25 0.25 0.25];  % FIR filter coefficients B[n]

% Calculated terms
y = 0;                      % initializes the output value y
for i = 1:N+1               % performs the dot product of B and x
    y = y + B(i)*x(i);
end

for i = N:-1:1              % shift the stored x samples to the right so
    x(i+1) = x(i);          % that the next x value, x[0], can be placed
end                         % in x(1)

% Simulation outputs
x                           % notice that x(1) = x(2)
y                           % average of the last 4 input values