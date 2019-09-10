function y=tremelo(x,alpha,f0,Fs)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ y=tremelo(x,alpha,f0,fs)
%/ Implementation of a tremelo effect, 
%/ using a "C-like" method.
%/ x is the input signal, alpha is the 
%/ gain (between 0-1) of the amplitude modulated signal, 
%/ f0 is the frequency of the modulation,
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

if nargin~=4
    error('You must supply five arguments');
end
if (alpha < 0) || (alpha > 1)
    error('Alpha must be between 0 and 1')
end


% Method using a "C-like" technique 

N1=length(x); % number of samples in input array
N2=Fs/f0;  % length for one period of a sinusoid
Bn=zeros(1,N2); % preallocate array for B[n]
arg=0:N2-1;
arg=2*pi*(f0/Fs)*arg;
Bn=(0.5)*(1-cos(arg)); % sinusoidally varying numbers from 0-1
scale=1-alpha; % to scale the non-modulated component

y=zeros(size(x));  % preallocate output array
% create index for "circular buffer" of Bn
Bindex=0;
% use "for loop" to simulate real-time samples arriving one by one
for i=1:N1
    y(i)=scale*x(i) + Bn(Bindex+1)*alpha*x(i);
    Bindex=Bindex + 1; % increment Bn index
    Bindex=mod(Bindex,N2); % wrap index around
end

% end of tremelo
