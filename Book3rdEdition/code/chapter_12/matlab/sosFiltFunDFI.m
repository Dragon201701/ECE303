function [x, y] = sosFiltFunDFI(x, y, B, A, G);
% [x, y] = sosFiltFunDFI(x, y, B, A, G)
%
% calculate the output for a DF-I second order section
%
% x - input array (three terms)
% y - output array (three terms)
% B - numerator coefficients (three terms)
% A - denominator coefficients (three terms)
% G - filter's gain
%
% by Dr. Thad B. Welch, P.E.
% copyright 2012, written 18 July 2012

% calculate the current output value
y(1) = -A(2)*y(2) - A(3)*y(3) + G*(B(1)*x(1) + B(2)*x(2) + B(3)*x(3));

% prepare for the next input value by updating the storage variables
x(3) = x(2); x(2) = x(1);
y(3) = y(2); y(2) = y(1);