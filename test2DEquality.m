function [h, p, stat] = test2DEquality(mcVar, exVar, type)
% [h p stat] = test1DEquality(mcVar, exVar, type)
%
% types:	kolm-smirn
%						

alpha = 0.01;

if strcmp(type,'kolm-smirn-2D')
	[h, p, stat] = kstest_2s_2d(mcVar, exVar, alpha);
else
	error('Wrong type of test.')
end