%% This m-file implements the simulation of a noise cancelling 
% adaptive filter. A chirp (FM slide) is added to a voice signal as an 
% interferring or noise signal. The adaptive filter attempts to remove
% the chirp signal.

% The Communications Toolbox is required to create the chirp signal

% by Dr. Thad B. Welch, P.E.
%
% first created - 12 February 2012
% last updated - 8 May 2016

%% Declarations and adaptive filter preparation
N = 20; % number of adaptive filter coefficents
mu = 0.01; % convergence factor 
f0 = 1000; % chirp start frequency
f1 = 5000; % chirp stop frequency
tStop = 20; % time for the chirp to be at f1

% read in the recorded signal
[voice, Fs] = audioread('voiceRecording.wav'); 
voice = voice'; % convert the column to a row

M = length(voice); % number of samples to be simulated
t = (1:M)/Fs; % create a time vector for the chirp command
noise = chirp(t, f0, tStop, f1); % create a chirp signal
x(2:N) = noise(N-1:-1:1); % create the noise storage array
w = zeros(1, N); % initialize the adaptive filter coefficents

dStorage = voice + noise; % create the signal plus noise
dStorage = dStorage/max(abs(dStorage)); % normalize dStorage
yStorage = zeros(1, M); % storage array for filtered noise
eStorage = zeros(1, M); % storage array for the "cleaned up" signal

%%  Algorithm for the adaptive filtering 
for j = N:M
    % ISR simulation starts here ... input the two channels of data
    x(1) = noise(j); % interference (noise) signal
    d = dStorage(j); % voice signal + interference
    
    % adaptively filter the interference signal
    y = 0;
    for i = 0:N-1
        y = y + w(i+1)*x(N-i);
    end
    
    % estimate the voice signal
    e = d - y;
    
    % update the filter coefficents
    for i = 1:N
        w(i) = w(i) + 2*mu*e*x(N-i+1);
    end
    
    % prepare the x array for the next input sample
    for i = N:-1:2
        x(i) = x(i-1);
    end
    % the ISR simulation ends here
    
    % storage for post simulation use
    yStorage(j) = y;
    eStorage(j) = e;
end

%% Listen to the results
% the original voice signal
soundsc(voice, Fs)

% the voice signal with interference
pause(24)
soundsc(dStorage, Fs)

% the adaptive filter's output 
% voice signal with the interference minimized
pause(24)
soundsc(eStorage, Fs)

% normalized plots ... zoom in to compare the results
figure(1)
plot(voice/max(abs(voice)), 'b') % the original voice signal
hold on
plot(eStorage/max(abs(eStorage)), 'r') % the recovered signal
legend('original voice signal', 'recovered voice signal')

figure(2)
plot(dStorage)
