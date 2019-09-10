%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ First iteration of a 5 band graphic equalizer
%/
%//////////////////////////////////////////////////////////////////////

% Simulation inputs
load('equalizer.mat')

myFontSize = 16;            % font size for the plot labels
A = [0.1 0.5 1.0 0.25 0.1]; % graphic equalizer scale factors
FsOver2 = 24000;            % Fs/2

% Calculated terms
[H_1,f] = freqz(filt1.tf.num, filt1.tf.den, 2048);
[H_2,f] = freqz(filt2.tf.num, filt2.tf.den, 2048);
[H_3,f] = freqz(filt3.tf.num, filt3.tf.den, 2048);
[H_4,f] = freqz(filt4.tf.num, filt4.tf.den, 2048);
[H_5,f] = freqz(filt5.tf.num, filt5.tf.den, 2048);

% Simulation outputs
figure(1)   % graphic equalizer's frequency response
set(gca, 'FontSize', myFontSize)
P1=plot(f*FsOver2/pi/1000,20*log10(abs(H_1)),'r');
set(P1, 'LineWidth', 1.5)
hold on;
P2=plot(f*FsOver2/pi/1000,20*log10(abs(H_2)),'g--');
set(P2, 'LineWidth', 1.5)
P3=plot(f*FsOver2/pi/1000,20*log10(abs(H_3)),'k');
set(P3, 'LineWidth', 1.5)
P4=plot(f*FsOver2/pi/1000,20*log10(abs(H_4)),'c--');
set(P4, 'LineWidth', 1.5)
P5=plot(f*FsOver2/pi/1000,20*log10(abs(H_5)),'m');
set(P5, 'LineWidth', 1.5)
P6=plot(f*FsOver2/pi/1000,20*log10(abs(H_1+H_2+H_3+H_4+H_5)),'b:');
set(P6, 'LineWidth', 1.5)
xlabel('frequency (kHz)')
ylabel('magnitude (dB)')
axis([0 FsOver2/1000 -50 5])
set(gca,'XTick', [0 4 8 12 16 20 24])
set(gca,'XTickLabel', [0 4 8 12 16 20 24]')
hold off;
% print -deps2 GrEqFreqRsp48

figure(2)
plot(f*FsOver2/pi/1000,unwrap(angle(H_1+H_2+H_3+H_4+H_5)),'b')
hold on;
plot([0 23997.55/1000],[0 -200.963],':g')
title('Phase Response')
xlabel('frequency (kHz)')
ylabel('phase (degrees)')
legend('actual phase','linear  phase')
axis([0 24 -200 0])
set(gca,'XTick', [0 4 8 12 16 20 24])
set(gca,'XTickLabel', [0 4 8 12 16 20 24]')
hold off;
% print -deps2 GrEqPhaseRsp48

figure(3)
set(gca, 'FontSize', myFontSize)
subplot(6,1,1)
P1 = stem(filt1.tf.num);
set(gca, 'FontSize', myFontSize)
set(P1, 'LineWidth', 1.5)
axis([0 130 -0.1 0.1])
set(gca,'XTickLabel', []')
ylabel('h_{LP}')

subplot(6,1,2)
stem(filt2.tf.num)
set(gca, 'FontSize', myFontSize)
set(P2, 'LineWidth', 1.5)
axis([0 130 -0.1 0.1])
set(gca,'XTickLabel', []')
ylabel('h_{BP_1}')

subplot(6,1,3)
stem(filt3.tf.num)
set(gca, 'FontSize', myFontSize)
set(P3, 'LineWidth', 1.5)
axis([0 130 -0.2 0.2])
set(gca,'XTickLabel', []')
ylabel('h_{BP_2}')

subplot(6,1,4)
stem(filt4.tf.num)
set(gca, 'FontSize', myFontSize)
set(P4, 'LineWidth', 1.5)
axis([0 130 -0.5 0.5])
set(gca,'XTickLabel', []')
ylabel('h_{BP_3}')

subplot(6,1,5)
stem(filt5.tf.num)
set(gca, 'FontSize', myFontSize)
set(P5, 'LineWidth', 1.5)
axis([0 130 -0.5 1.0])
set(gca,'XTickLabel', []')
ylabel('h_{HP}')

subplot(6,1,6)
stem(filt1.tf.num + filt2.tf.num + filt3.tf.num + filt4.tf.num + filt5.tf.num)
set(gca, 'FontSize', myFontSize)
set(P6, 'LineWidth', 1.5)
axis([0 130 0 1.0])
xlabel('n (samples)')
ylabel('h_{total}')
% print -deps2 ImpRspNoGain

figure(4)
set(gca, 'FontSize', myFontSize)
P1=plot(f*FsOver2/pi/1000,20*log10(A(1)*abs(H_1)),'r');
set(P1, 'LineWidth', 1.5)
hold on;
P2=plot(f*FsOver2/pi/1000,20*log10(A(2)*abs(H_2)),'g--');
set(P2, 'LineWidth', 1.5)
P3=plot(f*FsOver2/pi/1000,20*log10(A(3)*abs(H_3)),'k');
set(P3, 'LineWidth', 1.5)
P4=plot(f*FsOver2/pi/1000,20*log10(A(4)*abs(H_4)),'c--');
set(P4, 'LineWidth', 1.5)
P5=plot(f*FsOver2/pi/1000,20*log10(A(5)*abs(H_5)),'m');
set(P5, 'LineWidth', 1.5)
P6=plot(f*FsOver2/pi/1000,20*log10(abs(A(1)*H_1 + A(2)*H_2 + A(3)*H_3 + A(4)*H_4 + A(5)*H_5)),'b:');
set(P6, 'LineWidth', 1.5)
%title('Equalizer Response')
xlabel('frequency (kHz)')
ylabel('magnitude (dB)')
set(gca,'XTick', [0 4 8 12 16 20 24])
set(gca,'XTickLabel', [0 4 8 12 16 20 24]')
axis([0 FsOver2/1000 -50 5])
%legend('Band 1','Band 2','Band 3','Band 4','Band 5','sum',4)
hold off;
% print -deps2 GrEqPhaseRspWithGain48

figure(5)
set(gca, 'FontSize', myFontSize)
subplot(6,1,1)
P1 = stem(A(1)*filt1.tf.num);
set(gca, 'FontSize', myFontSize)
set(P1, 'LineWidth', 1.5)
axis([0 130 -0.1 0.1])
set(gca,'XTickLabel', []')
ylabel('0.1h_{LP}')

subplot(6,1,2)
stem(A(2)*filt2.tf.num)
set(gca, 'FontSize', myFontSize)
set(P2, 'LineWidth', 1.5)
axis([0 130 -0.1 0.1])
set(gca,'XTickLabel', []')
ylabel('0.5h_{BP_1}')

subplot(6,1,3)
stem(A(3)*filt3.tf.num)
set(gca, 'FontSize', myFontSize)
set(P3, 'LineWidth', 1.5)
axis([0 130 -0.2 0.2])
set(gca,'XTickLabel', []')
ylabel('h_{BP_2}')

subplot(6,1,4)
stem(A(4)*filt4.tf.num)
set(gca, 'FontSize', myFontSize)
set(P4, 'LineWidth', 1.5)
axis([0 130 -0.5 0.5])
set(gca,'XTickLabel', []')
ylabel('0.25h_{BP_3}')

subplot(6,1,5)
stem(A(5)*filt5.tf.num)
set(gca, 'FontSize', myFontSize)
set(P5, 'LineWidth', 1.5)
axis([0 130 -0.5 1.0])
set(gca,'XTickLabel', []')
ylabel('0.1h_{HP}')

subplot(6,1,6)
stem(A(1)*filt1.tf.num + A(2)*filt2.tf.num + A(3)*filt3.tf.num + A(4)*filt4.tf.num + A(5)*filt5.tf.num)
set(gca, 'FontSize', myFontSize)
set(P6, 'LineWidth', 1.5)
axis([0 130 -0.1 0.3])
xlabel('n (samples)')
ylabel('h_{total}')
% print -deps2 ImpRspWithGain

figure(6)
subplot(2,1,1)
stem(A(1)*filt1.tf.num + A(2)*filt2.tf.num + A(3)*filt3.tf.num + A(4)*filt4.tf.num + A(5)*filt5.tf.num)
set(gca, 'FontSize', myFontSize)
set(P6, 'LineWidth', 1.5)
axis([0 130 -0.1 0.3])
xlabel('n (samples)')
ylabel('h_{total}')

subplot(2,1,2)
P1=plot(f*FsOver2/pi/1000,20*log10(abs(A(1)*H_1 + A(2)*H_2 + A(3)*H_3 + A(4)*H_4 + A(5)*H_5)),'b');
set(gca, 'FontSize', myFontSize)
set(P1, 'LineWidth', 1.5)
xlabel('frequency (kHz)')
ylabel('magnitude (dB)')
axis([0 FsOver2/1000 -50 5])
set(gca,'XTick', [0 4 8 12 16 20 24])
set(gca,'XTickLabel', [0 4 8 12 16 20 24]')
hold off;
% print -deps2 GrEqImpRspAndFreqRspWithGain48
