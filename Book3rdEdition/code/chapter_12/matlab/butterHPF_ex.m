function butterHPF_ex(Fs,Fc,N)
% demonstrates use of the butter command to design a
% Butterworth (IIR) high pass filter
%
% Syntax: butter_HPF_ex(Fs,Fc,N)
% where Fs is sample freq, Fc is 3 dB cutoff freq, N is order of filter
%
% If no arguments are given, default values are Fs=1000, Fc=2, N=8
% to match Rangayyan text (2nd ed.) Section 3.6.2 
%
% Copyright (c) 2016 Cameron H. G. Wright

% From MATLAB help:
% [B,A] = BUTTER(N,Wn,'high') designs an Nth order highpass digital
%     Butterworth filter and returns the filter coefficients in length 
%     N+1 vectors B (numerator) and A (denominator). The coefficients 
%     are listed in descending powers of z. The cutoff frequency 
%     Wn must be 0.0 < Wn < 1.0, with 1.0 corresponding to 
%     half the sample rate.
%
% See warning about stability in comments in code listing

% Note from chgw: butter command can create unstable filters,
% and won't warn you!  
% The default values here of Fs=1000, Fc=2, N=8 will result 
% in an unstable filter if implemented as Direct Form I or II.
% A stable version can be implemented using SOS.  This 
% can be done using various techniques with butter, or by using 
% fdatool in MATLAB.

% use default parameters if no arguments given
if nargin ~= 3
    Fs=1000; Fc=2; N=8;
    s1=['Three arguments not provided. '];
    s2=['Using default values of Fs=1000, Fc=2, N=8.'];
    disp([s1 s2])
end

% convert Fc to Wc in pi units as required by "butter"
Wc=(Fc/Fs)*2;  % mult by pi is inherent in the definition

% if using default parameters this will yield an *unstable* filter
% see the second method at the end of this m-file using SOS
[b,a]=butter(N,Wc,'high'); % design the filter

% export coefficients to the workspace for future use if desired
% assignin('base','b',b);
% assignin('base','a',a);

% optional: display the coefficients; uncomment as desired
%format long
% b
% a
%format short

% create figures
close all % close all existing figure windows

% Plot filters old-style way
% At end of this code the newer fvtool plots will be used

figure(1)
freqz(b,a,512,Fs) % plot frequency response
title('DF Magnitude shown in logarithmic units')

figure(2)
[H,F]=freqz(b,a,512,Fs); % calculate frequency response
subplot(2,1,1)
plot(F,abs(H))
title('DF Magnitude shown in linear units')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
grid on
subplot(2,1,2)
plot(F,unwrap(angle(H)))
xlabel('Frequency (Hz)')
ylabel('Phase (radians)')
grid on

figure(3)
zplane(b,a) % pole-zero diagram

figure(4)
impz(b,a) % impulse response--unstable filter!

% now design the same filter again but using SOS
[z,p,k] = butter(N,Wc,'high');  % obtain poles, zeros, and gain
[sos,g] = zp2sos(z,p,k);	    % Convert to SOS form
Hd = dfilt.df2tsos(sos,g);      % Create a dfilt object of the SOS filter

% Use fvtool for another way to look at filters!
% using Hd filter object for SOS incorporates the gain factor g
h1 = fvtool(b,a);  % show the filter implemented as DF2
h2 = fvtool(Hd);  % show the redesigned filter as SOS


figure(1) % put Figure 1 on top

return





