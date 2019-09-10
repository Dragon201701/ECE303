function pn_corr(seq1, seq2)
% 
% Demonstrates the autocorrelation or cross correlation 
% of PN sequences
%
% Can use harcoded PN examples below, or accept one or two PN sequences 
% input as row vectors.  For the latter case, programs pngen and pngen2
% can be used to generate any needed PN code. If only one PN sequence is
% provided as input, then the operation is autocorrelation
%
%
% Copyright (c) 2001, 2011 Cameron H. G. Wright

%
% Reset figures
close all;

% Hardcode the text size globally:
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultTextFontSize',14);
 
% For global line widths:
set(0,'DefaultLineLineWidth',2); % use thicker line

if  (nargin == 1)  %  autocorrelation is desired for single PN seq input
    seq2 =  seq1;
end

if (nargin == 0)  % no PN codes were provided as input
    % If using PN code(s) as input argument, do not uncomment any of these
    % Uncomment desired PN sequences; validity of m-sequences
    % is noted. Invalid sequences are useful to compare the
    % correlation properties.
    % You can choose to autocorrelate the same sequence or you can
    % crosscorrelate different sequences (of the same length).
    
    % SSRG [3,1]
    %seq1=[1 1 1 0 1 0 0];
    %seq2=[1 1 1 0 1 0 0];
    
    % SSRG [3,2]
    %seq1=[1 0 1 1 1 0 0];
    %seq2=[1 0 1 1 1 0 0];
    
    % reversed SSRG [3,1]
    %seq1=[0 0 1 0 1 1 1];
    %seq2=[0 0 1 0 1 1 1];
    
    % not a valid m-sequence
    %seq1=[0 1 0 0 1 0 1];
    %seq2=[0 1 0 0 1 0 1];
    
    % SSRG [4,1]
    %seq1=[1 1 1 1 0 1 0 1 1 0 0 1 0 0 0];
    %seq2=[1 1 1 1 0 1 0 1 1 0 0 1 0 0 0];
    
    % SSRG [4,3]
    %seq1=[1 0 0 1 1 0 1 0 1 1 1 1 0 0 0];
    %seq2=[1 0 0 1 1 0 1 0 1 1 1 1 0 0 0];
    
    % SSRG [5,2]
    %seq1=[1 0 1 0 1 1 1 0 1 1 0 0 0 1 1 1 1 1 0 0 1 1 0 1 0 0 1 0 0 0 0];
    %seq2=[1 0 1 0 1 1 1 0 1 1 0 0 0 1 1 1 1 1 0 0 1 1 0 1 0 0 1 0 0 0 0];
    
    % SSRG [5,3]
    seq1=[1 0 0 1 0 1 1 0 0 1 1 1 1 1 0 0 0 1 1 0 1 1 1 0 1 0 1 0 0 0 0];
    %seq2=[1 0 0 1 0 1 1 0 0 1 1 1 1 1 0 0 0 1 1 0 1 1 1 0 1 0 1 0 0 0 0];
    
    % SSRG [5,4,3,2]  note this uses multiple fb taps
    %seq1=[1 1 1 1 1 0 0 1 0 0 1 1 0 0 0 0 1 0 1 1 0 1 0 1 0 0 0 1 1 1 0];
    seq2=[1 1 1 1 1 0 0 1 0 0 1 1 0 0 0 0 1 0 1 1 0 1 0 1 0 0 0 1 1 1 0];
    
    % not a valid m-sequence
    %seq1=[0 1 0 0 0 1 1 1 0 1 0 1 0 1 1 0 1 0 1 0 1 1 0 0 0 1 0 1 0 1 1];
    %seq2=[0 1 0 0 0 1 1 1 0 1 0 1 0 1 1 0 1 0 1 0 1 1 0 0 0 1 0 1 0 1 1];
end

N=length(seq1);

% Convert to +/- 1
seqn1=(2*seq1)-1;
seqn2=(2*seq2)-1;

% Set up correlation with three periods of the PN sequence
tmp1=[seqn1 seqn1 seqn1];

% Time domain method for circular correlation of seq1 and seq2.
% Could also use frequency domain method with no zero padding
% but this method is faster
for index=1:2*N+1;
tmp2=[zeros(1,index-1) seqn2 zeros(1,2*N-index+1)];
cor(index)=sum(tmp1.*tmp2)/N;
end;
n=0:2*N;

% % frequency domain method of circular correlation 
% % uncomment if desired
% S1=fft(seqn1);
% S2=fft(seqn2);
% cxcorr=ifft(S1.*conj(S2));


% standard linear correlation in MATLAB
lincor=xcorr(seqn1,seqn2)/N;
nn=0:2*N-2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
subplot(3,1,1);
bar(seqn1);
axis([0 N+1 -1.2 1.2]);
xlabel('chip number')
ylabel('PN 1');

subplot(3,1,2);
bar(seqn2);
axis([0 N+1 -1.2 1.2]);
xlabel('chip number')
ylabel('PN 2');

% circular correlation
subplot(3,1,3);
plot(n,cor);
grid on;
axis([0 2*N -1.2 1.2]);
ylabel('Rxy');
xlabel('Chip Offset - Circular Correlation');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
subplot(3,1,1);
bar(seqn1);
axis([0 N+1 -1.2 1.2]);
xlabel('chip number')
ylabel('PN 1');

subplot(3,1,2);
bar(seqn2);
axis([0 N+1 -1.2 1.2]);
xlabel('chip number')
ylabel('PN 2');

% linear correlation
subplot(3,1,3);
plot(nn,lincor);
grid on;
axis([0 2*N-2 -1.2 1.2]);
ylabel('Rxy');
xlabel('Chip Offset - Linear Correlation');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)
subplot(4,1,1);
bar(seqn1);
axis([0 N+1 -1.2 1.2]);
xlabel('chip number')
ylabel('PN 1');

subplot(4,1,2);
bar(seqn2);
axis([0 N+1 -1.2 1.2]);
xlabel('chip number')
ylabel('PN 2');

% circular correlation
subplot(4,1,3);
plot(n,cor);
grid on;
axis([0 2*N -1.2 1.2]);
ylabel('Rxy');
xlabel('Chip Offset - Circular Correlation');

% linear correlation
subplot(4,1,4);
plot(nn,lincor);
grid on;
axis([0 2*N-2 -1.2 1.2]);
ylabel('Rxy');
xlabel('Chip Offset - Linear Correlation');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)

% Save Figures as EPS level 2 color: 
 print -depsc2 -f1 PNcircorr.eps
% print -depsc2 -f2 PNlincorr.eps
% print -depsc2 -f3 PNcorr.eps

