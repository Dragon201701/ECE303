%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ This m-file is used to implement the difference equation
%/ that describes a 1st order notch filter without using 
%/ the MATLAB filter command.  This is one of the first 
%/ steps toward being able to implement a real-time IIR 
%/ filter in DSP hardware.
%/
%/ In sample-by-sample filtering, you are only trying to
%/ accomplish 2 things,
%/
%/ 1.  Calculate the current output value, y[0], based on 
%/     just having received a new input sample, x[0].
%/
%/ 2.  Setup for the arrivial of the next input sample.
%/
%/ This is a BRUTE FORCE approach!
%/
%//////////////////////////////////////////////////////////////////////


% Simulation inputs
x = [0 1];      % input vector x = x[0] x[-1]
y = [1 1];      % output vector y = y[0] y[-1]
B = [1 -1];     % numerator coefficients
A = [1 -0.9];   % denominator coefficients

% Calculated terms
y(1) =  -A(2)*y(2) + B(1)*x(1) + B(2)*x(2); 
x(2) = x(1);    % shift x[0] into x[-1]
y(2) = y(1);    % shift y[0] into y[-1]

% Simulation outputs
x               % notice that x(1) = x(2)
y               % notice that y(1) = y(2)