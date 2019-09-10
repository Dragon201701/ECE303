%% Create the stereo wav file to test the adaptive filter

% by Dr. Thad B. Welch, P.E.
%
% first created - 15 May 2016
% last updated - 15 May 2016

% load the chirp signal and read in the recorded voice signal
load('chirpSignal.mat'); % the chirp noise data array

[voice, Fs] = audioread('voiceRecording.wav'); 

noise = noise';

x = voice + noise; % create the signal plus noise
x = x/max(abs(x)); % normalize x

% create the ouptut signal
output = [x, noise]; % first column is x, second column is noise

% create wav file
audiowrite('AFtestSignal.wav', output, 48000);
