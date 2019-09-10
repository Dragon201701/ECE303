%  This m-file is used to convolve x[n] and B[n]
%
%  Assumes that both x[n] and B[n] start at n = 0
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2001
%  completed on 13 December 2001 revision 1.0

% Simulation inputs
x = [1 2 3 0 1 -3 4 1];             % input vector x[n]
B = [0.25 0.25 0.25 0.25];          % FIR filter coefficients B[n]
myFontSize = 16;                    % font size for the plot labels

% Calculated terms
PaddedX = [x zeros(1,length(B)-1)]; % zeros pads x[n] to flush the filter
n = 0:(length(x) + length(B) - 2);  % plotting index for the output 
y = filter(B, 1, PaddedX);          % performs the convolution

%Simulation outputs
y                                   % returns the results to the screen
stem(n, y)                          % output plot generation
set(gca, 'FontSize', myFontSize)
ylabel('ouput values')
xlabel('sample number')
print -deps2 MatlabFiltering