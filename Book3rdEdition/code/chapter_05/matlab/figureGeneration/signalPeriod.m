%  This m-file creates plots for the signal period explanation
%  portion of the signal generation chapter.
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2003
%  completed on 16 July 2003 revision 1.0
%  last updated on           revision 1.1

% Simulation inputs
Fs = 48000;         % sample frequency
fSignal = 1000;     % desired resonance frequency
N = 120;            % number of sample points in the impulse response
myFontSize = 16;    % font size for the plot labels

% calculations
n = 0:N;            % discrete frequency

% Simulation outputs
figure(1)
subplot(6,1,1)
plot(n*1000/Fs, sin(2*pi*fSignal*n/Fs))
hold on
plot([0 2.5], [0 0], 'k')
plot([1 1], [-1.2 1.2], 'k')
hold off
axis([0 2.5 -1.2 1.2])
set(gca, 'FontSize', myFontSize)
ylabel('(a)')
xlabel('time (ms)')

subplot(6,1,2)
stem(0:47, sin(2*pi*fSignal*(0:47)/Fs))
hold on
plot([47 47], [-1.2 1.2], 'k')
hold off
axis([0 120 -1.2 1.2])
set(gca, 'FontSize', myFontSize)
set(gca,'XTickLabel', []')
ylabel('(b)')

subplot(6,1,3)
stem(10:57, sin(2*pi*fSignal*(10:57)/Fs))
hold on
axis([0 120 -1.2 1.2])
stem(10+48:57+48, sin(2*pi*fSignal*(10+48:57+48)/Fs), 'filled', 'r')
hold off
set(gca, 'FontSize', myFontSize)
set(gca,'XTickLabel', []')
ylabel('(c)')

subplot(6,1,4)
stem(20:67, sin(2*pi*fSignal*(20:67)/Fs))
axis([0 120 -1.2 1.2])
set(gca, 'FontSize', myFontSize)
set(gca,'XTickLabel', []')
ylabel('(d)')

subplot(6,1,5)
stem(30:77, sin(2*pi*fSignal*(30:77)/Fs))
axis([0 120 -1.2 1.2])
set(gca, 'FontSize', myFontSize)
set(gca,'XTickLabel', []')
ylabel('(e)')

subplot(6,1,6)
stem(40:87, sin(2*pi*fSignal*(40:87)/Fs))
axis([0 120 -1.2 1.2])
set(gca, 'FontSize', myFontSize)
ylabel('(f)')
xlabel('n (samples)')

% print -depsc2 signalPeriod