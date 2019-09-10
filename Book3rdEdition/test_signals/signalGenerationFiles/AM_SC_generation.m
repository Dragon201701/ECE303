%  AM_SC_generation.m
%
%  This m-file creates a DSB-AM-SC signal (wav-file)
%
%  You may need to modify the path and filename of,
%
%       the "wavread" command on line 32,
%       the "load" command on line 38, and 
%       the "wavwrite" command on line 88.
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2001, 2002, 2003, 2004
%  completed on 29 July 2001 - revision 1.0
%  last revision 11 November 2004 - revision 1.3

% Simulation inputs
Fs = 44100;                  % CD sample frequency (Hz)
Fc = 12000;                  % AM carrier frequency (Hz)
Fmsg = 9000;                  % message frequency (Hz)
duration = 30;               % signal duration (s)
desiredMaxAmplitude = 0.99;  % maximum amplitude PRIOR to wav-file conversion
Nbits = 16;                  % number of bits per sample

% Calculated terms
t = 0:(1/Fs):duration;       % create a time vector
message = cos(2*pi*Fmsg*t);  % create the message signal using the time vector
carrier = cos(2*pi*Fc*t);    % create the carrier signal using the time vector
AMsignal = desiredMaxAmplitude*message.*carrier; % create the AM-DSB-SC signal
    
%Simulation outputs
wavwrite(AMsignal, Fs, Nbits, 'F:\DSP_Text\Matlab\SigGen\wavFiles\AMwav_12000_9000.wav')
