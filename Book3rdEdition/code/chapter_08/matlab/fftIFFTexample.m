%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ This m-file is used to demonstrate that a complex FFT
%/ algorithm can be used to calculate the IFFT.
%/
%//////////////////////////////////////////////////////////////////////

% Simulation inputs
N = 16;
x = rand(1, N)

% Calculated and output terms
xFFT = fft(x);
xFFT = imag(xFFT) + j*real(xFFT);

y = imag(fft(xFFT/N))


% calculations
for m = 1:N
    X(m) = 0;
    for n = 1:N
        X(m) = X(m) + x(n)*exp(-j*2*pi*(n-1)*(m-1)/N);
    end
end

X

for m = 1:N
    y(m) = 0;
    for n = 1:N
        y(m) = y(m) + X(n)*exp(j*2*pi*(n-1)*(m-1)/N);
    end
end

y = real(y/N)