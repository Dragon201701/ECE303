%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%//////////////////////////////////////////////////////////////////////

c6x_daq('Init', '320ad535.out', 'dsk6211_spp_lpt1');
c6x_daq('FrameSize', 500);
c6x_daq('QueueSize', 2000);
Fs = c6x_daq('SampleRate', 8000);
numChannels = c6x_daq('NumChannels', 1);
c6x_daq('TriggerMode', 'Immediate'); % disables triggering
c6x_daq('LoopbackOff'); % turn off the direct DSK loopback
c6x_daq('FlushQueues'); % flush the DSK's queues

data = c6x_daq('GetFrame'); % read frame to prime for SwapFrame

while 1 % begin forever loop
   c6x_daq('SwapFrame', data); % send/receive data
   % data = data * 10; % add gain
end
