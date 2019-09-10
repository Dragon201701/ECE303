function [xLeft, yLeft] = funFilter(xLeft, B, N)

% initializes the output value
yLeft = single(0.0);            

% performs the dot product of B and x
for i = 1:N+1               
    yLeft = yLeft + B(i)*xLeft(i);
end

% shift the stored x samples to the right
for i = N:-1:1              
    xLeft(i+1) = xLeft(i);
end
