function y=iir_comb1(x,R,alpha)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ y=iir_comb1(x,R,alpha)
%/ Implementation of an IIR comb filter
%/ using MATLAB's "filter" command.
%/ x is the input signal, R is the number of 
%/ sample times of delay, alpha is the 
%/ gain (a positive value less than 1) of the delayed signal, and
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
if abs(alpha)>=1
    error('Must use a gain value with magnitude < 1');
end

% Method using the filter command

R=round(R);  % ensure R is an integer before proceeding
A=zeros(1,R+1);  % correct length of vector A
A(1)=1;
A(R+1)=-alpha;
% A vector is now ready to use filter command
B=zeros(1,R+1);  % correct length of vector B
B(R+1)=1;  % use B=1 for other IIR version
% B vector is now ready to use filter command
y=filter(B,A,x);

% end of iir_comb1

