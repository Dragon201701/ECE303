C8X_DAQ('Init', 'aic23_6713.out', 5, 3);
C8X_DAQ('Version');
FrameSize = 1024;
C8X_DAQ('FrameSize', FrameSize);
C8X_DAQ('QueueSize', 2*FrameSize);
Fs = C8X_DAQ('SampleRate', 48000);
C8X_DAQ('InputSource', 'Line');
numChannels = C8X_DAQ('NumChannels', '12');
C8X_DAQ('TriggerMode', 'Auto');
C8X_DAQ('TriggerSlope', '-');
C8X_DAQ('TriggerValue', 0.0);
C8X_DAQ('TriggerChannel', 1);
C8X_DAQ('LoopbackOn');
C8X_DAQ('GetSettings');

data = C8X_DAQ('GetFrame');
P1=plot(data(:,1),'k');
hold on
P2=plot(data(:,2),'r');
hold off
legend('CH 1', 'CH 2');
axis([0 FrameSize -1.1 1.1])
set(gcf,'doublebuffer','on')

while 1 > 0
   data = C8X_DAQ('GetFrame');
%   C8X_DAQ('SwapFrame', data);
   %   data=abs(fft(data));
   try
   	set(P1,'ydata',data(:,1))
   	set(P2,'ydata',data(:,2))
   catch
   	break;
   end
   drawnow
end

