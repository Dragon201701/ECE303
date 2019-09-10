%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ DAQ Toolbox spectrum/spectrogram evaluation program
%/
%/ To start the program type "daqdemo" and push the "enter" key.
%/ A pause will then execute.  To continue, push any key.
%/ To stop the program "left mouse click" in one of the subplot areas. 
%/
%/ The average value (DC component) of each record is removed
%/ prior to calculating the |fft| of the record.
%/
%//////////////////////////////////////////////////////////////////////

Fs = 8000;         % sample frequency (in Hz)
preview = 512;     % number of samples considered by the ...
                   % "real-time" PSD estimate (in samples)
depth = 10;        % averaging depth

window  = hamming(preview); 
data = randn(preview, 1);
screen_buffer = -90*ones(preview/2, preview/2);

AI = analoginput('winsound');
set(AI, 'SampleRate', Fs);
chans = addchannel(AI, 1);
set(AI, 'SamplesPerTrigger', preview);
set(AI, 'TriggerRepeat', inf);
action = 'run';

start(AI);
   while AI.SamplesAcquired < preview
   end

%subplot(3,1,3)
SUBPLOT('position', [.1 .05 .8 .3])
H1 = imagesc(screen_buffer);
set(gca,'XTickLabelMode', 'manual')
set(gca,'XTickLabel', [0 Fs/8 Fs*2/8 Fs*3/8 Fs*4/8])
set(gca,'XTickMode', 'manual')
set(gca,'XTick', [1 preview/8 preview/4 3*preview/8 preview/2])
title('Waterfalling Spectrogram')
ylabel('time (2x samples)')
xlabel('frequency (Hz)')

data = getdata(AI, preview);
[f, mag] = daqfft_undB(window.*(data - mean(data)), Fs, preview);
data_buffer = (mag*ones(1, depth))';

%subplot(3,1,1)
SUBPLOT('position', [.1 .70 .8 .25])
P = plot(f, 20*log10(mag));
set(gca, 'XTickLabelMode', 'manual')
set(gca, 'XTickLabel', [])
set(gca, 'XTickMode', 'manual')
set(gca, 'XTick', [1 Fs/16 2*Fs/16 3*Fs/16 4*Fs/16 5*Fs/16 6*Fs/16 7*Fs/16 8*Fs/16])
title('Real-time PSD')
ylabel('magnitude (dB)')
axis([0 Fs/2 -100 20])
grid on
drawnow;   

%subplot(3,1,2)
SUBPLOT('position', [.1 .40 .8 .25])
sum_data = sum(data_buffer);
Q = plot(f, 20*log10(sum_data/depth));
set(gca, 'XTickLabelMode', 'manual')
set(gca, 'XTickLabel', [])
set(gca, 'XTickMode', 'manual')
set(gca, 'XTick', [1 Fs/16 2*Fs/16 3*Fs/16 4*Fs/16 5*Fs/16 6*Fs/16 7*Fs/16 8*Fs/16])
title('Average PSD')
ylabel('magnitude (dB)')
axis([0 Fs/2 -100 20])
grid on
drawnow;   

set(gcf, 'doublebuffer', 'on')
set(gcf, 'WindowButtonDownFcn', 'action = [];')
set(gcf, 'Name','PSD Estimate and Waterfalling Spectrogram Demonstration Program')
pause % ... waiting for you to push the "enter" key

while (preview > 0)
   if strcmp(action, 'run')
      data = peekdata(AI, preview);
      getdata(AI, preview);
      [f, mag] = daqfft_undB(window.*(data - mean(data)), Fs, preview);
      screen_buffer = [20*log10(mag'); 20*log10(mag'); screen_buffer(1:preview/2 - 2, :)];
      set(H1,'CData', screen_buffer);
      data_buffer = [mag'; data_buffer(1:depth - 1, :)];
      set(P, 'ydata', 20*log10(mag));
      sum_data = sum(data_buffer);
      set(Q, 'ydata', 20*log10(sum_data/depth));
      drawnow;
   else
      break
   end
end

stop(AI)