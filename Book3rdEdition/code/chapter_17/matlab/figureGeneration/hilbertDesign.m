%  Hilbert transform ... FIR filter design
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2004, 2005, 2016

%  input terms
order = 30;         % filter order
f = [0.1 0.9];      % filter specs ... frequency
A = [1 1];          % filter specs ... amplitude
Fs = 48000;         % sample frequency of the simulation (Hz)
Nfft = 1024;        % number of samples in an FFT
myFontSize = 16;    % font size for the plot labels
warning off;        % turn off MATLAB warnings

%  calculated terms
B = firpm(order, f, A, 'Hilbert');

%  output terms
figure(1)
P1 = stem(B);
set(gca, 'FontSize', myFontSize)
axis([0 32 -1 1])
ylabel('filter coefficient value')
xlabel('sample number, n')
set(P1, 'LineWidth', 1.5)
% print -deps2 HTimpulseResponse

figure(2)
[H, f] = freqz(B, 1, Nfft, Fs);
subplot(2,1,1)
P2a = plot(f/1000, 20*log10(abs(H)));
set(gca, 'FontSize', myFontSize)
set(P2a, 'LineWidth', 1.5)
ylabel('magnitude (dB)')
axis([0 24 -35 5])
set(gca,'XTick', [0 4 8 12 16 20 24])
set(gca,'XTickLabel', [0 4 8 12 16 20 24]')
subplot(2,1,2)

P2b = plot(f/1000, unwrap(angle(H))*180/pi);
set(gca, 'FontSize', myFontSize)
set(P2b, 'LineWidth', 1.5)
xlabel('frequency (kHz)')
ylabel('phase (degrees)')
axis([0 24 -3000 0])
set(gca,'XTick', [0 4 8 12 16 20 24])
set(gca,'XTickLabel', [0 4 8 12 16 20 24]')
% print -deps2 HTfrequencyResponse

figure(3)
P3 = plot(f/1000, 20*log10(abs(H)));
set(gca, 'FontSize', myFontSize)
set(P3, 'LineWidth', 1.5)
xlabel('frequency (kHz)')
ylabel('magnitude (dB)')
axis([0 24 -0.03 0.03])
set(gca,'XTick', [0 4 8 12 16 20 24])
set(gca,'XTickLabel', [0 4 8 12 16 20 24]')
% print -deps2 HTfrequencyResponseZoomed

figure(4)
[Gd, f] = grpdelay(B, 1, Nfft, Fs);
P4 = plot(f/1000, Gd);
set(gca, 'FontSize', myFontSize)
set(P4, 'LineWidth', 1.5)
xlabel('frequency (kHz)')
ylabel('delay (samples)')
axis([0 24 10 20])
set(gca,'XTick', [0 4 8 12 16 20 24])
set(gca,'XTickLabel', [0 4 8 12 16 20 24]')
% print -deps2 HTgroupDelay
