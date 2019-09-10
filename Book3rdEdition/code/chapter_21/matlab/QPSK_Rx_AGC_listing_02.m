%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2012
%/
%/ a significant portion of a square-root raised-cosine QPSK receiver ...
%/
%/    free-running 12 kHz I & Q mixers
%/    I & Q matched filters
%/    automatic gain control (AGC)
%/    plots to allow for AGC transient response analysis
%//////////////////////////////////////////////////////////////////////

% save the original values from the transmitter simulation
% this allows for repeated execution of this m-file
temp = outputArray;
myFontSize = 16;     % font size for the plot labels

% apply an additional scale factor to test the AGC
outputArray = 0.1*outputArray;   % 0.1 ... attenuation

% initialize the matched filters
ZiI = zeros(1,120);
ZiQ = zeros(1,120);

% preallocate the storage arrays
scaledI = zeros(1,numberOfSamples);
scaledQ = zeros(1,numberOfSamples);
I_mixer_output = zeros(1,numberOfSamples);
Q_mixer_output = zeros(1,numberOfSamples);

reference = 18000; % reference value (AGC's goal)
AGCgain = 1.0; % initial AGC gain
alpha = 0.005/reference; % AGC loop gain

% ISR simulation ... storage is for plotting purposes
for index = 1:numberOfSamples
    % multiplication by the free running oscillators
    I_mixer_output(index) = ...
        outputArray(index)*cosine(mod(index,4)+1);
    Q_mixer_output(index) = ...
        outputArray(index)*sine(mod(index,4)+1);
    
    % matched filters
    [I(index), ZiI] = filter(B, 1, I_mixer_output(index), ZiI);
    [Q(index), ZiQ] = filter(B, 1, Q_mixer_output(index), ZiQ);
    
    % apply the AGC gain
    scaledI(index) = AGCgain*I(index);
    scaledQ(index) = AGCgain*Q(index);
    
    % calculate the new AGC gain
    magnitude = sqrt(scaledI(index)*scaledI(index) + ...
        scaledQ(index)*scaledQ(index));
    error = reference - magnitude;
    scaledError = alpha*error;
    AGCgain = AGCgain + scaledError;
end

% output terms
figure(1)
P1 = plot((I + j*Q)/1000);
set(gca, 'FontSize', myFontSize)
ylabel('Q signal value, in 1000''s')
xlabel('I signal value, in 1000''s')
axis([-2.5 2.5 -2.5 2.5])
axis square
print -deps2 constellationDiagramPriorToAGC

figure(2)
P2 = plot(1000*(1:length(I))/Fs, abs(I + j*Q)/1000);
set(P2, 'LineWidth', 1.5)
set(gca, 'FontSize', myFontSize)
ylabel('signal''s magnitude, in 1000''s')
xlabel('time, in ms')
axis([0 20 0 2.4])
print -deps2 signalMagnitudePriorToAGC

figure(3)
P3 = plot((scaledI + j*scaledQ)/1000);
set(gca, 'FontSize', myFontSize)
ylabel('Q signal value, in 1000''s')
xlabel('I signal value, in 1000''s')
hold on
plot([-32.767 32.767], [32.767 32.767], 'r')
plot([-32.767 32.767], [-32.767 -32.767], 'r')
plot([-32.767 -32.767], [-32.767 32.767], 'r')
plot([32.767 32.767], [-32.767 32.767], 'r')
axis square
hold off
print -deps2 constellationDiagramAfterAGC

figure(4)
P4 = plot(1000*(1:length(I))/Fs, abs(scaledI + j*scaledQ)/1000);
set(P4, 'LineWidth', 1.5)
set(gca, 'FontSize', myFontSize)
ylabel('signal''s magnitude, in 1,000''s')
xlabel('time, in ms')
axis([0 500 0 35])
print -deps2 signalMagnitudeAfterAGC

% restore the saved values ... this allows for repeated execution
outputArray = temp;
