%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ This m-file is used to generate plots of various
%/ common windowing functions used in spectral analysis.
%/
%//////////////////////////////////////////////////////////////////////

% Simulation inputs
N = 128;
alpha = 3;
Nfft = 1024*8;
Fs = 48000;

S = char('b-','m:','r-.','k--'); % line type control for the plot
myFontSize = 16;                 % font size for the plot labels

% Calculated terms
w1 = bartlett(N);
w2 = hamming(N);
w3 = rectwin(N);
w4 = kaiser(N, alpha);

[H3, f] = freqz(w3/sum(w3), 1, Nfft, Fs);
[H2, f] = freqz(w2/sum(w2), 1, Nfft, Fs);

% Output terms
figure(1)
P1 = plot(w3, S(1,:));
set(P1, 'LineWidth', 1.5)
set(gca, 'FontSize', myFontSize)
hold on
P2 = plot(w4, S(2,:));
set(P2, 'LineWidth', 1.5)
P3 = plot(w2, S(3,:));
set(P3, 'LineWidth', 1.5)
P4 = plot(w1, S(4,:));
set(P4, 'LineWidth', 1.5)
legend('Rectangular', 'Kaiser, \alpha = 3', 'Hamming', 'Bartlett')
axis([0 129 -.2 1.2])
set(gca, 'XTick', [0 32 64 96 128])
set(gca, 'XTickLabel', [0 32 64 96 128])
ylabel('window value')
xlabel('n')
hold off

figure(2)
subplot(2,2,1)
P3 = plot(w3, S(1,:));
set(P3, 'LineWidth', 1.5)
set(gca, 'FontSize', myFontSize)
axis([0 129 -.2 1.2])
set(gca, 'XTick', [0 32 64 96 128])
set(gca, 'XTickLabel', [0 32 64 96 128])
ylabel('rectangular window')
xlabel('n')

subplot(2,2,2)
plot(f/1000, 20*log10(abs(H3 + eps)))
set(gca, 'FontSize', myFontSize)
axis([0 6 -65 5])
%set(gca, 'XTick', [0 3 6 9 12 15 18 21 24])
%set(gca, 'XTickLabel', [0 3 6 9 12 15 18 21 24])
ylabel('|H(j\omega)| - rectangular')
xlabel('frequency (kHz)')

subplot(2,2,3)
P2 = plot(w2, S(1,:));
set(P2, 'LineWidth', 1.5)
set(gca, 'FontSize', myFontSize)
axis([0 129 -.2 1.2])
set(gca, 'XTick', [0 32 64 96 128])
set(gca, 'XTickLabel', [0 32 64 96 128])
ylabel('Hamming window')
xlabel('n')

subplot(2,2,4)
plot(f/1000, 20*log10(abs(H2 + eps)))
set(gca, 'FontSize', myFontSize)
axis([0 6 -65 5])
%set(gca, 'XTick', [0 3 6 9 12 15 18 21 24])
%set(gca, 'XTickLabel', [0 3 6 9 12 15 18 21 24])
ylabel('|H(j\omega)| - Hamming')
xlabel('frequency (kHz)')

%print -depsc2 windowExample