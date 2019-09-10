%  DTMFgen.m
%
%  This m-file generates the DTMF tones associated with the input phoneNumber.
%  The DTMF tone sequence is then played back using the PC's sound system and
%  the power spectral density (PSD) of the sequence is plotted.  The DTMF 
%  sequence is also converted to wav-format and saved to the PC's hard drive.
%  This file may then be played using any wav-capable device.
%
%  You may dial a phone by holding a phone handset near one of your PC's 
%  speakers while executing this m-file!
%
%  You may need to modify the path and filename in the "wavwrite" command on 
%  line 92.
%
%  The phone number may contain 1, 2, 3, 4, 5, 6, 7, 8, 9, *, 0, #, -, (, and )
%
%  The DTMF frequency table follows,
%
%                    High Tone (Hz)
%  Low Tone       ____________________
%  ________       1209    1336    1477
%    697            1       2       3
%    770            4       5       6
%    852            7       8       9
%    941            *       0       #
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2002
%  completed on 12 January 2002 - revision 1.0

% Simulation inputs
phoneNumber = '1-410-293-6163'; % input a phone number as a character array
duration = 100;                 % duration of each DTMF tone in milliseconds
spacing = 25;                   % time between DTMF tones in milliseconds

amplitude = 0.99;               % final DTMF tone maximum amplitude (|tones| < 1)
Fs = 44100;                     % sample frequency in samples/sec
Nbits = 16;                     % number of bit used to represent a sample

% Calculated terms
tones = [];                     % initialize "tones" vector
errorFlag = 0;                  % invalid phone numbers indicated by errorFlag = 1
t = 0:1/Fs:(duration/1000);     % creating a time vector for DTMF tone generation
delay = 0:1/Fs:(spacing/1000);  % creating a delay vector for DTMF tone spacing

for i=1:length(phoneNumber)
   if strcmp(phoneNumber(i),'-')
       f = [0 0];
   elseif strcmp(phoneNumber(i),'(')
       f = [0 0];
   elseif strcmp(phoneNumber(i),')')
       f = [0 0];
   elseif strcmp(phoneNumber(i),'1')
       f = [697 1209];
   elseif strcmp(phoneNumber(i),'2')
       f = [697 1336];
   elseif strcmp(phoneNumber(i),'3')
       f = [697 1477];
   elseif strcmp(phoneNumber(i),'4')
       f = [770 1209];
   elseif strcmp(phoneNumber(i),'5')
       f = [770 1336];
   elseif strcmp(phoneNumber(i),'6')
       f = [770 1477];
   elseif strcmp(phoneNumber(i),'7')
       f = [852 1209];
   elseif strcmp(phoneNumber(i),'8')
       f = [852 1336];
   elseif strcmp(phoneNumber(i),'9')
       f = [852 1477];
   elseif strcmp(phoneNumber(i),'*')
       f = [941 1209];
   elseif strcmp(phoneNumber(i),'0')
       f = [941 1336];
   elseif strcmp(phoneNumber(i),'#')
       f = [941 1477];
   else
       errorFlag = 1;
   end
   
   if (f(1) == 0)   % don't add a tone since either a -, (, or, ) was found
   else             % add the DTMF tones associated with the next character
       tones = [tones (cos(2*pi*f(1)*t) + cos(2*pi*f(2)*t)) delay];
   end
end

tones = amplitude*tones/max(abs(tones));    % scale the "tone" vector

%Simulation outputs
if (errorFlag == 0)
   sound(tones, Fs, Nbits) % playback the DTMF tone sequence
   wavwrite(tones, Fs, Nbits, 'C:\MATLAB6p1\work\wavFiles\DTMFtones.wav')
   psd(tones, 2048, Fs)    % calculate and plot the PSD of the DTMF test tones
   title(['PSD Associated with the DTMF Tones for ' phoneNumber])
   xlabel('frequency (Hz)')
   axis([600 1600 -10 20])
else
   disp('The phone number contains an invalid character!')
   disp('Only numbers, *, #, -, (, and ) are allowed.')
end