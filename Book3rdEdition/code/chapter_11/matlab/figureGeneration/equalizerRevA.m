%  Calculating the equivalent impulse response for a 
%  5 band graphic equalizer
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  16 September 1998, July 2002, June 2004
%  modified by CHGW on 10 Jul 2002
%  copyright (c) 1998, 2002, 2004

% Simulation inputs
load('equalizer.mat')
A = [1.0 1.0 1.0 1.0 1.0]; % graphic equalizer scale factors

% Calculated terms
equivalentFilter = A(1)*filt1.tf.num + A(2)*filt2.tf.num + ...
    A(3)*filt3.tf.num + A(4)*filt4.tf.num + A(5)*filt5.tf.num;

% Plotting commands follow ... see the book CD-Rom for the details
% Simulation outputs
myFontSize = 16;            % font size for the plot labels

subplot(6,1,1)
P1 = stem(A(1)*filt1.tf.num);
set(gca, 'FontSize', myFontSize)
set(P1, 'LineWidth', 1.5)
axis([0 130 -0.1 0.1])
set(gca,'XTickLabel', []')
ylabel('h_{LP}')

subplot(6,1,2)
P2 = stem(A(2)*filt2.tf.num);
set(gca, 'FontSize', myFontSize)
set(P2, 'LineWidth', 1.5)
axis([0 130 -0.1 0.1])
set(gca,'XTickLabel', []')
ylabel('h_{BP_1}')

subplot(6,1,3)
P3 = stem(A(3)*filt3.tf.num);
set(gca, 'FontSize', myFontSize)
set(P3, 'LineWidth', 1.5)
axis([0 130 -0.2 0.2])
set(gca,'XTickLabel', []')
ylabel('h_{BP_2}')

subplot(6,1,4)
P4 = stem(A(4)*filt4.tf.num);
set(gca, 'FontSize', myFontSize)
set(P4, 'LineWidth', 1.5)
axis([0 130 -0.5 0.5])
set(gca,'XTickLabel', []')
ylabel('h_{BP_3}')

subplot(6,1,5)
P5 = stem(A(5)*filt5.tf.num);
set(gca, 'FontSize', myFontSize)
set(P5, 'LineWidth', 1.5)
axis([0 130 -0.5 1.0])
set(gca,'XTickLabel', []')
ylabel('h_{HP}')

subplot(6,1,6)
P6 = stem(equivalentFilter);
set(gca, 'FontSize', myFontSize)
set(P6, 'LineWidth', 1.5)
axis([0 130 -0.1 0.3])
xlabel('n (samples)')
ylabel('h_{total}')

% print -deps2 ImpRspWithGain
