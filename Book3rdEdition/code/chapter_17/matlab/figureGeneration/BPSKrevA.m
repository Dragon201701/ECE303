%  Simulation of a BPSK modulator and its coherent recovery
%
%  Implementation of a second-order Costas loop based 
%  on Figure 6.3, page 77 of Steven A. Tretter's
%
%  "Communication System Design Using DSP Algorithms"
%  copyright 1995, Plenum Press
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2002, 2003, 2016
%
%  28  March 2002 - revision 1.0 ... initial implementation
%  23 August 2003 - revision 1.1 ... more realistic
%  27 May 2016 - revision 1.2 ... pwelch command replace psd

%  input terms
Fmsg = 12000;   % carrier frequency of the BPSK transmitter (Hz)
VCOrestFrequencyError = 200*randn(1);   % VCO's error (Hz)
VCOphaseError = 2*pi*rand(1);           % VCO's error (radians)
Fs = 48000;                             % sample frequency (Hz)
N = 1000;                               % samples in the simulation
samplesPerBit = 20;                     % sample per data bit
dataRate = Fs/samplesPerBit;            % data rate (bits/second)
beta = 0.002;                           % loop filter parameter "beta"
alpha = 0.01;                           % loop filter parameter "alpha"
noiseVariance = 0.0001;                 % noise variance
Nfft = 1024;                            % number of samples in an FFT
amplitude = 32000;                      % ADC scale factor
scaleFactor = 1/32768/32768;            % feedback loop scale factor

%  input term initializations
phaseDetectorOutput = zeros(1, N+1);
vcoOutput = [exp(-j*VCOphaseError) zeros(1, N)];  % random phase for the VCO's initial conditions
m = zeros(1, N+1);
q = zeros(1, N+1);
loopFilterOutput = zeros(1, N+1);
phi = [VCOphaseError zeros(1, N)];
Zi = 0;

%  calculated terms
Fcarrier = Fmsg + VCOrestFrequencyError;    % VCO's rest frequency
T = 1/Fs;                                   % sample period
B = [(alpha + beta) -alpha];                % loop filter combined numerator
A = [1 -1];                                 % loop filter combined denominator
Nbits = N/samplesPerBit;                    % number of bits in the simulation
noise = sqrt(noiseVariance)*randn(1, N);    % creation of the AWGN vector

%  random data generation and expansion (to allow for BPSK modulation)
data = 2*(randn(1, Nbits) > 0) - 1;
expandedData = amplitude*reshape(ones(samplesPerBit, 1)*data, 1, N);

%  BPSK signal and its Hilbert transform (analytic signal) generation
BPSKsignal = cos(2*pi*(0:N-1)*Fmsg/Fs).*expandedData + noise;
analyticSignal = hilbert(BPSKsignal);

%  processing the data by thr PLL
for i = 1:N
    phaseDetectorOutput(i+1) = analyticSignal(i)*vcoOutput(i);
    m(i+1) = real(phaseDetectorOutput(i+1));
    q(i+1) = scaleFactor*real(phaseDetectorOutput(i+1))*imag(phaseDetectorOutput(i+1));
    [loopFilterOutput(i+1), Zf] = filter(B, A, q(i+1), Zi);
    Zi = Zf;
    phi(i+1) = mod(phi(i) + loopFilterOutput(i+1) + 2*pi*Fcarrier*T, 2*pi);
    vcoOutput(i+1) = exp(-j*phi(i+1));
end

%  another way of creating the Hilbert transform of a signal
%  transformedSignal = ifft(fft(signal).*[-j*ones(1,501) j*ones(1,499)]);

%  Plotting commands follow ...
%  output terms
figure(1)
plot(0:N-1, BPSKsignal, 'b')
hold on
plot(0:N-1, imag(analyticSignal), 'r')
title('BPSK Signal and its Hilbert Transform')
ylabel('sample values')
xlabel('sample number, n')
legend('input signal', 'transformed signal', 'Location', 'South')
hold off

figure(2)
zplane(B, A)
title('Pole/Zero Plot for the Loop Filter')

figure(3)
freqz(B, A, Nfft, Fs/1000)
title('Frequency Response of the Loop Filter')

figure(4)
%psd(BPSKsignal, [], Fs)
[P, w] = pwelch(BPSKsignal, [], [], Nfft, Fs);
plot(w/1000, 10*log10(P/max(P)))
ylabel('spectral estimate (dB)')
xlabel('frequency (kHz)')
axis([0 24 -50 10])

figure(5)
plot(0:N-1, BPSKsignal, 'b')
hold on
plot(0:N, amplitude*real(vcoOutput), 'r')
title('Modulated Signal and the VCO''s Output Signal')
ylabel('sample values')
xlabel('sample number, n')
legend('input signal', 'vco''s output')
% axis([0 N -1.4 1.4])
hold off

figure(6)
plot(0:N-1, expandedData, 'b')
hold on
plot(0:N, m, 'r')
title('Message and the Recovered Message')
ylabel('sample values')
xlabel('sample number, n')
legend('message', 'recovered message')
% axis([0 N -1.4 1.4])
hold off
