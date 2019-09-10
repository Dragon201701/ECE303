%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ This m-file calculates the execution time for a brute force DFT
%/
%//////////////////////////////////////////////////////////////////////

% Simulation inputs
exponent = 8;
timeDFT = [];
timeFFT = [];
myFontSize = 16;    % font size for the plot labels

% calculations
for N = 2.^(1:exponent)
    x = randn(1, N);
    tic
    for repeat = 1:10
        for m = 1:N
            X(m) = 0;
            for n = 1:N
                X(m) = X(m) + x(n)*exp(-j*2*pi*(n-1)*(m-1)/N);
            end
        end
    end
    timeDFT = [timeDFT toc/10];
end

for N = 2.^(1:(exponent + 14))
    x = randn(1, N);
    tic
    for repeat = 1:10
        fft(x);
    end
    timeFFT = [timeFFT toc/10];
end

% Simulation outputs
plot(timeDFT + eps, 'b')
set(gca, 'FontSize', myFontSize)
hold on
plot(timeFFT + eps, 'r--')
legend('DFT', 'FFT', 'Location', 'NorthWest')
ylabel('execution time (s)')
xlabel('n, where the FFT block size is N = 2^n')
axis([0 24 0 4])
hold off

%print -depsc2 DFT_FFT_timing  % save EPS file of plot
