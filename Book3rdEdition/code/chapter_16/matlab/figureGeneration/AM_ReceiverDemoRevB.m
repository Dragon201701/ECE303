%  Hilbert-based AM receiver simulation
%
%  by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%
%  (c) copyright 2001
%  written 4 February 2001, 7 February
%  last revision 10 February 2001

% variable declarations
Fs = 48000;         % sample frequency
Ac = 1.0;           % amplitude of the carrier
fc = 12000;         % frequency of the carrier
Amsg = 0.5;         % amplitude of the message
fmsg = 700;         % frequency of the message
HilbertOrder = 62;  % Hilbert transforming filter order
c = 0.990;          % highpass filter pole magnitude
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
AMhilbert = filter(B, 1, AM);
OffsetOutput = sqrt((AM(1:2000)).^2 + ...
    (AMhilbert((HilbertOrder/2 + 1):(2000 + ...
    HilbertOrder/2))).^2);
demodOutput = filter([1 -1]*(1 + c)/2, [1 -c], OffsetOutput);

% create the desired figures
figure(1)
plot((0:(length(demodOutput)-1))/Fs*1000, demodOutput)
set(gca, 'FontSize', myFontSize)
hold on
plot((0:(length(demodOutput)-1))/Fs*1000, ...
    msg(1:length(demodOutput)), 'r--')
xlabel('time (ms)')
ylabel('amplitude')
legend('recovered message', 'original message')
axis([0 10 -0.5 2.0])
hold off