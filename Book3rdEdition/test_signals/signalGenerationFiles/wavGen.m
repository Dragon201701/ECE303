%  WavFile generation
%
%  by Thad Welch
%
%  written 5 May 2001, last revision 5 May 2001
%  copyright 2001

duration = 60;
fs = 44100;
f = 20000;
Nbits = 16;

wavwrite(0.99*cos(2*pi*f*(0:(1/fs):duration)),fs,Nbits,'C:\MATLAB6p1\work\wavFiles\Sine20000Hz.wav')
