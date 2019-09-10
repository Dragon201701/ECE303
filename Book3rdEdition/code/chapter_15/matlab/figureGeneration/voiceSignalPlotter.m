%  The m-file is used to generate a series of eps files that
%  are used in the AM generation chapter of our DSP text.
%
%  The figures are as follows,
%
%  1 - plot of 100ms of voice data
%  2 - plot of 100ms of voice data with 5mV of DC added (signal still goes negative)
%  3 - plot of 100ms of voice data with 20mV of DC added (signal is always positive)
%  4 - plot of the AM modulated voice signal
%  5 - plot of the spectral estimate of the AM signal
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2001, 2016
%  completed on  29 July 2001 revision 1.0
%  last revision 26 May 2016 revision 1.2

load 'voiceSignal';
Fs = 44100;
fc = 12000;
Ac = 1;
Nfft = 2048;
myFontSize = 16;                 % font size for the plot labels

t = (1:4410)/Fs;
index = 57330 + (1:4410);
carrier = Ac*cos(2*pi*fc*t);
AMsignal = (signal(index) + 0.010).*carrier';

figure(1)
plot((0:4409)/Fs,signal(index))
set(gca, 'FontSize', myFontSize)
xlabel('time (ms)')
ylabel('signal amplitude (V)')
grid
% print -deps2 'C:\DSP_Text\Tex\Proj_AmTx\VoiceSignalPlot.eps'

figure(2)
plot((0:4409)/Fs,signal(index) + 0.005)
set(gca, 'FontSize', myFontSize)
xlabel('time (ms)')
ylabel('signal amplitude (V)')
axis([0 0.1 -0.02 0.02])
grid
% print -deps2 'C:\DSP_Text\Tex\Proj_AmTx\VoiceSignalPlotWithLittleDC.eps'

figure(3)
plot((0:4409)/Fs,signal(index) + 0.020)
set(gca, 'FontSize', myFontSize)
xlabel('time (ms)')
ylabel('signal amplitude (V)')
axis([0 0.1 -0.035 0.035])
grid
% print -deps2 'C:\DSP_Text\Tex\Proj_AmTx\VoiceSignalPlotWithLargeDC.eps'

figure(4)
plot((0:4409)/Fs, AMsignal)
set(gca, 'FontSize', myFontSize)
xlabel('time (ms)')
ylabel('AM signal amplitude (V)')
%axis([0 0.1 -0.035 0.035])
grid
% print -deps2 'C:\DSP_Text\Tex\Proj_AmTx\AM_ModulatedVoiceSignal.eps'

figure(5)
% psd(AMsignal, Nfft, Fs)
pwelch(AMsignal, [], [], Nfft, Fs)
set(gca, 'FontSize', myFontSize)
