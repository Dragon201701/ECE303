function [s1,s2,p1,p2]=stable(b1,a1,b2,a2);
% stable returns the flags s1,s2 to report stability. If all 
% poles lie in side the unit circle, then sn=1. Else sn=0.
%
% See also ZPLANE, Q_ZPLN_A, FREQZ.
%
% Last revision: 9 July 1998
%
% Copyright (c) 7 December 1997, 1998 by
%
% Thad B. Welch (t.b.welch@ieee.org) and
% Cameron H. G. Wright (wrightch.dfee.usafa@usafa.af.mil)

s1=1;
s2=1;
p1 = roots(a1);
p2 = roots(a2);

% check for unstable condition

if max(abs(p1))>=1
  s1=0;
end;

if max(abs(p2))>=1
  s2=0;
end;
