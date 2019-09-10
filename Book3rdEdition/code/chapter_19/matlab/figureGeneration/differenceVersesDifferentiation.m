%  This m-file creates a plot that shows the frequency
%  response of the ideal differentiator compared to 
%  a difference based FIR filter
%  
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2005
%  completed on 9 June 2005 revision 1.0
%  last updated on 9 June 2005

% Simulation inputs
diffFilter = [1 0 -1];

S = char('b-', 'm:', 'r-.', 'k--'); % line type control
myFontSize = 16; % font size for the plot labels

% calculations
[H, f] = freqz(diffFilter, 1, 1024, 2);

% Simulation outputs
figure(1)
semilogx(f, 20*log10(abs(H)), 'b:')
hold on
plot([0.001 1], [-50 10] + 6, 'r')
ylabel('|H(j\omega)|')
xlabel('frequency, (\pi normalized units)')
axis([0.001 1 -50 10])
legend('second difference', 'theoretical (scaled)', 'Location', 'NorthWest')
hold off

% P1 = plot(-60:60, B, S(1,:));
% grid
% hold on
% P2 = plot(-60:60, [Bprime(2:121) 0], S(2,:));
% P3 = plot(-60:60, BprimeShifted.*B/max(abs(BprimeShifted.*B)), S(3,:));
% P4 = plot(-60:60, BprimeShifted.*sign(B)/max(abs(BprimeShifted.*sign(B))), S(4,:));
% hold off
% set(gca, 'FontSize', myFontSize);
% set(P1, 'LineWidth', 1.5);
% set(P2, 'LineWidth', 1.5);
% set(P3, 'LineWidth', 1.5);
% set(P4, 'LineWidth', 1.5);
% axis([-60 60 -1.8 1.1])
% legend('raised-cosine (rc) pulse', ...
%     'scaled deriviative of rc pulse, rc''', ...
%     'normalized product of rc and rc''', ...
%     'normalized product of sign(rc) and rc''', ...
%     'Location', 'SouthWest')
% title('')
% ylabel('amplitude')
% xlabel('n (samples)')
% % print -depsc2 ML_timingRecovery
% 
% figure(2)
% P1 = plot(-60:60, B, S(1,:));
% grid
% hold on
% P2 = plot(-60:60, [Bprime(2:121) 0], S(2,:));
% P3 = plot(-60:60, BprimeShifted.*B/max(abs(BprimeShifted.*B)), S(3,:));
% P4 = plot(-60:60, BprimeShifted.*sign(B)/max(abs(BprimeShifted.*sign(B))), S(4,:));
% hold off
% set(gca, 'FontSize', myFontSize);
% set(P1, 'LineWidth', 1.5);
% set(P2, 'LineWidth', 1.5);
% set(P3, 'LineWidth', 1.5);
% set(P4, 'LineWidth', 1.5);
% axis([-20 20 -1.8 1.1])
% legend('raised-cosine (rc) pulse', ...
%     'scaled deriviative of rc pulse, rc''', ...
%     'normalized product of rc and rc''', ...
%     'normalized product of sign(rc) and rc''', ...
%     'Location', 'SouthWest')
% title('')
% ylabel('amplitude')
% xlabel('n (samples)')
% % print -depsc2 ML_timingRecoveryZoomed
