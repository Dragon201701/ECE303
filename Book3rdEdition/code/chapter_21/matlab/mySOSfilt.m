function [w, ySOSfilter] = mySOSfilt(SOS, gain, w, index, x, ySOSfilter)
% SOS filter routine
%
% by Dr. T.B. Welch, PE
% written on 10 February 2010

% calculations
    w(1,1) = gain*x - SOS(1,5)*w(1,2) - SOS(1,6)*w(1,3);
    output = SOS(1,1)*w(1,1) + SOS(1,2)*w(1,2) + SOS(1,3)*w(1,3);
    w(1,3) = w(1,2);
    w(1,2) = w(1,1);
    
    w(2,1) = output - SOS(2,5)*w(2,2) - SOS(2,6)*w(2,3);
    output = SOS(2,1)*w(2,1) + SOS(2,2)*w(2,2) + SOS(2,3)*w(2,3);
    w(2,3) = w(2,2);
    w(2,2) = w(2,1);
    
    w(3,1) = output - SOS(3,5)*w(3,2) - SOS(3,6)*w(3,3);
    output = SOS(3,1)*w(3,1) + SOS(3,2)*w(3,2) + SOS(3,3)*w(3,3);
    w(3,3) = w(3,2);
    w(3,2) = w(3,1);

    w(4,1) = output - SOS(4,5)*w(4,2) - SOS(4,6)*w(4,3);
    ySOSfilter(index) = ...
        SOS(4,1)*w(4,1) + SOS(4,2)*w(4,2) + SOS(4,3)*w(4,3);
    w(4,3) = w(4,2);
    w(4,2) = w(4,1);
