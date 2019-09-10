%  This m-file creates plots for the signal period explanation
%  portion of the signal generation chapter.
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2003, 2016
%  completed on 16 July 2003 revision 1.0
%  last updated on 27 May 2016 revision 1.2

% Simulation inputs
maxOrder = 100;
fStart = 0.1;
fStop = 0.9;
maxDeviation = 0.1; % maximum flatness deviation in dB
Nfft = 256;
Fs = 48000;         % sample frequency
S = char('b-','m:','r-.','k--'); % line type control for the plot
myFontSize = 16;    % font size for the plot labels

% calculations
for order = 4:maxOrder
    B = firpm(order, [fStart fStop], [1 1], 'Hilbert');
    [H, f] = freqz(B, 1, Nfft);
    range = find((f/pi >= fStart) & (f/pi <= fStop));
    if (((abs(20*log10(max(abs(H(range)))))) > maxDeviation) | ((abs(20*log10(min(abs(H(range)))))) > maxDeviation))
        continue
    else
        order
        break
    end
end

% Simulation outputs
figure(1)
B = firpm(4, [fStart fStop], [1 1], 'Hilbert');
[H, f] = freqz(B, 1, Nfft, Fs);
plot(f/1000, 20*log10(abs(H + eps)), S(1,:))
hold on
B = firpm(8, [fStart fStop], [1 1], 'Hilbert');
[H, f] = freqz(B, 1, Nfft, Fs);
plot(f/1000, 20*log10(abs(H + eps)), S(2,:))
B = firpm(22, [fStart fStop], [1 1], 'Hilbert');
[H, f] = freqz(B, 1, Nfft, Fs);
plot(f/1000, 20*log10(abs(H + eps)), S(3,:))
plot([0.1*Fs/2000 0.1*Fs/2000], [10 -50], 'k')
plot([0.9*Fs/2000 0.9*Fs/2000], [10 -50], 'k')
hold off
set(gca, 'XTick', [0 3 6 9 12 15 18 21 24])
set(gca, 'XTickLabel', [0 3 6 9 12 15 18 21 24])
set(gca, 'FontSize', myFontSize)
axis([0 Fs/2000 -50 10])
legend(' 4^{th} order', ' 8^{th} order', '22^{th} order', 'Location', 'South')
ylabel('|H(j\omega)| (dB)')
xlabel('frequency (kHz)')

% print -depsc2 signalPeriod
