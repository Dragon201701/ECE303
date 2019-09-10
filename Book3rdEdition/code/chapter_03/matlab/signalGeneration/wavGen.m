%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ WavFile generation
%/
%//////////////////////////////////////////////////////////////////////

duration = 60;
fs = 44100;
f = 20000;
Nbits = 16;

wavwrite(0.99*cos(2*pi*f*(0:(1/fs):duration)),fs,Nbits,'Sine20000Hz.wav')
