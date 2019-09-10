%  AM-SC signal generator
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2004
%
%  4 July 2004 - revision 1.0 ... initial implementation

%  input terms
Fmessage = 750;     % message frequency
Fcarrier = 12000;   % carrier frequency of the BPSK transmitter (Hz)
Fs = 96000;         % sample frequency of the simulation (Hz)
time = 30;          % length of the signal in seconds
amplitude = 0.99;   % scale factor (sound card needs < +/- 1)
Nfft = 1024;
Nbits = 16;

%  calculated terms
t = 0:(1/Fs):(time - 1/Fs);
AM_SCsignal = amplitude*cos(2*pi*Fmessage*t).*cos(2*pi*Fcarrier*t);

wavwrite(AM_SCsignal, Fs, Nbits, 'AM_SCsignal')

%  output terms
figure(1)
psd(AM_SCsignal, Nfft, Fs)

figure(2)
plot(t, AM_SCsignal)
hold on
plot(t, amplitude*cos(2*pi*Fmessage*t), 'r')

