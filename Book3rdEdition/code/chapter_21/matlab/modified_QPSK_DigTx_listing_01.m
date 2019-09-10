%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2011, 2016
%/
%/ impulse modulated QPSK signal generator
%/
%//////////////////////////////////////////////////////////////////////

clear;
%  input terms
Fs = 48000;          % sample frequency of the simulation (Hz)
dataRate = 4800;     % data rate
alpha = 0.35;        % root-raised-cosine rolloff factor
order = 120;         % desired filter order 
time = 2.0;          % length of the signal in seconds
amplitude = 380000;  % amplitude scale factor
cosine = [1 0 -1 0]; % cos(n*pi/2) ... Fs/4
sine =   [0 1 0 -1]; % sin(n*pi/2) ... Fs/4
counter = 1;         % counter used to get new data bits
outputArray = [];    % stored output signal for plotting

% to rotate the constellation
rotation = pi/6;
cr = cos(rotation);
sr = sin(rotation);

%  calculated terms
numberOfSamples = Fs*time;
symbolRate = dataRate/2;  % for QPSK there are 2 bits/symbol
samplesPerSymbol = Fs/symbolRate;

% error checking
if(mod(samplesPerSymbol,1) ~= 0)
    error('the number of samples per symbol MUST be an integer!\n')
end

%  design the pulse shaping filter
B = firrcos(order, symbolRate/2, alpha, Fs, 'rolloff', 'sqrt');

%  set the filter's initial conditions to zero
I_state = zeros(1, (length(B) - 1));
Q_state = zeros(1, (length(B) - 1));

%  ISR simulation
for index = 1:numberOfSamples
    % generate a new pair of data bits at the beginning of a symbol period
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

    output = (I_IM_data*cr - Q_IM_data*sr)*cosine(mod(index,4) + 1) ...
           - (Q_IM_data*cr + I_IM_data*sr)*sine(mod(index,4) + 1);
       
    % reset at the end of a symbol period
    if (counter == samplesPerSymbol)
        counter = 0;
    end
    
    % increment the counter
    counter = counter + 1;
    
    % update the output array (for storage for the receiver)
    outputArray = [outputArray output];
end
