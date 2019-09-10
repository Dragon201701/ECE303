%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/  Hilbert-based AM receiver simulation
%/
%//////////////////////////////////////////////////////////////////////

% variable declarations
Fs = 48000;         % sample frequency
Ac = 1.0;           % amplitude of the carrier
fc = 12000;         % frequency of the carrier
Amsg = 0.5;         % amplitude of the message
fmsg = 700;         % frequency of the message
HilbertOrder = 62;  % Hilbert transforming filter order
r = 0.990;          % highpass filter pole magnitude
duration = 0.5;	    % signal duration in seconds
myFontSize = 16;    % font size for the plot labels

% design the FIR Hilbert transforming filter
B = remez(HilbertOrder, [0.05 0.95], [1 1], 'h');	
t = 0:1/Fs:duration;

% generate the AM/DSB w/carrier signal
carrier = Ac*cos(2*pi*fc*t);
msg = Amsg*cos(2*pi*fmsg*t);
AM = (1 + msg).*carrier;

% recover the message
% note the HilbertOrder/2 delay to align the signals
% use the MATLAB syntax of "..." to continue a line of code

% apply the Hilbert transform
AMhilbert = filter(B, 1, AM);

% get envelope, but account for filter delay
OffsetOutput = sqrt((AM(1:2000)).^2 + ...
    (AMhilbert((HilbertOrder/2 + 1):(2000 + HilbertOrder/2))).^2);

% remove DC component
demodOutput = filter([1 -1]*(1 + r)/2, [1 -r], OffsetOutput);

% create the desired figures
plot((0:(length(demodOutput)-1))/Fs*1000, demodOutput)
set(gca, 'FontSize', myFontSize)
hold on
plot((0:(length(demodOutput)-1))/Fs*1000, ...
    msg(1:length(demodOutput)), 'r--')
ylabel('amplitude')
xlabel('time (ms)')
legend('recovered message', 'original message')
axis([0 10 -0.5 2.0])
hold off