function []=q_zpln_b(b1,a1,b2,a2,p1,p2);
% Q_ZPLN_B Z-plane zero-pole plot comparison.
% Q_ZPLN_B(B1,A1,B2,A2,P1,P2) finds the roots of all the arguments
% with ROOTS.  So Q_ZPLN_B(B1,A1,B2,A2,P1,P2), where the B's and A's are 
% row vectors containing the transfer function polynomial 
% coefficients for two different transfer functions, plots the 
% poles and zeros of B(z)/A(z) for both on the same plot.
%
% See also ZPLANE, FREQZ.
%
% Last revision: 9 July 98
%
% Copyright (c) 7 December 1997, 1998 by 
%
% Thad B. Welch (t.b.welch@ieee.org) and
% Cameron H. G. Wright (wrightch.dfee.usafa@usafa.af.mil)

z1 = roots(b1); 
z2 = roots(b2);

% setup for axis scaling ... with a slight zoom out

largest=max([max(abs([z1])) max(abs([p1])) max(abs([z2])) max(abs([p2]))]);
scale=ceil(11*largest)/10; 
actual_scale=max([scale 1]);
cla;

if ~any(imag(z1)),
  z1= z1+ j*1e-50;
end;

if ~any(imag(p1)),
  p1= p1+ j*1e-50;
end;

if ~any(imag(z2)),
  z2= z2+ j*1e-50;
end;

if ~any(imag(p2)),
  p2= p2+ j*1e-50;
end;

plot([0],[0],'w')
hold on;
plot([-actual_scale actual_scale],[0 0],'k:');
plot([0 0],[-actual_scale actual_scale],'k:');
axis square
axis([-actual_scale actual_scale -actual_scale actual_scale])

if ~isempty(z1),
  zh = plot(z1,'bo','markersize',8); 
else
  zh = []; 
end

if ~isempty(p1),
  ph = plot(p1,'bx','markersize',8); 
else
  ph = []; 
end

if ~isempty(z2),
  zh = plot(z2,'ro','markersize',12); 
else
  zh = []; 
end

if ~isempty(p2),
  ph = plot(p2,'rx','markersize',12); 
else
  ph = []; 
end

theta = linspace(0,2*pi,10000);
plot(cos(theta),sin(theta),'k:');
xlabel('Real part')
ylabel('Imaginary part')
hold off
