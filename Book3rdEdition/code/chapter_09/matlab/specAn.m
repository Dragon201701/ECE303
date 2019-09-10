function specAn(Fs);
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ function specAn(Fs);
%/
%/ DAQ Toolbox spectrum demonstration program
%/
%/ Fs - is the sound card's sample frequency (Hz)
%/
%/ To start the program type "specAn" and push the "enter" key.
%/ A pause will then execute.  To continue, push any key.
%/ To stop the program "left mouse click" in one of the plot area. 
%/
%/ The average value (DC component) of each record is removed
%/ prior to calculating the |fft| of the record.
%//////////////////////////////////////////////////////////////////////

if nargin == 0
    Fs = 8000;  % default sample frequency (in Hz)
end
N = 512;    % number of samples considered by the PSD
window  = hamming(N); % enter your window type here
data = randn(N, 1);   % initialize the data to be plotted

% establishing the DAQ parameters
AI = analoginput('winsound');
set(AI, 'SampleRate', Fs);
chans = addchannel(AI, 1);
set(AI, 'SamplesPerTrigger', N);
set(AI, 'TriggerRepeat', inf);

% setting up for program termination
assignin('base', 'flag', 'run');
action = 'run';

% acquiring the first N samples
start(AI);
   while AI.SamplesAcquired < N
   end

% get and process the input data
data = getdata(AI, N);
[f, mag] = daqfft_undB(window.*(data - mean(data)), Fs, N);

% plot the results
P = plot(f, 20*log10(mag));
set(gca, 'XTickLabelMode', 'manual')
set(gca, 'XTickLabel', [1 Fs/16 2*Fs/16 3*Fs/16 4*Fs/16 5*Fs/16 6*Fs/16 7*Fs/16 8*Fs/16])
set(gca, 'XTickMode', 'manual')
set(gca, 'XTick', [1 Fs/16 2*Fs/16 3*Fs/16 4*Fs/16 5*Fs/16 6*Fs/16 7*Fs/16 8*Fs/16])
title('Real-time PSD')
ylabel('magnitude (dB)')
xlabel('frequency (Hz)')
axis([0 Fs/2 -120 0])
grid on
drawnow;   

set(gcf, 'doublebuffer', 'on')
set(gcf, 'WindowButtonDownFcn', 'flag = [];') % clears flag in WS
set(gcf, 'Name','PSD Estimate')
pause % ... waiting for you to push the "enter" key

% infinite loop for DAQ, processing, and plotting
while (N > 0)
   if strcmp(action, 'run')
      data = peekdata(AI, N);
      [f, mag] = daqfft_undB(window.*(data - mean(data)), Fs, N);
      set(P, 'ydata', 20*log10(mag));
      drawnow;
      action = evalin('base', 'flag'); % reads flag from WS
   else
      break
   end
end

stop(AI)
evalin('base', 'clear flag;'); % clears flag after termination

function [f,mag] = daqfft_undB(data,Fs,blocksize)
% calculates the scaled |FFT|

xFFT=fft(data/sqrt(blocksize));
xfft=abs(xFFT);
ind=find(xfft==0);
xfft(ind)=1e-17;

mag=xfft(1:blocksize/2);
f=(0:length(mag)-1)*Fs/blocksize;
f=f(:);
