%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ This m-file creates a wav-file containing AWGN
%/  
%//////////////////////////////////////////////////////////////////////


% Simulation inputs
Fs = 44100;             % sample frequency
duration = 240;         % file duration in seconds
Nbits = 16;             % number of bits per sample

% Calculated terms
%signal = randn(1,round(duration*Fs));      % Gaussian noise ... will clip
signal = 2*rand(1,round(duration*Fs)) - 1;  % uniform noise +1 ... -1

% Simulation outputs
wavwrite(signal, Fs, Nbits, 'noise.wav');