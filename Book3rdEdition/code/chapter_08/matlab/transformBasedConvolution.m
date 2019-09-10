%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ This m-file is used to demonstrate that circular convolution
%/ can be used to implement linear convolution if the input
%/ sequences are properly padded.
%/
%//////////////////////////////////////////////////////////////////////

% Simulation inputs
h = [1 2 3 2 1];      % impulse response declaration
x = [1 3 -2 4 -3];    % input term declaration

% Calculated and output terms
y = conv(h, x)
yLength = length(y)
circularConvolutionResult = ifft(fft(h).*fft(x))
circularConvolutionResultLength = length(circularConvolutionResult)

% Simulation inputs
h = [1 2 3 2 1];      % impulse response declaration
x = [1 3 -2 4 -3];    % input term declaration

hZeroPadded = [h zeros(1, 4)];
xZeroPadded = [x zeros(1, 4)];

% Calculated and output terms
y = conv(h, x)
yLength = length(y)
circularConvolutionResult = real(ifft(fft(hZeroPadded).*fft(xZeroPadded)))
circularConvolutionResultLength = length(circularConvolutionResult)