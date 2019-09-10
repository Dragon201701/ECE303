%  AM/DSB w/carrier - Hilbert transformer based receiver
%
%  Demonstration program for M1/C Steve VanCott
%
%  by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%
%  (c) copyright 2001
%  written 4 February 2001, 7 February
%  last revision 10 February 2001

% variable declaration
Fs = 48000;         % sample frequency
Ac = 1.0;           % amplitude of the carrier
fc = 12000;         % frequency of the carrier
Amsg = 0.5;         % amplitude of the message
fmsg = 700;         % frequency of the message
HilbertOrder = 62;  % Hilbert transforming filter order (must be even)
c = 0.990;          % highpass filter pole magnitude, between 0 and 1 (close to 1)
duration = 0.5;	    % signal duration in seconds

B = remez(HilbertOrder, [0.05 0.95], [1 1], 'h');	% design the FIR Hilbert transformer filter
t = 0:1/Fs:duration;

% generate the AM/DSB w/carrier signal
carrier = Ac*cos(2*pi*fc*t);
msg = Amsg*cos(2*pi*fmsg*t);
AM = (1 + msg).*carrier;

% recover the message ... note the HilbertOrder/2 delay to align the signals
AMhilbert = filter(B, 1, AM);
OffsetOutput = sqrt((AM(1:2000)).^2 + (AMhilbert((HilbertOrder/2 + 1):(2000 + HilbertOrder/2))).^2);
demodOutput = filter([1 -1]*(1 + c)/2, [1 -c], OffsetOutput);

% create the desired figures
figure(1)
plot((0:999)/Fs, AM(1:1000))
title('AM/DSB w/ Carrier Waveform')
xlabel('time (s)')
ylabel('amplitude')

figure(2)
psd(AM, length(AM), Fs)
title('AM/DSB w/Carrier Power Spectral Density Estimate')

figure(3)
stem(B)
title('62^{nd} Order Hilbert Transformer FIR Filter Coefficients')
xlabel('n')
ylabel('amplitude')

figure(4)
plot((0:(length(demodOutput)-1))/Fs, demodOutput)
hold on
plot((0:(length(demodOutput)-1))/Fs, msg(1:length(demodOutput)), 'r')
title('Recovered and the Original Message')
xlabel('time (s)')
ylabel('amplitude')
legend('recovered message', 'original message')
hold off

figure(5)
plot(t(1400:1650), demodOutput(1400:1650))
hold on
plot(t(1400:1650), msg(1400:1650),'r')
title('Recovered and the Original Message')
xlabel('time (s)')
ylabel('amplitude')
legend('recovered message', 'original message', 3)
axis([0.03 0.0325 -0.6 0.6])
hold off

figure(6)
grpdelay([1 -1]*(1 + c)/2, [1 -c], 1024, Fs)

figure(7)
impz([1 -1]*(1 + c)/2, [1 -c])
