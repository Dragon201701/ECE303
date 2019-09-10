function y=fir_comb2(x,R,alpha)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ y=fir_comb2(x,R,alpha)
%/ Implementation of an FIR comb filter
%/ using a "C-like" method, not the filter command.
%/ x is the input signal, R is the number of 
%/ sample times of delay, alpha is the 
%/ gain (normally 0-1) of the delayed signal, and
%/ y is the filtered output.
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
if R<0
    error('Must use a positive delay value R');
end

% Method using a more "C-like" technique instead of the filter command

R=round(R);  % ensure R is an integer before proceeding
N1=length(x); % number of samples in input array
y=zeros(size(x));  % preallocate output array
% create array and index for "circular buffer"
buffer=zeros(1,R+1);
oldest=0;
% need to use "for loop" to simulate real-time samples arriving one by one
for i=1:N1
    buffer(oldest+1)=x(i); % read input sample into circular buffer
    oldest=oldest + 1; % increment buffer index before checking for wrap
    oldest=mod(oldest,R+1); % wrap index around using modulus operator
    y(i)=x(i) + alpha*buffer(oldest+1);
end
% end of fir_comb2
