%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2012
%/
%/ a complete square-root raised-cosine QPSK receiver, to include ...
%/
%/    free-running 12 kHz I & Q mixers
%/    I & Q matched filters
%/    automatic gain control (AGC)
%/    plots to allow for AGC transient analysis
%/    constellation de-rotation
%/    plots to allow for de-rotation transient analysis
%     symbol timing recovery
%     plots to allow for symbol timing transient analysis
%//////////////////////////////////////////////////////////////////////

% save the original values from the transmitter simulation
% this allows for repeated execution of this m-file
temp = outputArray;

% apply an additional scale factor to test the AGC
outputArray = 0.4*outputArray;   % 0.4 ... attenuation

% initialize the matched filters
ZiI = zeros(1,120);
ZiQ = zeros(1,120);

% preallocate the storage arrays
Iscaled = zeros(1,numberOfSamples);
Qscaled = zeros(1,numberOfSamples);
I_mixer_output = zeros(1,numberOfSamples);
Q_mixer_output = zeros(1,numberOfSamples);
IsampledPlot = [];
QsampledPlot = [];
phaseAdjPlot = [];
phasePlot = [];
thetaPlot = [];

% AGC variables
reference = 18000; % reference value (AGC's goal)
AGCgain = 1.0; % initial AGC gain
alpha = 0.001/reference; % AGC loop gain

% symbol timing recovery variables
phase = pi/6;  % symbol timing recovery loop's phase
phaseInc = 2*pi/samplesPerSymbol; % phase increment for the NCO
phaseGain = 0.2e-6; % symbol timing loop gain
Ziphase = zeros(1,13); % initial conditions for the MA filter

% constellation de-rotation variables
thetaGain = 1.0e-7; % the gain that controls the de-rotation loop
st = 1;
ct = 1;
phaseAdj = 0;
theta = 0;

% ISR simulation ... storage is for plotting purposes
for index = 1:numberOfSamples
    % multiplication by the free running oscillators
    I_mixer_output(index) = ...
        outputArray(index)*cosine(mod(index,4)+1);
    Q_mixer_output(index) = ...
        outputArray(index)*sine(mod(index,4)+1);
    
    % matched filters
    [I_mf(index), ZiI]=filter(B, 1, I_mixer_output(index), ZiI);
    [Q_mf(index), ZiQ]=filter(B, 1, Q_mixer_output(index), ZiQ);
    
    % apply the AGC gain
    Iscaled(index) = AGCgain*I_mf(index);
    Qscaled(index) = AGCgain*Q_mf(index);
    
    % calculate the new AGC gain
    magnitude = sqrt(Iscaled(index)*Iscaled(index) + ...
        Qscaled(index)*Qscaled(index));
    error = reference - magnitude;
    scaledError = alpha*error;
    AGCgain = AGCgain + scaledError;
    
    phase = phase + phaseInc;
    
    % timing recovery loop
    if(phase >= 2*pi)
        phase = phase - 2*pi;

        % derotation and sampling
        st = sin(theta);
        ct = cos(theta);
        Isampled = Iscaled(index)*ct - Qscaled(index)*st;
        Qsampled = Qscaled(index)*ct + Iscaled(index)*st;
        IsampledPlot = [IsampledPlot Isampled];
        QsampledPlot = [QsampledPlot Qsampled];        
        
        % slicer ... bit decisions
        if(Isampled > 0)
            di = 1;
        else
            di = -1;
        end
        if(Qsampled > 0)
            dq = 1;
        else
            dq = -1;
        end

        % derotation adjustment ... calculate the new theta
        thetaAdj = (di*Qsampled - dq*Isampled)*thetaGain;
        theta = theta - thetaAdj;
        if(theta > 2*pi)
            theta = theta - 2*pi;
        end        
        
        % timing adjustment
        symTimingAdj = di*(Iscaled(index)-Iscaled(index-2)) + ...
            dq*(Qscaled(index)-Qscaled(index-2));
        % 13th order MA filter
        [phaseAdj, Ziphase]=filter(phaseGain*ones(1,14)/14,1, ...
            symTimingAdj, Ziphase);
        phase = phase - phaseAdj;
    end
    
    % de-rotation
    I(index) = Iscaled(index)*ct - Qscaled(index)*st;
    Q(index) = Qscaled(index)*ct + Iscaled(index)*st;
    phaseAdjPlot = [phaseAdjPlot phaseAdj];
    phasePlot = [phasePlot phase];
    thetaPlot = [thetaPlot theta];
end

% output terms
myFontSize = 16;     % font size for the plot labels

figure(1)   % output of matched filters (I&Q)
subplot(2,1,1)
plot(I_mf + j*Q_mf)
axis square
subplot(2,1,2)
plot(abs(I_mf + j*Q_mf))

figure(2)   % output of AGC (I&Q)
subplot(2,1,1)
plot(Iscaled + j*Qscaled)
hold on
plot([-32767 32767], [32767 32767], 'r')
plot([-32767 32767], [-32767 -32767], 'r')
plot([-32767 -32767], [-32767 32767], 'r')
plot([32767 32767], [-32767 32767], 'r')
axis square
axis([-35000 35000 -35000 35000])
hold off
subplot(2,1,2)
plot(abs(Iscaled + j*Qscaled))

figure(3)   % de-rotated I&Q
plot(I + j*Q)
axis square
axis([-35000 35000 -35000 35000])

figure(4)   % phase trajectory sample points
P4 = plot((IsampledPlot + j*QsampledPlot)/1000, 'b.');
set(gca, 'FontSize', myFontSize)
ylabel('Q signal value, in 1000''s')
xlabel('I signal value, in 1000''s')
hold on
plot((IsampledPlot(4400:end) + j*QsampledPlot(4400:end))/1000, 'w.')
axis square
axis([-25 25 -25 25])
hold off
print -depsc2 QPSKconstellationDiagram

figure(5)   % symbol timing adjustments
plot(phaseAdjPlot)
title('symbol timing adjustments')

figure(6)   % de-rotation (theta) adjustment
plot(thetaPlot)
title('theta adjustments')

% restore the saved values ... this allows for repeated execution
outputArray = temp;
