%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ This m-file is used to generate a figure that is used in the 
%/ AM generation chapter of our DSP text.
%/
%/ The figure has 3 subplots,
%/
%/ 1 - message signal (time domain)
%/ 2 - AM signal (time domain)
%/ 3 - PSD estimate of the AM signal
%/
%//////////////////////////////////////////////////////////////////////

% Simulation inputs
Fs = 48000;         % sample frequency
Fmsg = 1000;        % message frequency
Amsg = 0.4;         % message amplitude
bias = 0.6;         % bias (offset)
Fc = 12000;         % carrier frequency
Ac = 3;             % carrier amplitude
duration = 0.008;   % duration of the signal in seconds
Nfft = 2048;        % number of points used in each block of the PSD 
                    % estimation program
myFontSize = 12;    % font size for the plot labels

% Calculated terms
NumberOfPoints = round(duration*Fs);
t = (0:(NumberOfPoints - 1))/Fs;            % establish the time vector
message = Amsg*cos(2*pi*Fmsg*t);            % create the message signal
carrier = cos(2*pi*Fc*t);                   % create the carrier signal
AM_msg = Ac*(bias + message).*carrier;      % create the AM waveform

%Simulation outputs
subplot(3,1,1)
set(gca, 'FontSize', myFontSize)
plot(t*1000, message)
xlabel('time (ms)')
ylabel('message (V)')
axis([0 8 -1 1])

subplot(3,1,2)
set(gca, 'FontSize', myFontSize)
plot(t*1000,AM_msg)
xlabel('time (ms)')
ylabel('AM signal (V)')

subplot(3,1,3)
set(gca, 'FontSize', myFontSize)
[Pam, frequency] = psd(AM_msg, Nfft, Fs, blackmanharris(Nfft));
plot(frequency/1000, 10*log10(Pam))
xlabel('frequency (kHz)')
ylabel('spectrum (dB)')
set(gca,'XTick', [0 4 8 12 16 20 24])
set(gca,'XTickLabel', [0 4 8 12 16 20 24]')
axis([0 24 -50 0])

% print -deps2 AM_SignalPlot