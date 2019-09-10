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
n_bits = 32;

% Calculated terms
[B, A] = butter(4, 0.25)
[Z, P, K] = tf2zp(B, A);

figure(1)
plot(roots(A), 'x')
hold on
axis([-1.4 1.4 -1.4 1.4])
plot(exp(j*(0:10000)*2*pi/10000), 'r')
set(gca, 'FontSize', myFontSize)
ylabel('imaginary part')
xlabel('real part')

for n_bits = 16:-1:5
    pause(0.3)
    % quantization technique declaration
    full_scale=2^(n_bits-1);
    new_B = round(B*full_scale)/full_scale;
    new_A = round(A*full_scale)/full_scale;
    plot(roots(new_A), 'rx')
end

hold off

% print -depsc2 butterworthZplanePlot
% print -depsc2 butterworthFreqzPlot
