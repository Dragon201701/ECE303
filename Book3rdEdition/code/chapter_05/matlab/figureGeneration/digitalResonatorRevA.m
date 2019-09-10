%  This m-file creates plots for a for a digital resonator
%
%       1 - impulse response,
%       2 - frequency response, and
%       3 - pole/zero plot
%  
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2002
%  completed on 12 July 2002 revision 1.0
%  last updated on 14 July 2003 revision 1.1

% Simulation inputs
Fs = 48000;         % sample frequency
fSignal = 1000;     % desired resonance frequency
N = 100;            % number of sample points in the impulse response
Nfft = 480;         % number of points used to calculate the frequency response
myFontSize = 16;    % font size for the plot labels

% calculations
theta = 2*pi*fSignal/Fs;    % discrete frequency
B = [0 sin(theta) 0];       % scale factor for a unit amplitude output
A = conv([1 -exp(j*theta)], [1 -exp(-j*theta)]); % pole placement

% Simulation outputs
figure(1)
impz(B, A, N)
set(gca, 'FontSize', myFontSize)
title('')
ylabel('amplitude')
xlabel('n (samples)')

figure(2)
[H, f] = freqz(B, A, Nfft, Fs);
subplot(2,1,1)
set(gca, 'FontSize', myFontSize)
plot(f/1000, 20*log10(abs(H)))
ylabel('magnitude (dB)')
xlabel('frequency (kHz)')
set(gca,'XTick', [0 3 6 9 12 15 18 21 24])
set(gca,'XTickLabel', [0 3 6 9 12 15 18 21 24]')
axis([0 24 -50 350])
grid

subplot(2,1,2)
plot(f/1000, 180/pi*angle(H))
set(gca, 'FontSize', myFontSize)
ylabel('phase (degrees)')
xlabel('frequency (kHz)')
set(gca,'XTick', [0 3 6 9 12 15 18 21 24])
set(gca,'XTickLabel', [0 3 6 9 12 15 18 21 24]')
%axis([0 24 -200 50])
grid

figure(3)
set(gca, 'FontSize', myFontSize)
zplane(B, A)
ylabel('imaginary part')
xlabel('real part')
ucf                 % run the "unit circle fixer" m-file
