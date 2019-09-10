function y=fir_comb1(x,R,alpha)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ y=fir_comb1(x,R,alpha)
%/ Implementation of an FIR comb filter
%/ using MATLAB's "filter" command.
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

if nargin~=3
    error('You must supply three arguments');
end
if R<0
    error('Must use a positive delay value R');
end

% Method using the filter command

R=round(R);  % ensure R is an integer before proceeding
A=1; % the "A" vector is a scalar equal to 1 for FIR filters
B=zeros(1,R+1);  % correct length of vector B
B(1)=1;
B(R+1)=alpha;
% B vector is now ready to use filter command
y=filter(B,A,x);

% end of fir_comb1

