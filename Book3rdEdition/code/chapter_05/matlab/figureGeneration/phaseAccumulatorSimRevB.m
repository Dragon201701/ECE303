%  This m-file is used to demonstrate the phase accumulator-based 
%  sinusoidal signal generation process without using division ...
%  the modulus operator.
%
%  ISR simulation is accomplished using a "for loop".
%  Each ISR call is equivalent to the "for loop" executing the 
%  "for loop" code ONCE.  During the ISR, the algorithm must,
%
%  1. update the value of the phase accumulator
%  2. verify that this new value is between 0 and 2*pi
%  3. calculate the output value
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2003
%  completed on 28 July 2003 ... revision 1.0

% Simulation inputs
A = 32000;                  % signal's amplitude
f = 1000;                   % signal's frequency
phaseAccumulator = 0;       % signal's initial phase
Fs = 48000;                 % system's sample frequency
outputVector = [];          % output storage declaration
numberOfTerms = 50;         % calculate this number of terms

% Calculated and terms
phaseIncrement = 2*pi*f/Fs; % calculate the phase increment

for i = 1:numberOfTerms
    % ISR's algorithm begins here
        phaseAccumulator = phaseAccumulator + phaseIncrement;
        if (phaseAccumulator > 2*pi)
            phaseAccumulator = phaseAccumulator - 2*pi;
        end
        output = A*sin(phaseAccumulator);
    % ISR's algorithm ends here
    outputVector = [outputVector output]; % saving output terms
end

% Output terms
stem(outputVector)
ylabel('signal value')
xlabel('n (samples)')
