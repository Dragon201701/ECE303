%  wavUniformNoiseGen.m
%
%  This m-file creates uniformly distributed noise which is converted to a 
%  wav-file and stored to disk.  This file may then be played using any 
%  wav-capable device.  The file can also be transferred to other media 
%  (e.g. CD-R or CD-RW).  Once transferred to CD, a CD player can be used 
%  as a function generator.
%
%  Approximately 21 MB of system memory is used to store a 60 second test tone.
%
%        ***** Be careful NOT to make "duration" to large! *****
%
%  A 60 second wav-file will occupy approximately 5 MB of hard drive space.
%
%  "noise" values MUST be kept within the range -1.0 to 1.0 or clipping will 
%  occur.  Clipping, depending on the severity, may cause significant distortion.
%
%  You will need to modify the path and filename in the "wavwrite" command on 
%  line 37.
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2001, 2002
%  completed on 5 May 2001 - revision 1.0
%  last revision 10 January 2002 - revision 1.1

% Simulation inputs
duration = 60;      % test tone duration in seconds

Fs = 44100;         % sample frequency in samples/sec (CD players use 44100)
Nbits = 16;         % number of bit used to represent a sample
scaleFactor = 0.99; % ensures that the |noise| < 1.0

% Calculated terms
noise = scaleFactor*(2*rand(1, Fs*duration) - 1);   % creates and scales the noise vector

%Simulation outputs
wavwrite(noise, Fs, Nbits, 'C:\MATLAB6p1\work\wavFiles\uniformNoise.wav')