%  This m-file creates plots for a for a digital resonator
%
%       1 - impulse response,
%       2 - frequency response, and
%       3 - pole/zero plot
%  
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2002
%  completed on 12 July 2002 revision 1.0

% Simulation inputs
fs = 48000;
fSignal = 1000;
N = 100;
Nfft = 480;

% calculations
theta = 2*pi*fSignal/fs;
A = conv([1 -exp(j*theta)], [1 -exp(-j*theta)]);

% Simulation outputs
figure(1)
impz(1, A, N)

figure(2)
freqz(1, A, Nfft, fs)

figure(3)
zplane(1, A)
