%
%
%

Am = 0.5;
fc = 2000;
fm = 1950;

fs = 44100;
duration = 30;
Nbits = 16;

Ac = 0.999/(1 + Am);
t = 0:1/fs:duration;
AM = Ac*(1 + Am*cos(2*pi*fm*t)).*cos(2*pi*fc*t);

%plot(t(1:2000),AM(1:2000))
wavwrite(AM,fs,Nbits,'C:\matlabR12\work\WavFilesForDSP\AM_2000_1950.wav')