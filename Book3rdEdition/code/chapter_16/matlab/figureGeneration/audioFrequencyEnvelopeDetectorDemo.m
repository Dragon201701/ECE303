% Spectral properties of the envelope detector
%
% Fig 1 - time domain plot of AM signal 
% Fig 2 - zoomed in version PSD of the rectified AM signal ... 
%         this explains the envelope detector design inequality
%
% B << 1/(RC) << Fc ... frequencies in Hz
%
% by Dr. Thad B. Welch, {t.b.welch@ieee.org}
%
% copyright 2002, 2016
%
% revision 1.0 - 12 April 2003
% revision 1.1 - 27 May 2016

% simulation inputs
Fmsg = 5000;                        % frequency of the message
Fcarrier = 12000;                   % carrier frequency
Fs = 1e6;                           % sample frequency
Ac = 1.0;                           % amplitude of the carrier
mu = 0.8;                           % modulation index

Nfft = 2048*8;                      % block size in the PSD calculation
% initialValue = 1.02286526803032;    % in volts
% timeDelay = 0.44909002538543;       % in ms
% tau = 1/55;                         % RC time constant in ms
myFontSize = 16;                    % font size for the plot labels

% calculated values
t = 0:1/Fs:0.005;                   % time index
% tDecay = linspace(timeDelay, timeDelay + 0.0025, 100);    % in ms
message = cos(2*pi*Fmsg*t);         % message signal
carrier = cos(2*pi*Fcarrier*t);     % carrier signal
AM = Ac*(1 + mu*message).*carrier;  % AM DSB signal generation
recAM = AM.*(AM > 0);               % rectified version of the AM signal

% simulation outputs
figure(1)
plot(t*1000, AM)
hold on
Fs = Fs/10;
t = 0:1/Fs:0.005;                   % time index
message = cos(2*pi*Fmsg*t);         % message signal
plot(t*1000, 1 + mu*message, 'r:')
set(gca, 'FontSize', myFontSize)
axis([0 1 -2 2])
%title('AM signal')
legend('AM signal', 'message + DC', 'Location', 'South')
ylabel('AM signal value (V)')
xlabel('time (ms)')

figure(2)
psd(recAM, Nfft, Fs/1000, blackmanharris(Nfft))
set(gca, 'FontSize', myFontSize)
title('')
%title('PSD of the Rectified AM Signal')
ylabel('power spectrum magnitude (dB)')
xlabel('frequency (kHz)')
axis([0 2.5 -20 10])
%axis([-5 600 25 45])
