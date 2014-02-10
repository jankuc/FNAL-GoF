function [Hyp, pval, AkN] = test_wAD2(x1, w1, x2, w2, varargin)
% 
% [H, pValue, stat] = test_wRen2(x1, x2, w1, w2, varargin)
%
% Varargin
% alpha         test significance level - NOT SUPPORTED due to
%                         lack of theory for testing
%
%   See also test_wKS2, test_wCM2

if nargin < 4
	error('stats:test_wAD2:TooFewInputs','At least 4 inputs are required.');
end

if nargin > 4
  alpha = varargin{1};
else
  alpha = 0.05;
end


% Calculate F1(x) and F2(x), the empirical (i.e., sample) CDFs.

x  = sort(union(x1,x2));
F1 = wECDF(x1,w1,x);
F2 = wECDF(x2,w2,x);
n1 = length(x1);
n2 = length(x2);
N  = (n1 + n2);
H  = (n2*F1 + n1*F2)/N;

% we have to filter out H==0, H==1. Integrands with these values are 0. See
% (K-Sample Anderson-Darling Tests of Fit, for Continuous and Discrete Cases}

nonZeroes = 0<H & H<1;
H  = H(nonZeroes);
F1 = F1(nonZeroes); 
F2 = F2(nonZeroes); 

% Compute the test statistic of interest.

AkN = sum( n1*n2/N * (F1 - F2).^2 ./(H.*(1-H))) / N;

k = 2;
H = 1/n1 + 1/n2;
h = sum(1./(1:N-1));
if N < 2500
  g = 0;
  for i = 1:(N-2)
    for j = (i+1):(N-1)
      g = g + 1/(N-i)/j;
    end
  end
else
  g = pi^2/6;
end

a =  (4*g - 6)*k + (10 - 6*g)*H - 4*g + 6; 
b = (2*g - 4)*k^2 + 8*h*k + (2*g - 14*h - 4)*H - 8*h + 4*g - 6;
c = (6*h + 2*g - 2)*k^2 + (4*h - 4*g + 6)*k + (2*h - 6)*H + 4*h;
d = (2*h + 6)*k^2 - 4*h*k;
sigmaN = (a*N^3 + b*N^2 + c*N + d*N)/((N-1)*(N-2)*(N-3));


%  z = [.326 1.225 1.960 2.719 3.752;...
%    .449 1.309 1.945 2.576 3.414;...
%    .498 1.324 1.915 2.493 3.246;...
%    .525 1.329 1.894 2.438 3.139;...
%    .557 1.332 1.859 2.365 3.005;...
%    .576 1.330 1.839 2.318 2.920;...
%    .590 1.329 1.823 2.284 2.862;...
%    .674 1.282 1.645 1.960 2.326]
%m = [1, 2, 3, 4, 6, 8, 10, inf];
%
% where m = k-1. In our problem, we have m = 1;
% According to previous table, we fitted exponential to the first line of table
% z, which corresponds to m==1.
%

percentiles = [.75 .90 .95 .975 .99];
z = [.326 1.225 1.960 2.719 3.752];
zk = z(percentiles==(1-alpha));

% if alpha isnt one of predefined values, we have to interpolate z and estimate
% the right value.
if isempty(z) 
  a = 5.754e-19;
  b = 42.8;
  c = 0.001266;
  d = 7.568;
  zk = a*exp(b*(1-alpha)) + c*exp(d*(1-alpha));
end

% pval from inverse function
a =      0.9791;
b =    0.004313;
c =     -0.3317;
d =      -1.117;
pval = a*exp(b*(1-AkN)) + c*exp(d*(1-AkN));


Hyp =  (AkN - 1)/sigmaN >= zk;

