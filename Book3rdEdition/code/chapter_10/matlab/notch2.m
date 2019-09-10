function y=notch2(x,Beta,alpha)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ y=notch2(x,Beta,alpha)
%/ Implementation of an IIR notch filter
%/ using a "C-like" method, not the filter command.
%/ x is the input signal, Beta determines the frequency
%/ of the notch, alpha (a positive value less than 1) 
%/ determines the width of the notch, and
%/ y is the filtered output.
%/
%/ For a notch frequency of f0 when using a sample
%/ frequency of fs, set Beta=cos(2*pi*f0/fs)
%/ 
%/ This code uses a Direct Form II implementation
%/ of a digital IIR filter, thus requiring only one circular  
%/ buffer even though both x and y values are delayed.
%/
%//////////////////////////////////////////////////////////////////////

% Use "wavread" or some similar function
% to get an audio file into MATLAB, and use
% "soundsc" or some similar function to play the
% resulting filtered sound.

% Recall MATLAB starts array indexes at 1 not 0, so 
% if you convert this to C keep that in mind

if nargin~=3
    error('You must supply three arguments');
end
if (Beta < -1) || (Beta > 1)
    error('Allowed range: -1 <= Beta <= 1');
end
if (alpha < 0) || (alpha>=1)
    error('Allowed range: 0<= alpha < 1');
end

% Method using a more "C-like" technique instead of the filter command

N1=length(x); % number of samples in input array
y=zeros(size(x));  % preallocate output array
% create array and index for "circular buffer"
% This second order filter only needs a buffer 3 elements long
buf=zeros(1,3); % to hold the delayed values
oldest=0; nextoldest=0; newest=0;
x=x*(1+alpha)/2; % scale input values for unity gain
% Set coefficient values so calculation isn't done inside "for" loop
% If sweeping Beta over time, this would need to be inside "for" loop
B0=1; B1=-2*Beta; B2=1;
A0=1; A1=Beta*(1+alpha); A2=-alpha;
% need to use "for loop" to simulate real-time samples arriving one by one
for i=1:N1
    newest=oldest; % save value of index before incrementing
    oldest=oldest + 1; % increment buffer index before checking for wrap
    oldest=mod(oldest,3); % wrap index around using modulus operator
    nextoldest=oldest + 1; % increment buffer index again
    nextoldest=mod(nextoldest,3); % wrap index around 
    buf(newest+1)=x(i) + A1*buf(nextoldest+1) + A2*buf(oldest+1);
    y(i)=B0*buf(newest+1) + B1*buf(nextoldest+1) + B2*buf(oldest+1);
end
% end of notch2
