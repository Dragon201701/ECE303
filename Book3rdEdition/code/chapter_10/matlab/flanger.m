function y=flanger(x,t,alpha,f0,Fs)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ y=flanger(x,t,alpha,f0,fs)
%/ Implementation of a flanger, based upon the
%/ fir_comb2 filter using a "C-like" method.
%/ x is the input signal, t is the maximum 
%/ delay time, alpha is the 
%/ gain (normally 0-1) of the delayed signal, 
%/ f0 is the frequency of the delay variation,
%/ Fs is the sample frequency, and
%/ y is the filtered output.
%/
%/ Note: f0 should be much lower than fs
%/
%//////////////////////////////////////////////////////////////////////

% Use "wavread" or some similar function
% to get an audio file into MATLAB, and use
% "soundsc" or some similar function to play the
% resulting filtered sound.

% Recall MATLAB starts array indexes at 1 not 0, so 
% if you convert this to C keep that in mind

if nargin~=5
    error('You must supply five arguments');
end
if t<0
    error('Must use a positive delay value R');
end

% Method using a more "C-like" technique instead of the filter command

Ts=1/Fs;  % time between samples
R=round(t/Ts); % determine integer number of samples needed


N1=length(x); % number of samples in input array
Bn=zeros(1,N1); % preallocate array for B[n]
arg=0:N1-1;
arg=2*pi*(f0/Fs)*arg;
Bn=(R/2)*(1-cos(arg)); % sinusoidally varying delays from 0-R
Bn=round(Bn); % make the delays integer values


y=zeros(size(x));  % preallocate output array
% create array and index for "circular buffer"
buffer=zeros(1,R+1);
oldest=0;
% need to use "for loop" to simulate real-time samples arriving one by one
for i=1:N1
    offset=R-Bn(i); % adjustment for varying delay
    buffer(oldest+1)=x(i); % read input sample into circular buffer
    oldest=oldest + 1; % increment buffer index before checking for wrap
    oldest=mod(oldest,R+1); % wrap index around using modulus operator
    offset=oldest+offset; % if delay=R then this is just like fir_comb2
    offset=mod(offset,R+1);
    y(i)=x(i) + alpha*buffer(offset+1);
end

% end of flanger
