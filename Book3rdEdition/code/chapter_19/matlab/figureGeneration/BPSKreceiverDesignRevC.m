%  BPSK receiver design/simulation m-file
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%
%  copyright 2002 - 2004, completed on ... 12 July 2004

clear all
tic

% generates the transmitter`s signal
[BPSKsignal, dataArray] = impModBPSK(0.1);  
myFontSize = 16;    % font size for the plot labels

% simulation inputs ... PLL
alphaPLL = 0.010;           % PLL's loop filter parameter "alpha"
betaPLL  = 0.002;           % PLL's loop filter parameter "beta"
N = 20;                     % samples per symbol
Fs = 48000;                 % simulation sample frequency
phaseAccumPLL = randn(1);   % current phase accumulator's value
VCOphaseError = 2*pi*rand(1); % selecting a random phase error
VCOrestFrequencyError = randn(1); % error in the VCO's rest freq
Fcarrier = 12000;           % carrier freq of the transmitter
phi = VCOphaseError;        % initializing the VCO's phase

% simulation inputs ... ML timing recovery
alphaML = 0.0040;   % ML loop filter parameter "alpha"
betaML  = 0.0002;   % ML loop filter parameter "beta"
alpha = 0.5;        % root raised-cosine rolloff factor
symbols = 3;        % MATLAB "rcosfir" parameter

phaseAccumML = 2*pi*rand(1);% initializing the ML NCO
symbolsPerSecond = 2401;    % baud (symbol rate) w/ an offset from 2400

% initialization
Zi_pll = 0;                 % initializing the PLL's loop filter
Zi_ML_loop = 0;             % initializing the ML loop filter
Zi_MF = zeros(1,120);       % initializing the matched filter
Zi_diff = [0 0];            % initializing the differentiator
decision = 0;               % initializing the decision variable
delayedMFoutput = 0;        % initializing the delayed MF variable

delayedMFoutputSummary = [];        % plotting variables
decisionSummary = [];               % plotting variables
decisionSummaryHoldOn = [];         % plotting variables
errorSummary = [];                  % plotting variables
loopFilterOutputPLLSummary = [];    % plotting variables

% calculated terms ... PLL
T = 1/Fs;                           % sample period
B_PLL = [(alphaPLL + betaPLL) -alphaPLL]; % loop filter combined numerator
A_PLL = [1 -1];                     % loop filter combined denominator
vcoOutput = exp(-j*VCOphaseError);  % initializing the VCO's output
Fcarrier = Fcarrier + VCOrestFrequencyError; % VCO's rest frequency

% calculations on the incoming signal ... ISR prep
BPSKsignal = BPSKsignal/32768;      % scale prior to the algorithms
analyticSignal = hilbert(BPSKsignal); % take the Hilbert transform

% calculated terms ... ML timing recovery
phaseIncML = 2*pi/N;                % phase increment of the ML NCO
B_MF = rcosfir(alpha, symbols, N, 1/Fs); % design the matched filter
B_ML = [(alphaML + betaML) -alphaML]; % ML loop filter combined numerator
A_ML = [1 -1];                      % ML loop filter combined denominator

%  commencing ISR simulation
for i = 1:length(BPSKsignal)
    %  processing the data by the PLL
    phaseDetectorOutput = analyticSignal(i)*vcoOutput;
    m = 6*real(phaseDetectorOutput);    % scale for a max value
    q = real(phaseDetectorOutput)*imag(phaseDetectorOutput);
    [loopFilterOutputPLL, Zi_pll] = filter(B_PLL, A_PLL, q, Zi_pll);
    loopFilterOutputPLLSummary = ...
        [loopFilterOutputPLLSummary loopFilterOutputPLL];  % plot
    phi = mod(phi + loopFilterOutputPLL + 2*pi*Fcarrier*T, 2*pi);
    vcoOutput = exp(-j*phi);
    
    %  processing the data by the ML-based receiver
    [MFoutput, Zi_MF] = filter(B_MF, 1, m, Zi_MF);
    [diffMFoutput, Zi_diff] = filter([1 0 -1], 1, MFoutput, Zi_diff);

    phaseAccumML = phaseAccumML + phaseIncML;
    if phaseAccumML >= 2*pi
        phaseAccumML = phaseAccumML - 2*pi;
        decision = sign(delayedMFoutput);
        [error, Zi_ML_loop] = filter(B_ML, A_ML, ...
            decision*diffMFoutput, Zi_ML_loop);
        phaseAccumML = phaseAccumML - error;
        errorSummary = [errorSummary error];            % plot
        decisionSummary = [decisionSummary decision];   % plot
    else
        errorSummary = [errorSummary 0];                % plot
    end

    delayedMFoutput = MFoutput; % accounts for group delay

    % state storage for plotting ... not part of the ISR
    delayedMFoutputSummary = ...
        [delayedMFoutputSummary delayedMFoutput];
    decisionSummaryHoldOn = [decisionSummaryHoldOn decision];
end     

toc

%  output terms
%  Plot commands follow ...

figure(1)
subplot(4,1,1)
P1 = plot(loopFilterOutputPLLSummary);
set(gca, 'FontSize', myFontSize)
set(P1, 'LineWidth', 1.5)
axis([0 3000 -0.04 0.04])
ylabel('PLL error')
%xlabel('sample number, n')
%print -deps2 loopFilterOutput

subplot(4,1,2)
P2 = plot(errorSummary);
set(gca, 'FontSize', myFontSize)
set(P2, 'LineWidth', 1.5)
axis([0 3000 -0.1 0.1])
ylabel('timing error')
%xlabel('sample number, n')
%print -deps2 loopFilterOutput

subplot(4,1,3)
P3a = plot(delayedMFoutputSummary/100, 'b:');
set(gca, 'FontSize', myFontSize)
set(P3a, 'LineWidth', 1.5)
hold on
P3b = plot(decisionSummaryHoldOn, 'r');
set(P3b, 'LineWidth', 1.5)
axis([2000 3000 -1.3 1.3])
legend('MF''s output', 'receiver''s decision', 'Location', 'EastOutside')
ylabel('output')
%xlabel('sample number, n')
hold off
%print -deps2 receiverPerformancePart1

subplot(4,1,4)
P4a = plot([zeros(1,5) dataArray(1:20:end)/20000], 'b:');
set(gca, 'FontSize', myFontSize)
set(P4a, 'LineWidth', 1.5)
hold on
P4b = plot(decisionSummary(1:end),'r*');
set(P4b, 'LineWidth', 1.5)
axis([100 150 -1.3 1.3])
legend('message data', 'receiver''s decision', 'Location', 'EastOutside')
ylabel('output')
xlabel('sample number, n')
hold off
%print -deps2 receiverPerformance
