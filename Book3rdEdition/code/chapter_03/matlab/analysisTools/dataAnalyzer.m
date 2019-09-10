%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ data geather and analyzer
%/
%//////////////////////////////////////////////////////////////////////

% input section
fs = 96000;     % sample frequency
Nbits = 24;     % number of bits per sample
mono = 1;       % 1 ... mono, 2 ... stereo 
time = 4;       % number of seconds recorded
Nfft = 8192*16; % number of points used in the fft

% calculation section
r = audiorecorder(fs, Nbits, mono);
record(r, time);            % record the data
pause(1.1*time);            % pause while the recording occurs
myData = getaudiodata(r);   % get data as floats

% output section
figure(1)
plot(myData)

figure(2)
psd(myData, Nfft, fs)
axis('tight')
