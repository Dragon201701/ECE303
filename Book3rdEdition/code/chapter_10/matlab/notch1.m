function y=notch1(x,beta,alpha)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ y=iir_comb1(x,beta,alpha)
%/ Implementation of an IIR notch filter
%/ using MATLAB's "filter" command.
%/ x is the input signal, beta determines the frequency
%/ of the notch, alpha (a positive value less than 1) 
%/ determines the width of the notch, and
%/ y is the filtered output.
%/
%/ For a notch frequency of f0 when using a sample
%/ frequency of fs, set beta=cos(2*pi*f0/fs)
%/
%//////////////////////////////////////////////////////////////////////

% Use "wavread" or some similar function
% to get an audio file into MATLAB, and use
% "soundsc" or some similar function to play the
% resulting filtered sound.

if nargin~=3
    error('You must supply three arguments');
end
if (beta < -1) || (beta > 1)
    error('Allowed range: -1 <= beta <= 1');
end
if (alpha < 0) || (alpha>=1)
    error('Allowed range: 0<= alpha < 1');
end

% Method using the filter command

A=[1 -beta*(1+alpha) alpha];
% A vector is now ready to use filter command
B=[1 -2*beta 1];
% B vector is now ready to use filter command
x=x*(1+alpha)/2; % scale for unity gain
y=filter(B,A,x); % perform filtering

% end of notch1

