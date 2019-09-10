%  Effect of zeroing the even numbered coefficents
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%
%  copyright 2005, 2016, completed on ... 4 August 2005
%  updated "remez" to "firpm"

%B = remez(6, [0.4 0.6] , [1 1], 'h');
B = firpm(6, [0.4 0.6] , [1 1], 'Hilbert');
[H, f] = freqz(B, 1, 1024*8, 48000);
plot(f/1000, 20*log10(abs(H))*1000, 'b')
axis([10 14 -5 5])
grid
hold on

B(2:2:6) = 0;
[H, f] = freqz(B, 1, 1024*8, 48000);
plot(f/1000, 20*log10(abs(H))*1000,'r:')
legend('theoretical response','actual response', 'Location', 'North')
ylabel('|H(e^{j \omega})| (mdB)')
xlabel('frequency (kHz)')
hold off

% FIR_dump2c('hilbert', 'B', B, length(B));
