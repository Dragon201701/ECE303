%  This m-file plots the magnitude of the frequency response of a 
%  notch filter for different values of r (pole radius).
%  
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2002
%  completed on 11 July 2002 revision 1.0

% Simulation inputs
notchFrequency = 9000;                  % center frequency of the notch (stop frequency)
r = [0 .5 .9 .99];                      % pole radius
fs = 48000;                             % sample frequency
Nfft = 512;                             % number of points used to evaluate the frequency response
S = char('b-','m:','r-.','k--');        % line type control for the plot
%S = char('b-','m-','r-','k-');        % line type control for the plot

myFontSize = 16;                        % font size for the plot labels

% Calculated terms and Simulation outputs
theta = 2*pi*notchFrequency/fs;

figure(1)
hold on

for i = 1:4     % calculate and plot |H| for various N's
    B = conv([1 -exp(j*theta)], [1 -exp(-j*theta)]);
    if (r == 0)
        A = [1];
    else
        A = conv([1 -r(i)*exp(j*theta)], [1 -r(i)*exp(-j*theta)]);
    end
    [H, f] = freqz(B, A, Nfft, fs);
    plot(f/1000, 20*log10(abs(H + eps)), S(i,:))
end

% Simulation outputs
set(gca, 'FontSize', myFontSize)
set(gca,'XTick', [0 3 6 9 12 15 18 21 24])
set(gca,'XTickLabel', [0 3 6 9 12 15 18 21 24]')
ylabel('|H(e^{j\omega})| (dB)')
xlabel('frequency (kHz)')
axis([0 24 -40 10])
legend('r = 0', 'r = 0.5', 'r = 0.9', 'r = 0.99', 4)
%gtext('r = 0', 'Fontsize', myFontSize)
%gtext('r = 0.5', 'Fontsize', myFontSize)
%gtext('r = 0.9', 'Fontsize', myFontSize)
%gtext('r = 0.99', 'Fontsize', myFontSize)
hold off

% print -depsc2 notchFilterFreqResponseRevA