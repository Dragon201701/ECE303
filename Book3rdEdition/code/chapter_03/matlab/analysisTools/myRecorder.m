%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ This m-file uses the PC's sound card to record audio signals into MATLAB and 
%/ then displays the signals (amplitude-time, spectrogram, and average periodogram)
%/ which can be converted to a wav-file and stored to disk.  The file can also be 
%/ transferred to other media (e.g. CD-R or CD-RW).
%/
%/ Approx. 42 MB of system memory is used to store a 60 second stereo recording.
%/   The memory usage decreases to approximately 21 MB for a mono recording.
%/
%/            ***** Be careful NOT to make "duration" to large! *****
%/
%/ A 60 second stereo wav-file will occupy approximately 10.3 MB of hard drive space.
%/          File size decreases to approx. 5.1 MB for a mono recording.
%/
%/ You will need to modify the path and filename in the "wavwrite" command 
%/
%//////////////////////////////////////////////////////////////////////


% Simulation inputs
Fs = 44100;         % sample frequency in hertz (Hz)
Nbits = 16;         % number of bits per sample (must be 8 or 16)
numChannels = 2;    % number of channels (must be 1 or 2)
duration = 5;       % duration of the recoring in seconds
plotDesired = 'yes';% if you want to see the plots, use 'yes'
wavDesired = 'yes'; % if you want to create the wav-file, use 'yes'

% Error checking
if ~((numChannels == 1)|(numChannels == 2))
    disp('The number of channels MUST be either 1 or 2.')
    disp('M-file terminated without recording.')
    break
end

if ~((Nbits == 8)|(Nbits == 16))
    disp('The number of bits per sample MUST be either 8 or 16')
    disp('M-file terminated without recording.')
    break
end

% Calculated terms
recorder = audiorecorder(Fs, Nbits, numChannels);   % initializing the audio recorder
recordblocking(recorder, duration + 1/Fs);          % commence the recording
pause(.1)                                           % 0.1 second pause to prevent a warning
audioarray = getaudiodata(recorder);                % getting the data from the recorder
t = (0:(length(audioarray)-1))/Fs;                  % creating a time vector for plotting

%Simulation outputs
if plotDesired(1) == 'y' | plotDesired(1) == 'Y'
    subplot(3, 1, 1)    % amplitude-time plot
    plot(t, audioarray(:,1))
    axis tight
    title('Recorded Data')
    ylabel('signal amplitude (V)')
    xlabel('time (s)')

    subplot(3, 1, 2)    % spectrogram
    specgram(audioarray(:,1), [], Fs)
    ylabel('frequency (Hz)')
    xlabel('time (s)')

    subplot(3, 1, 3)    % average periodogram
    psd(audioarray(:,1), [], Fs)
    axis tight
    ylabel('power spectrum magnitude (dB)')
    xlabel('frequency (Hz)')
end

if wavDesired(1) == 'y' | wavDesired(1) == 'Y'
    wavwrite(audioarray, Fs, Nbits, 'C:\MATLAB6p1\work\wavFiles\testRecording.wav')
end