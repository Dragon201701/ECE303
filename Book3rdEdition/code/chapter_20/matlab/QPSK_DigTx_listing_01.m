%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2011, 2016
%/
%/ impulse modulated QPSK signal generator
%/
%//////////////////////////////////////////////////////////////////////

%  input terms
Fs = 48000;          % sample frequency of the simulation (Hz)
dataRate = 4800;     % data rate
alpha = 0.35;        % root-raised-cosine rolloff factor
order = 120;         % desired filter order 
time = 1.0;          % length of the signal in seconds
amplitude = 380000;  % amplitude scale factor
cosine = [1 0 -1 0]; % cos(n*pi/2) ... Fs/4
sine =   [0 1 0 -1]; % sin(n*pi/2) ... Fs/4
counter = 1;         % counter used to get new data bits
dataArray = zeros(1, 60); % stored data for plotting
outputArray = [];    % stored output signal for plotting
myFontSize = 16;     % font size for the plot labels
window = 1024;       % number of samples in an FFT analysis window

%  calculated terms
numberOfSamples = Fs*time;
symbolRate = dataRate/2;  % for QPSK there are 2 bits/symbol
samplesPerSymbol = Fs/symbolRate;
    % error checking
    if(mod(samplesPerSymbol,1) ~= 0)
        error('the number of samples per symbol MUST be an integer!\n')
    end

%  design the pulse shaping filter (specify, 'normal' or 'sqrt')
B = firrcos(order, symbolRate/2, alpha, Fs, 'rolloff', 'sqrt');
%  set the filter's initial conditions to zero
I_state = zeros(1, (length(B) - 1));
Q_state = zeros(1, (length(B) - 1));

%  ISR simulation
for index = 1:numberOfSamples
    % generate a new pair of data bits at the 
    % beginning of a symbol period
    if (counter == 1)
        I_data = 2*(rand > 0.5) - 1;  % generate a +1 or -1 (bit)
        Q_data = 2*(rand > 0.5) - 1;  % generate a +1 or -1 (bit)
    else
        I_data = 0;
        Q_data = 0;
    end

    % create the modulated signal
	[I_IM_data, I_state] = filter(B, 1, amplitude*I_data, I_state);
	[Q_IM_data, Q_state] = filter(B, 1, amplitude*Q_data, Q_state);
    output = I_IM_data*cosine(mod(index,4) + 1) ...
           - Q_IM_data*sine(mod(index,4) + 1);

    % reset at the end of a symbol period
    if (counter == samplesPerSymbol)
        counter = 0;
    end
    
    % increment the counter
    counter = counter + 1;
    
    % convert and store the symbols for plotting 
    % this is not part of ISR
    if((I_data == 1) && (Q_data == 1))
        data = 21000;
    elseif((I_data == 1) && (Q_data == -1))
        data = 7000;
    elseif((I_data == -1) && (Q_data == -1))
        data = -7000;
    elseif((I_data == -1) && (Q_data == 1))
        data = -21000;
    else
        data = 0;
    end
    dataArray = [dataArray data];
    outputArray = [outputArray output];
end

%  output terms
% Plotting commands ... see the book CD-Rom for the details
figure(1)
P1a = plot(outputArray/10000, 'b:');
set(P1a, 'LineWidth', 1.5)
hold on
P1b = plot(dataArray/10000, 'r');
set(gca, 'FontSize', myFontSize)
set(P1b, 'LineWidth', 1.5)
axis([0 200 -3 3]);
legend('transmitted waveform', 'symbol values', 'Location', 'SouthWest')
ylabel('signal value (in 10,000)')
xlabel('sample number, n')
hold off
print -deps2 impulseModulatedQPSK

figure(2)
P2 = plot(outputArray/10000);
set(P2, 'LineWidth', 1.5)
set(gca, 'FontSize', myFontSize)
set(P1b, 'LineWidth', 1.5)
%axis([0 200 -3 3]);
ylabel('signal value (in 10,000)')
xlabel('sample number, n')
print -deps2 allImpulseModulatedQPSK

figure(3)
[P, f] = pwelch(outputArray, window, [], [], Fs);
P3 = plot(f/1000, 10*log10(P/max(P)));
set(gca, 'FontSize', myFontSize)
set(P3, 'LineWidth', 1.5)
axis([0 24 -60 10])
set(gca,'XTick', [0 4 8 12 16 20 24])
set(gca,'XTickLabel', [0 4 8 12 16 20 24]')
ylabel('spectral estimate (dB)')
xlabel('frequency (kHz)')
print -deps2 impulseModulatedQPSKspectrum
