function ecg_noise_baseline_demo2()
% Direct form vs. SOS IIR filters
% Loads an ECG signal sampled at 1000 Hz, containing broadband noise
% moderately corrupting the signal and a severe baseline drift.
% Applies a simple 8-pt MA filter to mitigate the higher freq
% broadband noise.  Then runs some Butterworth HPF variants to 
% eliminate the very low frequency baseline drift. 
% The DF-II filter version is unstable but the SOS version
% of the same filter is stable. Traditional application of the SOS
% filter causes too much waveform distortion due to nonlinear phase of 
% the fitler. So filtfilt and FD filtering are demonstrated,
% each of which impose no phase effects but would need to be
% implemented as frame-based processing. Finally, a very simple 
% first-order IIR HPF is used that seems to work fairly well,
% although some waveform distortion is noticable.
%
% Copyright (c) 2016 Cameron H. G. Wright

% show students butterHPF_ex.m before this 

clear all;
close all;

ecg=load('ecg_lfn_Fs1k.txt');  % load the data file
Fs=1000;  % the given sample frequency
N=length(ecg); % find the number of samples
n=0:N-1; % create a vector n for the sample numbers (for plotting)
t=n/Fs;  % time axis for plotting ECG data
tmax=max(t);

% reduce overall noise with simple 8-point moving average filter
% linear phase FIR 
a=1;  % the a coefficients
b=ones(1,8)/8;
y=filter(b,a,ecg); % filter the signal

% Still need to reduce the baseline drift with a HPF
% Design an 8th-order Butterworth HPF with -3 dB cutoff at 2 Hz

Order=8;
Fc=2; 
% convert Fc to Wc in pi units as required by "butter"
Wc=(Fc/Fs)*2;  % mult by pi is inherent in the definition

% the DF-II solution below will yield an *unstable* filter
% see the second method using SOS for a stable version
[b2,a2]=butter(Order,Wc,'high'); % design the filter

% now design the same filter again but using SOS
[z,p,k] = butter(Order,Wc,'high');  % obtain poles, zeros, and gain
[sos,g] = zp2sos(z,p,k);	    % Convert to SOS form
Hd = dfilt.df2tsos(sos,g);      % Create a dfilt object of SOS filter
% Note sosfilt command cannot directly use gain g
% Filter object Hd can be used with filter command so that gain g 
%   is then incorporated into the filtering


% Try three variants

% using an unstable filter--very bad results
y2=filter(b2,a,y); 

% using the stable SOS implementation
% note y3=sosfilt(sos,y) would not use the gain factor g
% too much waveform distortion due to nonlinear phase of filter
y3=filter(Hd,y); 

% using the stable SOS implementation, but filtfilt cancels phase effects
% filtfilt also squares magnitude response, so not quite right
% only way to use filtfilt in real-time is frame-based processing
y3b=filtfilt(sos,g,y); 

% using the stable SOS implementation, but with a frequency domain 
% approach that also results in no phase effects
% only way to use FD filtering in real-time is frame-based processing
[H,F]=freqz(sos,N,Fs,'whole'); % frequency response 0 to Fs, at N points
H=g*abs(H); % mag of freq response scaled by gain factor
Hzp=[H zeros(N,1)]; % zeropad H for FD fitlering
Y=fft(y); % FD version of ECG signal, N points long
Yzp=[Y zeros(N,1)]; % zeropad Y for FD filtering
Y3c=Yzp.*Hzp;  % apply the filter in the FD
y3c=ifft(Y3c); % take back to time domain
y3c=real(y3c(1:N)); % strip off the zeros the trivial imaginary parts

% A different HPF, very simple 1st-order IIR
% less phase distortion than the 8th-order Butterworth
a4=[1 -0.995];
b4=[1 -1];
y4=filter(b4,a4,y); % this actually works pretty well, some distortion 

% create the figures
close all
 set(0,'DefaultAxesFontSize',16); % use larger font
 set(0,'DefaultTextFontSize',16);
 set(0,'DefaultLineLineWidth',1.5) % use thicker line


figure(1)  % plot in sample (time) domain
plot(t,ecg)  
title('Unfiltered ECG Signal')
xlabel('time in seconds')
ylabel('ECG (mV)')
axis([0 tmax -2.5 3.5])

figure(2)
plot(t,y)  % LP (moving average) filtered ecg signal
title('LP Filtered ECG Signal')
xlabel('time in seconds')
ylabel('ECG (mV)')
axis([0 tmax -2.5 3.5])

figure(3)
plot(t,y2)  % filtered ecg signal
title('Filtered ECG Signal using DF-II HPF')
xlabel('time in seconds')
ylabel('ECG (mV)')
axis([0 tmax -2.5 3.5])

figure(4)
plot(t,y3)  % filtered ecg signal
title('Filtered ECG Signal using SOS HPF')
xlabel('time in seconds')
ylabel('ECG (mV)')
axis([0 tmax -2.5 3.5])

figure(5)
plot(t,y3b)  % filtered ecg signal
title('FiltFilt ECG Signal using SOS HPF')
xlabel('time in seconds')
ylabel('ECG (mV)')
axis([0 tmax -2.5 3.5])

figure(6)
plot(t,y3c)  % filtered ecg signal
title('FD Filtered ECG Signal using SOS HPF')
xlabel('time in seconds')
ylabel('ECG (mV)')
axis([0 tmax -2.5 3.5])

figure(7)
plot(t,y4)  % filtered ecg signal
title('Filtered ECG Signal using 1st-order IIR HPF')
xlabel('time in seconds')
ylabel('ECG (mV)')
axis([0 tmax -2.5 3.5])


%%%%%%%%%%%%%%%
% uncomment to load all filters into fvtool for comparison
% using Hd filter object incorporates the gain factor g for SOS
% whereas sending sos to fvtool would not incorporate gain factor g
% h1 = fvtool(b,a);  % show the LP filter 
% h2 = fvtool(b2,a2);  % show the HP filter implemented as DF2
% h3 = fvtool(Hd);  % show the redesigned filter as SOS
% h4 = fvtool(b4,a4);  % show the 1st-order IIR HPF


% this is how you'd save figure 3 as an EPS file, if you want
% print -f3 -depsc2 myfig

%%%%%%%%% reset default figure properties %%%%%%
set(0,'DefaultAxesFontSize','remove'); 
set(0,'DefaultTextFontSize','remove');
set(0,'DefaultLineLineWidth','remove') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure(1)

return
