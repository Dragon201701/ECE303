function [output] = pngen(r, k)
%  This m-file generates PN codes for the PN sequence
%  portion of the signal generation chapter.
%
%  PN code generation program
%
%  Generates one period of the SSRG single feedback tap 
%  [r,k]s PN sequence 
%
%  Can be used to provide input to pn_corr or pn_spec
%
%  written by Dr. Thad B. Welch, PE {t.b.welch@ieee.org}
%  modified by Cameron H.G. Wright
%  copyright (c) 2011 Thad B. Welch


N = 2^r - 1; % assumes your feedback taps result in an m-sequence
output = zeros(1, N);  % preallocate the output array
shift_reg = ones(1, r);  % preallocate the SRG array, fill with 1's

% perform one cycle of code generation
for i = 1:N
   output(i) = shift_reg(r);
   feedback = xor(shift_reg(r), shift_reg(k));
   % perform brute force shift
   shift_reg(2:r) = shift_reg(1:r-1);
   shift_reg(1) = feedback;
end
