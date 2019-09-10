%  This m-file creates a wav-file containing AWGN
%  
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2001
%  completed on 23 December 2001 revision 1.0

% Simulation inputs
Fs = 44100;             % sample frequency
duration = 240;         % file duration in seconds
Nbits = 16;             % number of bits per sample

% Calculated terms
%signal = randn(1,round(duration*Fs));      % Gaussian noise ... will clip
signal = 2*rand(1,round(duration*Fs)) - 1;  % uniform noise +1 ... -1

% Simulation outputs
wavwrite(signal, Fs, Nbits, 'noise.wav');