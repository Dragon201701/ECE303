%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ This m-file is used to demonstrate the table lookup method 
%/ of sinusoidal signal generation.  All output is to the 
%/ MATLAB command window.
%/
%/ ISR simulation is accomplished using a "for loop".
%/ The ISR call is equivalent to the "for loop" executing the 
%/ "for loop" code ONCE.  During the ISR, the algorithm must,
%/
%/ 1. increment the index value
%/ 2. keep the index value between 1 and N
%/ 3. lookup the next output value
%/
%//////////////////////////////////////////////////////////////////////

% Simulation inputs
signal = [32000 0 -32000 0]; % cosine signal values (Fs/4 case)
index = 1;                   % used to lookup the signal value
numberOfTerms = 20;          % calculate this number of terms

% Calculated and output terms
N = length(signal);          % signal period

for i = 1:numberOfTerms
    % ISR's algorithm begins here
        if (index >= (N + 1))
            index = 1;
        end
        output = signal(index)
        index = index + 1;
    % ISR's algorithm ends here
end
