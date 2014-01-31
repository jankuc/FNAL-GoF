function nbin = getHistogramNBin(X,type)
%
% n = getHistogramNBin(X/n, type)
%
% X/n   n   for most formulas, it is sufficient to provide n ... amount of data.
%       X   for Doane's formula, it is needed to provide X for computing
%           skewness of data.
%
% type      'sqrt'            nbin = sqrt(n)
%           'rice'            nbin = 2*n^(1/3)
%           'sturge'             nbin = log2(n) + 1
%           'doane'           nbin = 
%
%

if isscalar(X)
  n = X;
else
  n = length(X);
end

switch type
  case 'sqrt'
    nbin = sqrt(n);
  case 'rice'
    nbin = ceil(2*n.^(1/3));
  case 'sturge'
    nbin = ceil(log2(n) + 1);
  case 'doane'
    g1 = skewness(X);
    s1 = sqrt(6*(n-2)./(n+1)./(n+3));
    nbin = ceil(1 + log2(n) + log2(1 + abs(g1)./s1)); 
  case 'scott'
    w = 3.49*std(X);
    nbin = ceil( (max(X)-min(X))/w * n^(1/3) );
end
