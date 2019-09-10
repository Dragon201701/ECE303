%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005, 2016
%/
%/ rectangular shaped BPSK signal generator
%/
%//////////////////////////////////////////////////////////////////////

%  input terms
Fs = 48000;          % sample frequency of the simulation (Hz)
dataRate = 2400;     % data rate
time = 0.004;        % length of the signal in seconds
amplitude = 30000;   % scale factor
cosine = [1 0 -1 0]; % cos(n*pi/2) ... Fs/4
counter = 1;         % used to get a new data bit
dataArray = [];      % stores data for plotting
outputArray = [];    % stores output signal for plotting
myFontSize = 16;                        % font size for the plot labels

%  calculated terms
numberOfSamples = Fs*time;
samplesPerSymbol = Fs/dataRate;

% error checking
if(mod(samplesPerSymbol,1) ~= 0)
    error('the number of samples per symbol MUST be an integer!\n')
end

%  ISR simulation
for index = 1:numberOfSamples
    % get a new data bit at the beginning of a symbol period
    if (counter == 1)
        data = amplitude*(2*(rand > 0.5) - 1);
    end

    % create the modulated signal
    output = data*cosine(mod(index,4) + 1);

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

%  output terms
figure(1)
P1a = plot(outputArray/10000, 'b:');
%set(gca, 'FontSize', myFontSize)
set(P1a, 'LineWidth', 1.5)
hold on
P1b = plot(dataArray/10000,'r');
set(gca, 'FontSize', myFontSize)
set(P1b, 'LineWidth', 1.5)
axis([0 numberOfSamples -1.2*amplitude/10000 1.2*amplitude/10000]);
legend('BPSK signal', 'message')
ylabel('signal value (in 10,000)')
xlabel('sample number, n')
hold off
% print -deps2 rectangularBPSK

