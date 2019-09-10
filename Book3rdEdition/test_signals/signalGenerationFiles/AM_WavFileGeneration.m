%  AM-DSB, AM-DSB-SC, USSB, and LSSB demonstration and generation program
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%
%  copyright 2002
%
%  11 April 2002 - revision 1.0 ... initial implementation

% input terms
mu = 0.8;               % modulation index
length = 30;            % length of the selected signal
Fc = 10000;             % carrier frequency
load lpFilterDataFc10;  % 0 - 9 kHz passband, 10 kHz stopband 
[signal, Fs, Nbits] = wavread('GB.wav');    % Garth Brooks wav-file

% calculated terms
selectedSignal = (signal(1:length*Fs, 1))';
clear signal;

filteredSelectedSignal = filter(filt1.tf.num, filt1.tf.den, selectedSignal);
filteredSelectedSignalHilbert = hilbert(filteredSelectedSignal);

carrierCos = cos(2*pi*(1:length*Fs)*Fc/Fs);
carrierSin = sin(2*pi*(1:length*Fs)*Fc/Fs);

AM_DSB = (1 + mu*filteredSelectedSignal).*carrierCos;
AM_DSB = AM_DSB/max(abs(AM_DSB));

AM_DSB_SC = filteredSelectedSignal.*carrierCos;
AM_DSB_SC = AM_DSB_SC/max(abs(AM_DSB_SC));

USSB_AM = filteredSelectedSignal.*carrierCos - imag(filteredSelectedSignalHilbert).*carrierSin;
USSB_AM = USSB_AM/max(abs(USSB_AM));

LSSB_AM = filteredSelectedSignal.*carrierCos + imag(filteredSelectedSignalHilbert).*carrierSin;
LSSB_AM = LSSB_AM/max(abs(LSSB_AM));

% select the first 30 seconds of the song, play it back, display the PSD, and create the wav-file
sound(selectedSignal, Fs)
psd(selectedSignal, [], Fs)
title('PSD of the Song')
wavwrite(selectedSignal, Fs, Nbits, 'C:\MATLAB6p1\work\wavFiles\GBportion.wav');
pause

% filter the song, play it back, display the PSD, and create the wav-file
sound(filteredSelectedSignal, Fs)
psd(filteredSelectedSignal, [], Fs)
title('PSD of the Filtered Song')
wavwrite(filteredSelectedSignal, Fs, Nbits, 'C:\MATLAB6p1\work\wavFiles\filtered_GB.wav');
pause

% create AM DSB signal, play it back, display the PSD, and create the wav-file
sound(AM_DSB, Fs)
psd(AM_DSB, [], Fs)
title('PSD of the AM DSB Signal ... [1 + m(t)]cos(2\pif_ct)')
wavwrite(AM_DSB, Fs, Nbits, 'C:\MATLAB6p1\work\wavFiles\AM_DSB_GB.wav');
pause

% create AM DSB SC signal, play it back, display the PSD, and create the wav-file
sound(AM_DSB_SC, Fs)
psd(AM_DSB_SC, [], Fs)
title('PSD of the AM DSB SC Signal ... m(t)cos(2\pif_ct)')
wavwrite(AM_DSB_SC, Fs, Nbits, 'C:\MATLAB6p1\work\wavFiles\AM_DSB_SC_GB.wav');
pause

% create USSB AM signal, play it back, display the PSD, and create the wav-file
sound(USSB_AM, Fs)
psd(USSB_AM, [], Fs)
title('PSD of the USSB AM Signal ... m(t)cos(2\pif_ct) - Hilbert[m(t)]sin(2\pif_ct)')
wavwrite(USSB_AM, Fs, Nbits, 'C:\MATLAB6p1\work\wavFiles\USSB_GB.wav');
pause

% create LSSB AM signal, play it back, display the PSD, and create the wav-file
sound(LSSB_AM, Fs)
psd(LSSB_AM, [], Fs)
title('PSD of the LSSB AM Signal ... m(t)cos(2\pif_ct) + Hilbert[m(t)]sin(2\pif_ct)')
wavwrite(LSSB_AM, Fs, Nbits, 'C:\MATLAB6p1\work\wavFiles\LSSB_GB.wav');
