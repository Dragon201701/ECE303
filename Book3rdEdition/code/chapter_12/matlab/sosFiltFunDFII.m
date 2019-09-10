function [w, y] = sosFiltFunDFII(w, x, B, A, G);
% [w, y] = sosFiltFunDFII(w, x, B, A, G)
%
% calculate the output for a DF-II second order section
%
% input arguments ...
% w - state of the filter
% x - input (one value)
% B - numerator coefficients (three terms)
% A - denominator coefficients (three terms)
% G - filter's gain
%
% output arguments ...
% w - updated state of the filter
% y - output (one value)
%
% by Dr. Thad B. Welch, P.E.
% copyright 2012, written 6 August 2012

% calculate the current output value
w(1) = x - A(2)*w(2) - A(3)*w(3);
y = G*(B(1)*w(1) + B(2)*w(2) + B(3)*w(3));

% prepare for the next input value by updating the storage variables
w(3) = w(2); w(2) = w(1);