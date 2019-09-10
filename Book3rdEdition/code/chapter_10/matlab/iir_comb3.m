function y=iir_comb3(x,R,alpha)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ y=iir_comb3(x,R,alpha)
%/ Implementation of an IIR comb filter
%/ using a "C-like" method, not the filter command.
%/ x is the input signal, R is the number of 
%/ sample times of delay, alpha is the 
%/ gain (a positive value less than 1) of the delayed signal, and
%/ y is the filtered output.
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
if R<0
    error('Must use a positive delay value R');
end
if abs(alpha)>=1
    error('Must use a gain value with magnitude < 1');
end

% Method using a more "C-like" technique instead of the filter command

R=round(R);  % ensure R is an integer before proceeding
N1=length(x); % number of samples in input array
y=zeros(size(x));  % preallocate output array
% create array and index for "circular buffer"
buffer=zeros(1,R+1); % to hold the delayed values
oldest=0; newest=0;
% need to use "for loop" to simulate real-time samples arriving one by one
for i=1:N1
    newest=oldest; % save value of index before incrementing
    oldest=oldest + 1; % increment buffer index before checking for wrap
    oldest=mod(oldest,R+1); % wrap index around using modulus operator
    buffer(newest+1)=x(i) + alpha*buffer(oldest+1);
    y(i)=buffer(oldest+1); % use newest for other IIR version
end
% end of iir_comb3