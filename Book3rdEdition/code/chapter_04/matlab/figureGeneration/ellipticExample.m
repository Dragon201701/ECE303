%  This m-file demonstartes the effect of quantizing the 
%  filter coefficients associated with an IIR filter
%  whose poles are VERY near the unit circle
%  
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2003
%
%  14 May 2003 revision 1.0 DF and sos plots
%  15 May 2003 revision 1.1 parallel form added

% Simulation inputs
%myFontSize = 16;   % font size for the plot labels
Fs = 48000;         % sample frequency
Nfft = 1024;        % number of samples in a block
n_bits = 16;        % number of bits used to represent the coefficients
Htemp = 0;          % initialization of the H vector


% Calculated terms
[B, A] = ellip(4, 1, 60, 0.01);
full_scale = 2^(n_bits-1);
difference = length(B) - length(A);
filt1.tf.num = B;
filt1.tf.den = A;
filt1.Fs = Fs;
n_bits_string = num2str(n_bits);

% rounded DF technique
quantized_B = round(B*full_scale)/full_scale;
quantized_A = round(A*full_scale)/full_scale;
[s1, s2, p1, p2] = stable(B, A, quantized_B, quantized_A);
figure(1)
q_zpln_b(B, A, quantized_B, quantized_A, p1, p2);
title(['Effects of ' n_bits_string ' Bit Quantization, DF Implementation'])

figure(2)
[H, f] = freqz(B, A, Nfft, Fs);
plot(f, 20*log10(abs(H)), 'b')
hold on
[H, f] = freqz(quantized_B, quantized_A, Nfft, Fs);
plot(f, 20*log10(abs(H)), 'r')
grid
axis([0 24000 -80 0])
legend('double precision', 'quantized')
title('Frequency Response')
ylabel('|H(f)|, (dB)')
xlabel('frequency, (Hz)')
hold off

if sum(abs(roots(quantized_A))>1)
    beep
    if (sum(abs(roots(quantized_A)) > 1) == 1)
        disp('A DF pole is outside the unit circle!')
    else
        disp('DF poles are outside the unit circle!')
    end
end

% rounded sos technique
if (difference == 0)
    [Z,P,k] = tf2zp(filt1.tf.num, filt1.tf.den);
elseif (difference < 0)
    [Z,P,k] = tf2zp([filt1.tf.num zeros(1, -difference)], filt1.tf.den);
else
    [Z,P,k] = tf2zp(filt1.tf.num, [filt1.tf.den zeros(1, difference)]);
end
filt1.sos = zp2sos(Z, P, k);
filt2.sos = round(filt1.sos*full_scale)/full_scale;
[new_numerator, new_denominator] = sos2tf(filt2.sos);
[H_old,f] = freqz(B, A, Nfft, Fs);
[H_new,f] = freqz(new_numerator, new_denominator, Nfft, Fs);
[s1,s2,p1,p2] = stable(B, A, new_numerator, new_denominator);
figure(3)
q_zpln_b(B, A, new_numerator, new_denominator, p1, p2);
title(['Effects of ' n_bits_string ' Bit Quantization, SOS Implementation'])

figure(4)
plot(f, 20*log10(abs(H_old)), 'b')
hold on
plot(f, 20*log10(abs(H_new)), 'r')
grid
axis([0 24000 -80 0])
legend('double precision', 'quantized')
title('SOS Frequency Response')
ylabel('|H(f)|, (dB)')
xlabel('frequency, (Hz)')
hold off

if sum(abs(roots(new_denominator)) > 1)
    beep
    if (sum(abs(roots(new_denominator))>1) == 1)
        disp('A sos pole is outside the unit circle!')
    else
        disp('sos poles are outside the unit circle!')
    end
end

% rounded parallel form technique
figure(5)
[parallel_B, parallel_A, K] = filt2par(filt1);
[M, N] = size(parallel_A);      % determining the number of parallel terms
quantized_parallel_B = round(parallel_B*full_scale)/full_scale;
quantized_parallel_A = round(parallel_A*full_scale)/full_scale;
P = [roots(quantized_parallel_A(1,:)); roots(quantized_parallel_A(2,:));];
Z = [roots(quantized_parallel_B(1,:)); roots(quantized_parallel_B(2,:));];

if sum(abs([roots(quantized_parallel_A(1,:)) roots(quantized_parallel_A(2,:))]) > 1)
    beep
    if (sum(abs([roots(quantized_parallel_A(1,:)) roots(quantized_parallel_A(2,:))]) > 1) == 1)
        disp('A parallel pole is outside the unit circle!')
    else
        disp('Parallel poles are outside the unit circle!')
    end
end

plot(P, 'x')
hold on
plot(Z + j*eps, 'o')
plot(exp(j*2*pi*(0:10000)/10000), 'r')
plot([-1.2 1.2], [0 0])
plot([0 0], [1.2 -1.2])
axis([-1.2 1.2 -1.2 1.2])
axis('square')
title(['Effects of ' n_bits_string ' Bit Quantization, Parallel Form Implementation'])
ylabel('Imaginary part')
xlabel('Real part')
hold off

[H_theory, f1] = freqz(B, A, Nfft, Fs);

% Calculate the parallel form theoretical results
for i = 1:M
    [H, f] = freqz(quantized_parallel_B(i,:), quantized_parallel_A(i,:), Nfft, Fs);
    Htemp = Htemp + H;
end

% adding in the effect of the gain term (K)
[H, f] = freqz(1, 1, Nfft, Fs);
Htemp = Htemp + K*H;

% Simulation outputs
figure(6)
plot(f1/1000, 20*log10(abs(H_theory + eps)), 'b')
hold on
plot(f/1000, 20*log10(abs(Htemp + eps)), 'r')
%set(gca, 'FontSize', myFontSize)
set(gca,'XTick', [0 3 6 9 12 15 18 21 24])
set(gca,'XTickLabel', [0 3 6 9 12 15 18 21 24]')
title('Parallel Form Frequency Response')
ylabel('|H(e^{j\omega})| (dB)')
xlabel('frequency, (kHz)')
axis([0 24 -100 10])
legend('double precision', 'quantized')
hold off

% print -depsc2 butterworthZplanePlot
% print -depsc2 butterworthFreqzPlot
