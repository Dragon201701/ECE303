%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ 2-band equalizer design
%/
%//////////////////////////////////////////////////////////////////////


Nfft = 1024;
Fs = 48000;
load('equalizerDesign');

[Hlp, f] = freqz(Blp, 1, Nfft, Fs);
[Hhp, f] = freqz(Bhp, 1, Nfft, Fs);

figure(1)
plot(f, 20*log10(abs(Hlp)), 'b')
hold on
plot(f, 20*log10(abs(Hhp)), 'r')
plot(f, 20*log10(abs(Hlp + Hhp)), 'k')
hold off
axis([0 Fs/2 -90 10])
title('2-Band Equalizer')
ylabel('magnitude (dB)')
xlabel('frequency (Hz)')
legend('LP filter', 'HP filter', 'Sum')