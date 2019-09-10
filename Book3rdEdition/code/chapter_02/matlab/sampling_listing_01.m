%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005, 2016
%/
%/ Previous versions of MATLAB used the now obsolete 'wavread' command
%//////////////////////////////////////////////////////////////////////

[Y, Fs] = audioread('c:\windows\media\tada.wav');
myFile = audioinfo('c:\windows\media\tada.wav')
sound(Y, Fs)
