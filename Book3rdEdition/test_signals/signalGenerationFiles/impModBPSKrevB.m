function [outputArray] = impModBPSKrevB(time);
%
%  function [outputArray] = impModBPSKrevB(time);
%
%  Impulse modulated BPSK signal generator ... this is used to test
%  the digital receiver
%
%  time .......... length of the signal in seconds
%  outputArray ... the BPSK signal
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2004
%
%   8 July 2004 - revision 1.0 ... initial implementation
%  12 July 2004 - revision 1.1 ... updated to stand alone support 
%                 for the digital receiver
%  26 July 2004 - revision 1.2 ... updated to create a wav-file
%  27 July 2004 - revision 1.3 ... added a symbol sync pulse to the
%                 wav-file (BPSK ... ch 1, sync ... ch 2)

%  input terms
Fs = 48000;          % sample frequency of the simulation (Hz)
dataRate = 2400;     % data rate
alpha = 0.5;         % raised-cosine rolloff factor
symbols = 5;         % MATLAB ``rcosfir" parameter ... see help
cosine = [1 0 -1 0]; % cos(n*pi/2) ... Fs/4
counter = 1;         % used to get a new data bit
Nbits = 16;          % number of bits per sample in the wav-file
scaleFactor = 0.9;   % scale to the +/- 1.0 limits of the soundcard

%  calculated terms
numberOfSamples = Fs*time;
samplesPerSymbol = Fs/dataRate;
outputArray = zeros(1, numberOfSamples);% stores output signal
syncArray = zeros(1, numberOfSamples);  % stores sync signal

% error checking
    if(mod(samplesPerSymbol,1) ~= 0)
        fprintf('the number of samples per symbol MUST be an integer!\n')
        return;
    end
B = rcosfir(alpha, symbols, samplesPerSymbol, 1/Fs); % design the filter
%B = rcosfir(alpha, symbols, samplesPerSymbol, 1/Fs, 'sqrt'); % design the filter
Zi = zeros(1, (length(B) - 1));
    
%  ISR simulation
for index = 1:numberOfSamples
    % get a new data bit at the beginning of a symbol period
    if (counter == 1)
        data = (2*(rand > 0.5) - 1);
        sync = -1;
    else
        data = 0;
        sync = 1;
    end

    % create the modulated signal
	[impulseModulatedData, Zi] = filter(B, 1, data, Zi);
    carrier = cosine(mod(index,4) + 1);
    output = impulseModulatedData*carrier;

    % reset at the end of a symbol period
    if (counter == samplesPerSymbol)
        counter = 0;
    end
    
    % increment the counter
    counter = counter + 1;
    
    % store the results for plotting (not part of ISR)
    outputArray(index) = output;
    syncArray(index)   = sync;
end

% resample for CD player use
outputArray = resample(outputArray, 147, 160);
%syncArray = resample(syncArray, 147, 160);

% scale the output to the +/- 1.0 limits of the soundcard
outputArray = scaleFactor*outputArray/(max(abs(outputArray)));
%syncArray   = scaleFactor*syncArray/(max(abs(syncArray)));

% create the wav-file
Fs = 44100;
%wavwrite([outputArray' syncArray'], Fs, Nbits, 'raisedCosineBPSKsignal')
wavwrite(outputArray, Fs, Nbits, 'raisedCosineBPSKsignal')
%wavplay([outputArray' syncArray'], Fs)
