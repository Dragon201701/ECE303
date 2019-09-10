function pn_spec(pn)
% Used for approximating the power spectrum of a PN sequence. 
% Creates L data points per chip to get better frequency resolution
% for the FFT, resulting in a better looking PSD estimate.
% Note: no windowing or overlap is used in this PSD estimate.
%
% Can use harcoded PN examples below, or accept a PN sequence input
% as a row vector.  For the latter case, programs pngen and pngen2
% can be used to generate any needed PN code.
%
% copyright (c) 2011 Cameron H. G. Wright


% length of a quasi-continuous "chip"
% MATLAB will have L data points per chip to send to FFT
L=20;  % the value 20 seems to work well 

% Reset figure axes
close all;

% Globally hardcode the figuure text size
set(0,'DefaultAxesFontSize',18);
set(0,'DefaultTextFontSize',18);
 
% For global figure line widths; use lines >1 with caution, only if needed
set(0,'DefaultLineLineWidth',1); % use thicker line

st=''; % default in case you forget to uncomment the string

if (nargin == 0)  % no PN code was provided as input
    % If using PN code as input argument, do not uncomment any of these
    % Hardcoded PN sequences below; uncomment only the one you want
    % also uncomment the st1 string for the plot title
    % SSRG [3,1]
    % st='[3,1]_s';
    % pn=[1 1 1 0 1 0 0];
    
    % SSRG [4,1]
    % st='[4,1]_s';
     pn=[1 1 1 1 0 1 0 1 1 0 0 1 0 0 0];
    
    % SSRG [5,2]
    %st='[5,2]_s';
    %pn=[1 0 1 0 1 1 1 0 1 1 0 0 0 1 1 1 1 1 0 0 1 1 0 1 0 0 1 0 0 0 0];
end

N=length(pn);

% convert to polar NRZ line code (antipodal, +1, -1)
ppn=(2*pn)-1;

% create array of quasi-continuous chips following pattern of PN sequence 
cpn=zeros(1,N*L);  % preallocate array
for i=0:N-1
    for j=1:L
        cpn(j+(i*L))=ppn(i+1);
    end
end

NN=length(cpn); % equal to N*L

% circular autocorrelation of "continuous" sequence
CPN=fft(cpn);
ccxcorr=ifft(CPN.*conj(CPN));

% PSD estimate via Wiener-Khintchine theorem
pnspec=fftshift(abs(fft(ccxcorr)))/NN;


%  plot the figures
figure(1)
plot(0:NN-1,cpn)
axis([0 NN-1 -1.5 1.5])
title(['Quasi-continuous PN sequence ' st]);

% normalized circular autocorrelation
figure(2)
plot(0-3:NN-1-3,fftshift(ccxcorr)/NN)
title(['Circular AC of PN sequence ' st]);

% normalized linear autocorrelation
figure(3)
plot(0-6:2*NN-1-1-6,xcorr(cpn)/NN)
title(['Linear AC of PN sequence ' st]);

% plot PSD estimate
figure(4)
k= -(NN/2):(NN/2)-1;
stem(k,pnspec)
xlabel('k')
ylabel('PSD')
title(['Power spectrum of ' st ' PN Sequence'])
% zoom in to main lobe and first two side lobes
axis([-(NN/7) NN/7 0 25])

% Save Figures as EPS level 2 color
% Only uncomment if you want to generate the EPS file
% print -depsc2 -f4 PNspec_ML.eps




