function y=fir_comb(x,R,alpha)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ y=fir_comb(x,R,alpha)
%/ Implementation of an FIR comb filter
%/ x is the input signal, R is the number of 
%/ sample times of delay, alpha is the 
%/ gain (0-1) of the delayed signal, and
%/ y is the filtered output.
%/
%//////////////////////////////////////////////////////////////////////

% Use "wavread" or some similar function
% to get an audio file into MATLAB, and use
% "soundsc" or some similar file to play the
% resulting filtered sound.

% Two methods are included in this m-file.
% Uncomment the version you want to use and 
% comment out the version you don't want to use

% Recall MATLAB starts array indexes at 1 not 0

% Method 1 using the filter command

% a=1; % the "a" vector is always 1 for FIR filters
% b=zeros(1,R+1);  % correct length of vector b
% b(1)=1;
% b(R+1)=alpha;
% % b vector is now ready to use filter command
% y=filter(b,a,x);
% % end of Method 1

% Method 2 using a more "C-like" technique

% preallocate output array
N1=length(x); 
y=zeros(size(x)); 
% create array and index for "circular buffer"
buffer=zeros(1,R+1);
oldest=0;
% need to use "for loop" to simulate real-time samples arriving one by one
for i=1:N1
    buffer(oldest+1)=x(i); % read input sample into circular buffer
    oldest=oldest + 1; % increment buffer index before checking for wrap
    oldest=mod(oldest,R+1); % wrap index around using modulus operator
    y(i)=x(i) + alpha*buffer(oldest);
end
% end of Method 2
