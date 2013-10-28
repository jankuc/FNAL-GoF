function [h, p, stat] = test1DEquality(x1, w1, x2, w2, type)
% [h p stat] = test1DEquality(mcVar, exVar, type)
%
% types:	kolm-smirn
%			cramer	
%						


alpha = 0.01;

if strcmp(type,'kolm-smirn')
	[h, p, stat] = wkstest2(x1, w1, x2, w2, alpha);
elseif strcmp(type,'cramer')
    [h, p, stat] = wcmtest2(x1, w1, x2, w2, alpha);
else
	error('Wrong type of test.')
end