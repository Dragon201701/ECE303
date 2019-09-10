function [outputArray, dataArray] = impModBPSK(time);
%
%  function [outputArray, data] = impModBPSK(time);
%
%  Impulse modulated BPSK signal generator ... this is used to test
%  the digital receiver
%
%  time .......... length of the signal in seconds
%  outputArray ... the BPSK signal
%  dataArray ..... the data used to excited the modulator
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2004, 2016
%
%   8 July 2004 - revision 1.0 ... initial implementation
%  12 July 2004 - revision 1.1 ... updated to stand alone support 
%                 for the digital receiver
%  28 May 2016  - revision 1.2 ... removed the "break" command

%  input terms
Fs = 48000;          % sample frequency of the simulation (Hz)
dataRate = 2400;     % data rate
alpha = 0.5;         % raised-cosine rolloff factor
symbols = 3;         % MATLAB ``rcosfir" parameter ... see help
amplitude = 20000;   % scale factor
cosine = [1 0 -1 0]; % cos(n*pi/2) ... Fs/4
counter = 1;         % used to get a new data bit
dataArray = [];      % stores data for plotting
outputArray = [];    % stores output signal for plotting

%  calculated terms
numberOfSamples = Fs*time;
samplesPerSymbol = Fs/dataRate;
    % error checking
    if(mod(samplesPerSymbol,1) ~= 0)
        error('the number of samples per symbol MUST be an integer!\n')
    end
B = rcosfir(alpha, symbols, samplesPerSymbol, 1/Fs); % design the filter
Zi = zeros(1, (length(B) - 1));
    
%  ISR simulation
for index = 1:numberOfSamples
    % get a new data bit at the beginning of a symbol period
    if (counter == 1)
        data = amplitude*(2*(rand > 0.5) - 1);
    else
        data = 0;
    end

    % create the modulated signal
	[impulseModulatedData, Zi] = filter(B, 1, data, Zi);
    output = impulseModulatedData*cosine(mod(index,4) + 1);

    % reset at the end of a symbol period
    if (counter == samplesPerSymbol)
        counter = 0;
    end
    
    % increment the counter
    counter = counter + 1;
    
    % store the results for plotting (not part of ISR)
    dataArray = [dataArray data];
    outputArray = [outputArray output];
end

