function [f,mag] = daqfft_undB(data,Fs,blocksize)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%//////////////////////////////////////////////////////////////////////

xFFT=fft(data/sqrt(blocksize));
xfft=abs(xFFT);
ind=find(xfft==0);
xfft(ind)=1e-17;

mag=xfft(1:blocksize/2);
f=(0:length(mag)-1)*Fs/blocksize;
f=f(:);
