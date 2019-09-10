%  This m-file provides a convenient test for the filt2par function.
%  
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2003
%  completed on 13 March 2003 revision 1.0

% Simulation inputs
fs = filt1.Fs;                      % sample frequency
Nfft = 8192;                        % number of points used to evaluate the frequency response
S = char('b-','m:','r-.','k--');    % line type control for the plot
myFontSize = 16;                    % font size for the plot labels
Htemp = 0;                          % initialization of the H vector

% Calculated terms
[B, A, K] = filt2par(filt1)         % filt1 to parallel conversion function
[M, N] = size(A);                   % determining the number of parallel terms

% Calculate the DF-I theoretical results
[H_theory, f1] = freqz(filt1.tf.num, filt1.tf.den, Nfft, fs);

% Calculate the parallel form theoretical results
for i=1:M
    [H, f] = freqz(B(i,:), A(i,:), Nfft, fs);
    Htemp = Htemp + H;
end

% adding in the effect of the gain term (K)
[H, f] = freqz(1, 1, Nfft, fs);
Htemp = Htemp + K*H;

% Simulation outputs
plot(f1/1000, 20*log10(abs(H_theory + eps)), S(1,:))
hold on
plot(f/1000, 20*log10(abs(Htemp + eps)), S(2,:))
set(gca, 'FontSize', myFontSize)
set(gca,'XTick', [0 3 6 9 12 15 18 21 24])
set(gca,'XTickLabel', [0 3 6 9 12 15 18 21 24]')
ylabel('|H(e^{j\omega})| (dB)')
xlabel('frequency (kHz)')
axis([0 24 -100 10])
legend('theoretical results (DF-I)', 'theoretical results (parallel form)')
hold off

% print -depsc2 filt2parallel