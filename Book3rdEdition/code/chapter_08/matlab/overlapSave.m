%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ This m-file is used to demonstrate the Overlap-Save
%/ method of fast convolution
%/
%//////////////////////////////////////////////////////////////////////

myFontSize = 14;                % font size for the plot labels
myMarkerSize = 8;               % marker size for the stem plots
myXMarkerSize = 24;               % marker size for the stem plot X's
myLineWidth = 1;                % line width for the stem plots


% Simulation inputs
h = [0.01006559437851 0.14342069594116 ... 
    0.22972713000462  0.27635690742231 ...
    0.22972713000462  0.14342069594116 ...
    0.01006559437851];      % filter coefficient declaration

x = [1 3 -2 4 -4 2 3 4 1 3 -2 -4 1 -2 0 3 0 2 -1 -4 3 3 ...
    3 -2 -2 3 -2 3 4 1 0 0 0 0 0 0];    % input term declaration

FFTlength = 16;

% Calculated terms
N = length(x);              % 35
M = length(h);              % 7 (6th order)
P = FFTlength + 1 - M;      % 10 values at a time

H = fft([h zeros(1, 9)]);
y = conv(h, x);

% Output terms
figure(1)
subplot(911)
stem(0:(N-1), x, 'b','MarkerSize', myMarkerSize, 'LineWidth', myLineWidth)
% next two lines for plotting only
hold on
stem(30:35, zeros(1, 6), 'r', 'filled','MarkerSize', myMarkerSize, 'LineWidth', myLineWidth)
set(gca, 'XTickLabel', [])
set(gca, 'FontSize', myFontSize)
ylabel('x_ [n]')
axis([0 35 -5 5])

subplot(912)
stem(0:15, x(1:16), 'b','MarkerSize', myMarkerSize, 'LineWidth', myLineWidth)
%hold on
%stem(16:35, zeros(1,20), 'r')
set(gca, 'XTickLabel', [])
set(gca, 'FontSize', myFontSize)
ylabel('x_0[n]')
axis([0 35 -5 5])
%hold off

subplot(913)
%stem(0:9, zeros(1,10), 'r')
%hold on
%%stem(10:25, x(10:25), 'b','MarkerSize', myMarkerSize, 'LineWidth', myLineWidth)
stem(10:25, x(11:26), 'b','MarkerSize', myMarkerSize, 'LineWidth', myLineWidth)
%stem(26:35, zeros(1,10), 'r')
set(gca, 'XTickLabel', [])
set(gca, 'FontSize', myFontSize)
ylabel('x_1[n]')
axis([0 35 -5 5])
%hold off

subplot(914)
%stem(0:19, zeros(1,20), 'r')
%hold on
%%stem(20:35, x(20:35), 'b','MarkerSize', myMarkerSize, 'LineWidth', myLineWidth)
stem(20:35, x(21:36), 'b','MarkerSize', myMarkerSize, 'LineWidth', myLineWidth)
set(gca, 'XTickLabel', [])
set(gca, 'FontSize', myFontSize)
ylabel('x_2[n]')
axis([0 35 -5 5])
%hold off

subplot(915)
y0 = ifft(H.*fft(x(1:16)));
stem(0:15, y0, 'b','MarkerSize', myMarkerSize, 'LineWidth', myLineWidth)
hold on
plot(0:5, y0(1:6), 'rx','MarkerSize', myXMarkerSize, 'LineWidth', myLineWidth)
%stem(16:35, zeros(1, 20), 'r')
axis([0 35 -5 5])
set(gca, 'XTickLabel', [])
set(gca, 'FontSize', myFontSize)
ylabel('y_0[n]')
hold off

subplot(916)
%%y1 = ifft(H.*fft(x(10:25)));
y1 = ifft(H.*fft(x(11:26)));
stem(10:25, y1, 'b','MarkerSize', myMarkerSize, 'LineWidth', myLineWidth)
hold on
plot(10:15, y1(1:6), 'rx','MarkerSize', myXMarkerSize, 'LineWidth', myLineWidth)
axis([0 35 -5 5])
set(gca, 'XTickLabel', [])
set(gca, 'FontSize', myFontSize)
ylabel('y_1[n]')
hold off
 
subplot(917)
y2 = ifft(H.*fft([x(21:30) zeros(1,6)]));
stem(20:35, y2, 'b','MarkerSize', myMarkerSize, 'LineWidth', myLineWidth)
hold on
plot(20:25, y2(1:6), 'rx','MarkerSize', myXMarkerSize, 'LineWidth', myLineWidth)
axis([0 35 -5 5])
set(gca, 'XTickLabel', [])
set(gca, 'FontSize', myFontSize)
ylabel('y_2[n]')
hold off
 
subplot(918)
stem(0:35, [y0 y1(7:16) y2(7:16)],'MarkerSize', myMarkerSize, 'LineWidth', myLineWidth)
hold on
plot(0:5, y0(1:6), 'rx','MarkerSize', myXMarkerSize, 'LineWidth', myLineWidth)
axis([0 35 -5 5])
set(gca, 'XTickLabel', [])
set(gca, 'FontSize', myFontSize)
ylabel('  save_ ')
hold off
 
subplot(919)
stem(0:35, y(1:36),'MarkerSize', myMarkerSize, 'LineWidth', myLineWidth)
set(gca, 'FontSize', myFontSize)
ylabel('x[n]*h[n]_ ')
axis([0 35 -5 5])
xlabel('n')
 
% print -depsc2 overlapSave.eps  % color
% print -deps2 overlapSave.eps   % grayscale
