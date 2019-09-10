% Spectral properties of the envelope detector
%
% Fig 1 - time domain plot of AM signal 
% Fig 2 - zoomed in version of Figure 1 with filter decays
% Fig 3 - LP filter Bode plots
% Fig 4 - time domain plot of AM signal and a square wave that can be used to rectify the signal
% Fig 5 - zoomed in version of Figure 4
% Fig 6 - zoomed in PSD of the AM-DSB signal
% Fig 7 - PSD of the rectified AM-DSB signal
% Fig 8 - zoomed in version PSD of the rectified AM signal ... 
%         this explains the envelope detector design inequality
%
% B << 1/(RC) << Fc ... frequencies in Hz
%
% by Dr. Thad B. Welch, {t.b.welch@ieee.org}
%
% copyright 2002
%
% revision 1.0 - 10 April 2002
% revision 1.1 - 10 August 2003

% simulation inputs
Fmsg = 5000;                        % frequency of the message
Fcarrier = 550000;                  % carrier frequency
Fs = 1e8;                           % sample frequency
Ac = 1.0;                           % amplitude of the carrier
mu = 0.8;                           % modulation index

Nfft = 2048*128;                    % block size in the PSD calculation
initialValue = 1.02286526803032;    % in volts
timeDelay = 0.44909002538543;       % in ms
tau = 1/55;                         % RC time constant in ms
myFontSize = 16;                    % font size for the plot labels

% calculated values
t = 0:1/Fs:0.005;                   % time index
tDecay = linspace(timeDelay, timeDelay + 0.0025, 100);    % in ms
message = cos(2*pi*Fmsg*t);         % message signal
carrier = cos(2*pi*Fcarrier*t);     % carrier signal
AM = Ac*(1 + mu*message).*carrier;  % AM DSB signal generation
recAM = AM.*(AM > 0);               % rectified version of the AM signal

% simulation outputs
figure(1)
plot(t*1000, AM)
set(gca, 'FontSize', myFontSize)
axis([0 1 -2 2])
%title('AM signal')
ylabel('AM signal value (V)')
xlabel('time (ms)')

figure(2)
plot(t*1000, AM)
set(gca, 'FontSize', myFontSize)
axis([.449 .451 0.95 1.03])
hold on
plot(tDecay, initialValue*exp(-(tDecay - timeDelay)/(5*tau)), 'r:');
plot(tDecay, initialValue*exp(-(tDecay - timeDelay)/(2.18*tau)), 'g-.');
plot(tDecay + (0.44912005204214 - timeDelay), 1.01692242940219*exp(-(tDecay - timeDelay)/(0.2*tau)), 'k--');
%title('AM signal')
ylabel('AM signal value (V)')
xlabel('time (ms)')
legend('AM signal', '\tau too big', '\tau about right', '\tau too small', 'Location', 'South')
hold off

figure(3)
w = logspace(3, 7, 40);
H = tf(2*pi/(5*tau/1000), [1 2*pi/(5*tau/1000)]);
[mag, phase] = bode(H, w);
mag = reshape(mag,1,40);
semilogx(w/2/pi, 20*log10(mag), 'r:')
hold on
set(gca, 'FontSize', myFontSize)
H = tf(2*pi/(2.18*tau/1000), [1 2*pi/(2.18*tau/1000)]);
[mag, phase] = bode(H, w);
mag = reshape(mag,1,40);
semilogx(w/2/pi, 20*log10(mag), 'g-.')
H = tf(2*pi/(0.2*tau/1000), [1 2*pi/(0.2*tau/1000)]);
[mag, phase] = bode(H, w);
mag = reshape(mag,1,40);
semilogx(w/2/pi, 20*log10(mag), 'k--')
plot([5000 5000], [-40 10], 'b')
plot([550000 550000], [-40 10], 'b')
axis([1e3 1e6 -40 10])
legend('\tau too big', '\tau about right', '\tau too small', 'Location', 'South')
ylabel('|H(f)| (dB)')
xlabel('frequency (Hz)')
%
h = text(4000, -25, 'message frequency');
set(h, 'FontSize', 11.5)
set (h, 'rotation', 90)
h = text(450000, -24, 'carrier frequency');
set(h, 'FontSize', 11.5)
set (h, 'rotation', 90)
%
hold off

figure(4)
plot(t*1000, AM)
axis([0 1 -2 2])
%title('AM signal')
ylabel('AM signal value (V)')
xlabel('time (ms)')
hold on
plot(t*1000, AM > 0, 'r')
set(gca, 'FontSize', myFontSize)
%title('AM Signal with a Square Wave')
hold off

figure(5)
plot(t*1000, AM.*(AM > 0))
axis([0 1 -2 2])
%title('AM signal')
ylabel('AM signal value (V)')
xlabel('time (ms)')
set(gca, 'FontSize', myFontSize)
%title('AM Signal with a Square Wave')
hold off

figure(6)
plot(t*1000000, AM)
set(gca, 'FontSize', myFontSize)
axis([0 5 -2 2])
%title('AM signal')
ylabel('AM signal value (V)')
xlabel('time (us)')
hold on
plot(t*1000000, AM > 0, 'r')
%title('AM Signal with a Square Wave')
hold off

figure(7)
psd(AM, Nfft, Fs/1000, blackmanharris(Nfft))
set(gca, 'FontSize', myFontSize)
title('')
ylabel('power spectrum magnitude (dB)')
%title('PSD of the AM Signal')
xlabel('frequency (kHz)')
axis([535 565 -50 50])

figure(8)
psd(recAM, Nfft, Fs/1000)
set(gca, 'FontSize', myFontSize)
title('')
%title('PSD of the Rectified AM Signal')
ylabel('power spectrum magnitude (dB)')
xlabel('frequency (kHz)')
axis([0 5000 -40 50])

figure(9)
psd(recAM, Nfft, Fs/1000)
set(gca, 'FontSize', myFontSize)
title('')
%title('PSD of the Rectified AM Signal')
ylabel('power spectrum magnitude (dB)')
xlabel('frequency (kHz)')
axis([-5 600 25 45])
