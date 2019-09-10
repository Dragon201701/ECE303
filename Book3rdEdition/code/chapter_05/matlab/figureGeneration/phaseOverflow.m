%  This m-file is used to demonstrate the effects of 
%  successive addition using finite precision
%  arithmetic.
%
%   max n              result       execution time
%  _______             ______       ______________
%  1000000 .......... +/- 1.0 ....... 0.06 seconds
%  10000000 ......... +/- 1.0 ....... 0.50 seconds
%  100000000 ........ +/- 0.965 ..... 5.05 seconds
%  1000000000 ....... +/- 0.625 .... 49.65 seconds
%  10000000000 ...... +/- 0.238 ... 108.26 seconds
%  100000000000 ..... +/- 0.238 ... 108.20 seconds
%  1000000000000 .... +/- 0.238 ... 107.16 seconds
%  10000000000000 ... +/- 0.238 ... 106.77 seconds
%
%  actual max n = 2.147483647000000e+009 = 2^31 - 1
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  copyright 2003, completed on 8 July 2003 revision 1.0

% Simulation inputs
temp = 0;
result = [];

% Calculated terms
tic
% for n = 1:10000000000000
for n = 1:1000000000
    temp = temp + pi;
end
toc
n

for k = 1:10
    temp = temp + pi;
    result = [result temp];
end
k
n + k

% Simulation outputs
plot(cos(result))