%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/  GaussianNoiseAnalysis.m
%/
%/ This m-file creates Gaussianly distributed noise.  The PSD of the noise 
%/ is then displayed as is the PSD of the clipped noise.
%/
%//////////////////////////////////////////////////////////////////////

% Simulation inputs
numberOfPoints = 1000000;   % number of points

Nfft = 256;         % number of point considered at a time in the PSD calculation
Fs = 44100;         % sample frequency
maxNoise = 1.0;     % maximum value at which the noise will be clipped
minNoise = -1.0;    % minimum value at which the noise will be clipped

% Calculated terms
noise = randn(1, numberOfPoints);       % creates the Gaussianly distributed noise
clippedNoise = noise;                   % creates a copy of the noise

index = find(clippedNoise > maxNoise);  % finds indexes corresponding to noise > maxNoise
clippedNoise(index) = maxNoise;         % clips the maximum noise value at maxNoise

index = find(clippedNoise < minNoise);  % finds indexes corresponding to noise < minNoise
clippedNoise(index) = minNoise;         % clips the minimum noise value at minNoise

[Pnoise, freq] = psd(noise, Nfft, Fs);  % calculated the PSD of the noise
[PclippedNoise, freq] = psd(clippedNoise, Nfft, Fs);    % calculates the PSD of the clipped noise

%Simulation outputs
plot(freq, 10*log10(Pnoise), 'b')       % plots the PSD of the noise
hold on
plot(freq, 10*log10(PclippedNoise), 'r')% plots the PSD of the clipped noise
axis([0 22000 -5 5])
title('PSD of the Noise and Clipped Noise')
ylabel('power spectrum magnitude (dB)')
xlabel('frequency (Hz)')
legend('      noise', 'clipped noise')
hold off