%  This m-file is used to convolve x[n] and B[n] without
%  using the MATLAB filter command.  This is one of the 
%  This m-files plots the frequency response associated with
%  various moving average filters.
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2001, 2016
%  completed on 13 December 2001 revision 1.0

% Simulation inputs
tStart = 0;                      % simulation start time
tStop = 0.001;                   % simulation stop time
Fs = 48000;                      % sample frequency (Hz)
S = char('b-','m:','r-.','k--'); % line type control for the plot
myFontSize = 16;                 % font size for the plot labels
frequency = [2000 1000 500 250]; % plotted frequencies

% Calculated terms and Simulation outputs
t  = tStart:(1/Fs):tStop;         % time index
t1 = tStart:(1/Fs):4*tStop;      % time index

figure(1)
hold on
for i = 1:4
    plot(t*1000, 2*pi*frequency(i)*t, S(i,:))
end
set(gca, 'FontSize', myFontSize)
ylabel('phase (radians)')
xlabel('time (ms)')
axis([0 1 0 8])
legend('2000 Hz', '1000 Hz', ' 500 Hz', ' 250 Hz', 'Location', 'NorthWest')
hold off

figure(2)
hold on
plot(t*1000, 2*pi*frequency(2)*t, S(1,:))
stem(t*1000, 2*pi*frequency(2)*t)
set(gca, 'FontSize', myFontSize)
ylabel('phase (radians)')
xlabel('time (ms)')
axis([0 1 0 8])
legend('continuous', 'sampled', 'Location', 'NorthWest')
hold off

figure(3)
hold on
plot(t1*1000, 2*pi*frequency(2)*t1, S(1,:))
stem(t1*1000, mod(2*pi*frequency(2)*t1, 2*pi))
plot([0 4], [2*pi 2*pi], 'r')
set(gca, 'FontSize', myFontSize)
ylabel('phase (radians)')
xlabel('time (ms)')
%axis([0 4 0 8])
legend('continuous', 'sampled', 'Location', 'NorthWest')
gtext('phase accumulator''s value without the modulus 2\pi operation')
gtext('phase accumulator''s maximum value of 2\pi')
hold off

figure(4)
hold on
stem(t*1000, 2*pi*frequency(2)*t)
set(gca, 'FontSize', myFontSize)
ylabel('phase (radians)')
xlabel('time (ms)')
axis([0 0.1 0 0.6])
%legend('continuous', 'sampled', 'Location', 'NorthWest')
plot([.02 2*1000/Fs], [2*pi*frequency(2)*2/Fs 2*pi*frequency(2)*2/Fs], 'b:')
plot([.02 3*1000/Fs], [2*pi*frequency(2)*3/Fs 2*pi*frequency(2)*3/Fs], 'b:')
gtext('\phi_{inc}')
gtext('{1/{F_s}}')
hold off

%set(gca,'XTick', [0 3 6 9 12 15 18 21 24])
%set(gca,'XTickLabel', [0 3 6 9 12 15 18 21 24]')
%print -depsc2 movingAverageFilter