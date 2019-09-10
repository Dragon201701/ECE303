function [output] = pngen2(fb)
%  This m-file generates PN codes for the PN sequence
%  portion of the signal generation chapter.
%
%  PN code generation program
%
%  Generates one period of the SSRG [r,k]s PN sequence 
%  where more than one feedback tap is allowed.
%  Input is row vector fb that is in the SSRG format 
%  of Dixon.  That is, for a 5-stage SSRG with feedback taps from 
%  stages 4, 2, and 1, then fb=[5,4,2,1] with or without commas
%
%  Can be used to provide input to pn_corr or pn_spec
%
%  Based partly on the "pngen" program written by Thad B. Welch
%  copyright (c) 2011 Cameron H. G. Wright


r = fb(1);  % number of stages in SRG

N = 2^r - 1; % assumes your feedback taps result in an m-sequence
output = zeros(1, N);  % preallocate the output array
shift_reg = ones(1, r);  % preallocate the SRG array, fill with 1's

ntaps=length(fb);

if ntaps < 2
    error('Input argument is incorrect.  Type "help pngen2" ')
end

% perform one cycle of code generation
for i = 1:N
    output(i) = shift_reg(r);
    if (ntaps > 2) % multiple feedback taps
        feedback = shift_reg(fb(2));
        for j = 3:ntaps
            feedback = xor(shift_reg(fb(j)), feedback);
        end
        feedback = xor(shift_reg(r), feedback);
    else  % only one feeback tap
        feedback = xor(shift_reg(r), shift_reg(fb(2)));
    end
    % perform brute force shift
    shift_reg(2:r) = shift_reg(1:r-1);
    shift_reg(1) = feedback;
end
