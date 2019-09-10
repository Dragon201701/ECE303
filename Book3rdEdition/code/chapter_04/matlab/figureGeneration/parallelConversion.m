%  This m-file plots the magnitude of the frequency response of a filter
%  and shifts the transfer function into parallel implementation form.
%  
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2003
%  completed on 12 March 2003 revision 1.0
%
%  setup to work with a 4th order IIR filter
%
%  need to extract the conversion routine ... function?

% Simulation inputs
fs = 48000;                         % sample frequency
Nfft = 1024;                        % number of points used to evaluate the frequency response
S = char('b-','m:','r-.','k--');    % line type control for the plot
myFontSize = 16;                    % font size for the plot labels
noise = randn(1,1000000);           % filter input (noise)
counter = 0;                        % counter for the A or B vector entry
skip = 0;                           % skip = 1 to skip the 2nd term in a complex pair
B = [];                             % numerator polynomial matrix
A = [];                             % denominator polynomial matrix

% Calculated terms
[R, P, K] = residuez(filt1.tf.num, filt1.tf.den)

B1 = real(R(1)*[1 -P(2)] + R(2)*[1 -P(1)])
A1 = real(conv([1 -P(1)], [1 -P(2)]))

B2 = real(R(3)*[1 -P(4)] + R(4)*[1 -P(3)])
A2 = real(conv([1 -P(3)], [1 -P(4)]))

[H_theory, f1] = freqz(filt1.tf.num, filt1.tf.den, Nfft, fs);

[H1, f1] = freqz(B1, A1, Nfft, fs);
[H2, f1] = freqz(B2, A2, Nfft, fs);
[H3, f1] = freqz(1, 1, Nfft, fs);

y = filter(B1, A1, noise) + filter(B2, A2, noise) + K*noise;
[Txy, f2] = tfe(noise, y, Nfft, fs);

% converting from residuez form to parallel implementation form
for i = 1:length(P)
    if (skip == 0)
        counter = counter + 1;
        if (i == length(P))
            B(counter, :) = [0 R(i)];
            A(counter, :) = [0 1 -P(i)];
        else
            if (P(i) == conj(P(i+1)))
                skip = 1;
                B(counter, :) = real(R(i)*[1 -P(i+1)] + R(i+1)*[1 -P(i)]);
                A(counter, :) = real(conv([1 -P(i)], [1 -P(i+1)]));
            else
                B(counter, :) = [0 R(i)];
                A(counter, :) = [0 1 -P(i)];
            end
        end
    else
        skip = 0;
    end
end

B
A

% Simulation outputs
figure(1)
plot(f1/1000, 20*log10(abs(H_theory + eps)), S(1,:))
hold on
plot(f1/1000, 20*log10(abs(H1 + H2 + K*H3)), S(2,:))
plot(f2/1000, 20*log10(abs(Txy)), S(3,:))

set(gca, 'FontSize', myFontSize)
set(gca,'XTick', [0 3 6 9 12 15 18 21 24])
set(gca,'XTickLabel', [0 3 6 9 12 15 18 21 24]')
ylabel('|H(e^{j\omega})| (dB)')
xlabel('frequency (kHz)')
axis([0 24 -100 10])
legend('theoretical results (DF-I)', 'theoretical results (parallel form)', 'calculated result (MATLAB tfe)')
hold off

% print -depsc2 notchFilter
