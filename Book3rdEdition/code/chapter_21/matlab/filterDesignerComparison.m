%% Program to help understand MATLAB's new pulse shaping functions
%
% The MathWorks recently started an apparent transition to an 
% object oriented filter design process and a number of the filter 
% design commands associated with both the "Signal Processing" and 
% "DSP System" toolboxes are in flux.
%
% Obsolete pulse shaping filter design functions include ... 
%
%   rcosfir, rcosflt, and rcosine ... "will be removed in the future"
%   rcosiir ... "may be removed in the future"
%
% Two methods are discussed below ... see lines 38-44 and lines 55-59
%
% by Dr. Thad B. Welch, PE
% 
% 3 and 4 July 2011

%% input terms
% This is the original code from chapter 16, BPSK TX.
% note ... rcosfir returns a filter with a D.C gain approximately
% equally to the number of "samplesPerSymbol" (not in dB).
% This gain may be absorbed into other portions of your algorithm.

Fs = 48000;          % sample frequency of the simulation (Hz)
dataRate = 2400;     % data rate
alpha = 0.5;         % raised-cosine rolloff factor
symbols = 3;         % MATLAB ``rcosfir" parameter ... see help
samplesPerSymbol = Fs/dataRate; % number of samples per symbol

%% Design the original filter using the now obsolete function
B = rcosfir(alpha, symbols, samplesPerSymbol, 1/Fs);

% a few comments on the new code/commands below
% note ... 'Raised Cosine' and 'Nsym,Beta' must be typed EXACTLY as shown
% note ... rolloff factor is now called "Beta" ... we use "alpha"
% note ... they redefined "symbols" ... need to multiply by two (line 40)
h  = fdesign.pulseshaping(samplesPerSymbol, ...
     'Raised Cosine', 'Nsym,Beta', ...
     2*symbols, alpha);
H_fir = design(h);  % this actually designs the filter

% Increase the system's D.C. gain to match the first filter (line 32)
H_fir.Numerator = samplesPerSymbol*H_fir.Numerator;

%% Plot BOTH filters on the same axes ... they are identical
fvtool(H_fir, B, 1)

% The sum of the absolute value of the differences 
% between the filters ... this is the L1 norm. 
% The result is basically, numeric noise = 3.4781e-015
norm(H_fir.Numerator - B, 1)

%% Another filter design option ... "firrcos" command
B1 = firrcos(2*symbols*samplesPerSymbol, dataRate/2, alpha, Fs, ...
     'rolloff', 'normal');

% Increase the system's D.C. gain to match the first filter (line 32)
B1 = samplesPerSymbol*B1;

% Plot all three filters on the same axes ... they are identical
fvtool(H_fir, B, 1, B1, 1)

% The sum of the absolute value of the differences 
% between the filters ... this is the L1 norm. 
% The result is basically, numeric noise = 5.5527e-015
norm(B1 - B, 1)
