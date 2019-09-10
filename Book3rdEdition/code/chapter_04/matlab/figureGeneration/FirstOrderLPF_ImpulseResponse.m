%  This m-file is used to generate a figure that is used in the 
%  sample-based FIR filter chapter of our DSP text.
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2001, 2016
%  completed on  12 December 2001 revision 1.0

% Simulation inputs
R = 1000;           % resistor value (1000 Ohms)
C = 1e-6;           % capacitor value (1 microFarad)
StopTime1 = 10e-3;  % simulation time ... 0 to 10 ms
StopTime2 = 0.5;    % simulation time ... 0 to 1 s
delta = 1e-6;       % delta time for the simulation
myFontSize = 16;    % font size for the plot labels

% Calculated terms
t1 = 0:delta:StopTime1;
t2 = 0:delta*StopTime2/StopTime1:StopTime2;
h1 = 1/R/C*exp(-1/R/C*t1);
h2 = 1/R/C*exp(-1/R/C*t2);

%Simulation outputs
figure(1)
plot(t1, h1)
%set(gca, 'FontSize', myFontSize)
ylabel('output (V)')
xlabel('time (s)')
%print -deps2 FirstOrderLPF_ImpulseResponse

figure(2)
semilogy(t2, h2)
%set(gca, 'FontSize', myFontSize)
ylabel('output (V)')
xlabel('time (s)')
%print -f1 -depsc2 FirstOrderLPF_ImpulseResponseLogPlot
