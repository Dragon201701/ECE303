%  This m-file plots the magnitude of the frequency response of a 
%  notch filter for different values of r (pole radius).
%  
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2002
%  completed on 12 July 2002 revision 1.0

% Simulation inputs
myFontSize = 16;                % font size for the plot labels
Nfft = 1024;                    % samples per block
Fs = 48000;                     % sample frequency

% Calculated terms
[B, A] = butter(4, 0.25)
[Z, P, K] = tf2zp(B, A);

Bshort = (round(B*10000))/10000;
Ashort = (round(A*10000))/10000;
[Zshort, Pshort, Kshort] = tf2zp(Bshort, Ashort);

% Simulation outputs
roots(B)
roots(Bshort)

roots(A)
roots(Ashort)

figure(1)
%zplane(B, A, 'r')
zplane([Z Zshort], [P Pshort])
hold on
%pause
%zplane(Bshort, Ashort)
plot(exp(j*(0:10000)*2*pi/10000), 'r')
axis([-1.4 1.4 -1.4 1.4])
set(gca, 'FontSize', myFontSize)
ylabel('imaginary part')
xlabel('real part')
hold off

figure(2)
set(gca, 'FontSize', myFontSize)
freqz(B,A)
% freqz(B, A, Nfft, Fs)
% hold on
% freqz(Bshort, Ashort, Nfft, Fs)
% axis([0 24000 -80 0])
% hold off

figure(3)
set(gca, 'FontSize', myFontSize)
grpdelay(B,A);

% print -depsc2 butterworthZplanePlot
% print -depsc2 butterworthFreqzPlot
