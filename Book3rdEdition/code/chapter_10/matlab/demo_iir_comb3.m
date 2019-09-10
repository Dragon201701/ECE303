function demo_iir_comb3(fn,t,alpha)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ demo_iir_comb3(x,t,alpha)
%/ Demo of an IIR comb filter
%/ Reads in a wav file, computes number of sample delays needed
%/ to achieve a specified delay time, and plays the result.
%/ fn is the input file name of the WAV file, 
%/ t is the time delay desired, and
%/ alpha is the gain (a positive value less than 1) of the delayed signal.
%/ Note: filename must be entered as a string.
%/
%//////////////////////////////////////////////////////////////////////

if nargin~=3
    error('You must supply three arguments');
end
if t<0
    error('Must use a positive time delay');
end
if abs(alpha)>=1
    error('Must use a gain value with magnitude < 1');
end

% read in WAV file
[x,Fs]=wavread(fn);  % get samples and sample frequency
Ts=1/Fs;  % time between samples
R=round(t/Ts); % determine integer number of samples needed
y=iir_comb3(x,R,alpha);
soundsc(y,Fs);

% end of demo

