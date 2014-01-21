function [h, p, stat] = test1DEquality(x1, w1, x2, w2, type, varargin)
% [h p stat] = test1DEquality(x1, w1, x2, w2, type)
%
%	alpha = 0.01;
%
% types:	kolm-smirn
%         cramer
%         ranksum
%         kstest2
%         renyi		
%           followed by:
%             a ... parameter of robustness
%             nbin ... number of bins for histogram
%             aa ... start of the histogram interval 
%             bb ... end of the histogram interval 
%			tAlpha		a = 2

w1 = w1(~isnan(x1));
x1 = x1(~isnan(x1));

w2 = w2(~isnan(x2));
x2 = x2(~isnan(x2));

alpha = 0.05;

types{1} = 'kolm-smirn';
types{2} = 'cramer';
types{3} = 'ranksum';
types{4} = 'wwilcoxon';
types{5} = 'kstest2';
types{6} = 'renyi';

if strcmp(type,types{1})
  [h, p, stat] = test_wKS2(x1, w1, x2, w2, alpha);
elseif strcmp(type,types{2})
  [h, p, stat] = test_wCM2(x1, w1, x2, w2, alpha);
elseif strcmp(type, types{3})
  [p,h, stats] = ranksum(x1,x2,'alpha',alpha);
  stat = stats.zval;
elseif strcmp(type, types{4})
  [p, h, stat] = test_wGMWW(x1, w1, x2, w2, alpha);
elseif strcmp(type, types{5})
  [h, p, stat] = kstest2(x1,x2, alpha);
elseif strcmp(type, types{6})
  a = varargin{1};
  nbin = varargin{2};
  aa = varargin{3};
  bb = varargin{4};
  [h, p, stat] = test_wRen2(x1,x2, w1,w2, a, nbin, aa, bb,  'alpha',alpha);
  % elseif strcmp(type,'renyi')
  % 	a = 0.3; %/ Renyi parameter
  %     [h, p, stat] = test_wRen2(x1, w1, x2, w2, a, alpha);
  % elseif strcmp(type,'tAlpha')
  % 	a = 2; % T_alpha parameter
  % 	[h, p, stat] = test_wTAlpha2(x1, w1, x2, w2, a, alpha);
else
  error('Wrong type of test.')
end
