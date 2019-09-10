%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ BPSK signal generator
%/
%//////////////////////////////////////////////////////////////////////

%  input terms
Fmsg = 12000;       % carrier frequency of the BPSK transmitter (Hz)
Fs = 96000;         % sample frequency of the simulation (Hz)
dataRate = 2400;    % data rate
time = 30;          % length of the signal in seconds
amplitude = 0.99;   % scale factor (sound card needs < +/- 1)
Nfft = 1024;
Nbits = 16;

%  calculated terms
numberOfSamples = Fs*time;
samplesPerSymbol = Fs/dataRate;
t = 0:(1/Fs):(time - 1/Fs);

data = 2*(randn(1, round(numberOfSamples/samplesPerSymbol)) > 0) - 1;
expandedData = reshape(ones(samplesPerSymbol, 1)*data, 1, numberOfSamples);

BPSKsignal = amplitude*cos(2*pi*Fmsg*t).*expandedData;

wavwrite(BPSKsignal, Fs, Nbits, 'BPSKsignal')

%  output terms
figure(1)
psd(BPSKsignal, Nfft, Fs)

figure(2)
plot(t, BPSKsignal)
