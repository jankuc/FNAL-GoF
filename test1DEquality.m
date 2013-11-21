function [h, p, stat] = test1DEquality(x1, w1, x2, w2, type)
% [h p stat] = test1DEquality(x1, w1, x2, w2, type)
%
%	alpha = 0.01;
%
% types:	kolm-smirn
%			cramer	
%			renyi		a = 0.3
%			tAlpha		a = 2	


alpha = 0.05;

types{1} = 'kolm-smirn';
types{2} = 'cramer';
types{3} = 'wilcoxon';
types{4} = 'wGMWW';

if strcmp(type,types{1})
	[h, p, stat] = test_wKS2(x1, w1, x2, w2, alpha);
elseif strcmp(type,types{2})
    [h, p, stat] = test_wCM2(x1, w1, x2, w2, alpha);
elseif strcmp(type, types{3})
	[p,h, stats] = ranksum(x1,x2,'alpha',alpha);
	stat = stats.zval;
elseif strcmp(type, types{4})
	[p, h, stat] = test_wGMWW(x1, w1, x2, w2, alpha);
% elseif strcmp(type,'renyi')
% 	a = 0.3; %/ Renyi parameter
%     [h, p, stat] = test_wRen2(x1, w1, x2, w2, a, alpha);
% elseif strcmp(type,'tAlpha')
% 	a = 2; % T_alpha parameter
% 	[h, p, stat] = test_wTAlpha2(x1, w1, x2, w2, a, alpha);
else
	error('Wrong type of test.')
end
