%  This m-file is used to create the big picture figure
%  in the signal generation chapter
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2003
%  completed on 10 July 2003 revision 1.0

% Simulation inputs
f1 = 1000;
f2 = 3000;
t = 0:0.0000001:0.001;
Fs = 48000;             % sample frequency
myFontSize = 16;        % font size for the plot labels


% Calculated terms


% Simulation outputs
figure(1)
subplot(3,1,1)
plot(1000*t, sin(2*pi*f1*t))
set(gca, 'FontSize', myFontSize)
title('Continuous-Time Sinusoids')
ylabel('unit amplitude')
xlabel('time (ms)')
axis([0 1 -1.2 1.2])
legend('1000 Hz')

subplot(3,1,2)
plot(1000*t, sin(2*pi*f2*t))
set(gca, 'FontSize', myFontSize)
ylabel('unit amplitude')
xlabel('time (ms)')
axis([0 1 -1.2 1.2])
legend('3000 Hz')

subplot(3,1,3)
plot(1000*t, 32727*sin(2*pi*f2*t))
set(gca, 'FontSize', myFontSize)
ylabel('32,767 amplitude')
xlabel('time (ms)')
axis([0 1 -40000 40000])
legend('3000 Hz')






%set(gca,'XTick', [0 3 6 9 12 15 18 21 24])
%set(gca,'XTickLabel', [0 3 6 9 12 15 18 21 24]')
%legend('double precision', 'quantized')
%hold off
