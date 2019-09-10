%  This m-file reads in the NASDAQ composite averages for
%  
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2001, 2016
%  completed on 13 December 2001 revision 1.0

% Simulation inputs
load('nasdaq_c01.txt');
myFontSize = 16;    % font size for the plot labels

% Calculated terms
MA4results = filtfilt(ones(1,4)/4, 1, nasdaq_c01);
MA32results = filtfilt(ones(1,32)/32, 1, nasdaq_c01);

% Simulation outputs
subplot(2,1,1)
set(gca, 'FontSize', myFontSize)
P1 = plot(nasdaq_c01, 'b-');
%set(P1, 'LineWidth', 1.5)
hold on
P2 = plot(MA4results,'r--');
set(P2, 'LineWidth', 1.5)
P3 = plot(MA32results,'k-.');
set(P3, 'LineWidth', 1.5)
plot([175 175], [1000 2500], 'k')   % September 11, 2001 marker
legend('raw data', 'MA  4', 'MA 32', 'Location', 'SouthWest')
ylabel('closing value')
xlabel('days open')
axis([100 235 1000 2500])
hold off

MA4results = filter(ones(1,4)/4, 1, nasdaq_c01);
MA32results = filter(ones(1,32)/32, 1, nasdaq_c01);

subplot(2,1,2)
set(gca, 'FontSize', myFontSize)
P1 = plot(nasdaq_c01, 'b-');
%set(P1, 'LineWidth', 1.5)
hold on
P2 = plot(MA4results,'r--');
set(P2, 'LineWidth', 1.5)
P3 = plot(MA32results,'k-.');
set(P3, 'LineWidth', 1.5)
legend('raw data', 'MA  4', 'MA 32', 'Location', 'SouthWest')
ylabel('closing value')
xlabel('days open')
axis([100 235 1000 2500])
hold off
