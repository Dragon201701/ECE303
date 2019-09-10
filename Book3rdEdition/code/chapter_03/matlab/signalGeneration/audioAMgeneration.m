%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ audioAMgeneration.m
%/
%/ This m-file amplitude modulates the information contained in a wav-file by 
%/ accomplishing the following tasks,
%/
%/  1. reads the wav-file
%/  2. if necessary, converts a stereo signals into a mono signal 
%/  3. loads a LP filter (Fpass < 9 kHz, Fstop > 10 kHz, for Fs = 44.1 KHz)
%/  4. filters the mono signal so that its maximum frequency is 10 kHz
%/  5. calculates the bias voltage to achieve the desired percent distortion
%/  6. amplitude modulates (AM-DSB w/ carrier) the filtered mono signal
%/  7. if desired, writes the AM signal to a wav-file
%/
%/ For this m-file, "percent distortion" is defined as the amount of the
%/ filtered signal that remains negative after the "required bias" is added.
%/
%/ "percentDistortion" = 100, results in the "requiredBias" = 0 
%/ "percentDistortion" = 0, results in the "requiredBias" = |min(signal level)|
%/
%/ You may need to modify the path and filename of,
%/
%/      the "wavread" command on line 34,
%/      the "load" command on line 40, and 
%/      the "wavwrite" command on line 90.
%/
%//////////////////////////////////////////////////////////////////////


% Simulation inputs
[wavData, Fs, Nbits] = wavread('C:\MATLAB6p1\work\wavFiles\testRecording.wav');
Fc = 10000;                 % AM carrier frequency (Hz)
percentDistorted = 1;       % percentage of the data that will be over-modulated
desiredMaxAmplitude = 0.99; % maximum amplitude PRIOR to wav-file conversion
numberOfBins = 1000;        % number of bins used for the wav-file's histogram
wavDesired = 'yes';         % do you want to create the wav-file?  (use 'yes')
load('LPfilter.mat');       % loads the LP filter data structure

% Calculated terms
if (Fs ~= 44100)            % verifies that the sample frequency is correct
    fprintf(1, 'The sample frequency associated with the wav-file you have loaded is not 44,100 Hz. \n')
    fprintf(1, 'This will prevent the filter from properly bandlimiting the signal prior to modulation. \n')
    break
end

wavSize = size(wavData);
if (wavSize(2) == 2)            % convert from stereo to mono (average L and R channels)
    wavData = sum(wavData, 2)/2;
end

filteredWavData = filter(filt1.tf.num, filt1.tf.den, wavData'); % filter the mono signal
t = (0:(wavSize(1) - 1))/Fs;    % create a time vector
carrier = cos(2*pi*Fc*t);       % create the carrier signal using the time vector

if (mod(numberOfBins,2) ~= 0)   % verifies that "the number of bins" is an even number
    fprintf(1, 'The number of bins must be an even number. \n')
    break
end

fprintf(1, ' \n')
if (percentDistorted < 0)|(percentDistorted > 100)  % error checking for proper range
    fprintf(1, 'PercentDistorted must be >= 0 percent and <= 100 percent. \n')
    break
elseif (percentDistorted == 0)      % special case ... bias set to keep signal >= 0
    fprintf(1, 'Percent distortion = 0 percent results in 100 percent modulation. \n')
    requiredBias = -min(filteredWavData);
elseif (percentDistorted == 100)    % special case ... no bias is required
    fprintf(1, 'Percent distortion = 100 percent results in AM-DSB suppressed carrier (sc). \n')
    requiredBias = 0;
else    % calculating the required bias using a cumulative distribution function (CDF) technique
    X = -1 + 1/(2*numberOfBins): 1/numberOfBins: 1 - 1/(2*numberOfBins);
    N = hist(filteredWavData, X);
    CDFfilteredWavData = cumsum(N)/wavSize(1);
    index = find(CDFfilteredWavData*200 < percentDistorted);
    requiredBias = -X(index(end));
    actualDistortion = CDFfilteredWavData(index(end))*200;
    fprintf(1, 'The actual percent distortion is %5.2f percent. \n', actualDistortion)
end

AM_msg = (requiredBias + filteredWavData).*carrier; % create the AM waveform
ScaledAM_msg = desiredMaxAmplitude*AM_msg/(max(abs(AM_msg)));
    
%Simulation outputs
fprintf(1, 'The bias level used to ensure that %5.2f percent distortion was not exceeded is %5.4f volts. \n', percentDistorted, requiredBias)

if wavDesired(1) == 'y' | wavDesired(1) == 'Y'
    wavwrite(ScaledAM_msg, Fs, Nbits, 'AMwavform.wav')
    fprintf(1, 'Writing the AM wav-file to disk is complete. \n')
end
fprintf(1, '\n')