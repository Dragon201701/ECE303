%  This m-file is used to convolve x[n] and B[n] without
%  using the MATLAB filter command.  This is one of the 
%  This m-files plots the frequency response associated with
%  various moving average filters.
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2001, 2016
%  completed on 13 December 2001 revision 1.0

% Simulation inputs
N = [3 7 15 31];                 % MA filter orders
Fs = 48000;                      % sample frequency (Hz)
S = char('b-','m:','r-.','k--'); % line type control for the plot
myFontSize = 16;                 % font size for the plot labels

% Calculated terms and Simulation outputs
figure(1)
hold on

for i = 1:4     % calculate and plot |H| for various N's
    [H, f] = freqz(ones(1,N(i)+1)/(N(i)+1), 1, [], Fs);
    plot(f/1000, 20*log10(abs(H + eps)), S(i,:))
end

set(gca, 'FontSize', myFontSize)
ylabel('|H(e^{j\omega})| (dB)')
xlabel('frequency (kHz)')
axis([0 24 -50 5])
set(gca,'XTick', [0 3 6 9 12 15 18 21 24])
set(gca,'XTickLabel', [0 3 6 9 12 15 18 21 24]')
legend('N =  3', 'N =  7', 'N = 15', 'N = 31')
hold off

print -depsc2 movingAverageFilter