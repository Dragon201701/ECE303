%  This m-file plots the magnitude of the frequency response
%  for a few different frequencies.
%  
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2002
%  completed on 10 July 2002 revision 1.0

% Simulation inputs
notchFrequency = [3000 9000 15000 21000];   % center frequency of the notch (stop frequency)
fs = 48000;                             % sample frequency
A = 1;                                  % denominator coefficients for H(z)
Nfft = 256;                             % number of points used to evaluate the frequency response
S = char('b-','m:','r-.','k--');        % line type control for the plot
myFontSize = 16;                        % font size for the plot labels

% Calculated terms and Simulation outputs
figure(1)
hold on

for i = 1:4     % calculate and plot |H| for various N's
    theta = 2*pi*notchFrequency(i)/fs;
    B = conv([1 -exp(j*theta)], [1 -exp(-j*theta)]);
    [H, f] = freqz(B, A, Nfft, fs);
    plot(f/1000, 20*log10(abs(H + eps)), S(i,:))
end

% Simulation outputs
set(gca, 'FontSize', myFontSize)
%set(P1, 'LineWidth', 1.5)
set(gca,'XTick', [0 3 6 9 12 15 18 21 24])
set(gca,'XTickLabel', [0 3 6 9 12 15 18 21 24]')
ylabel('|H(e^{j\omega})| (dB)')
xlabel('frequency (kHz)')
axis([0 24 -60 20])
legend(' 3000 Hz', ' 9000 Hz', '15000 Hz', '21000 Hz')
hold off

% print -depsc2 notchFilter