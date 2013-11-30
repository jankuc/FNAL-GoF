function [h, p, stat] = test2DEquality(x1, w1, x2, w2, type)
% [h p stat] = test1DEquality(mcVar, exVar, type)
%
% types:	kolm-smirn-2D
%

alpha = 0.05;

if strcmp(type,'kolm-smirn-2D')
  [h, p, stat] = test_wKS2s2d(x1, w1, x2, w2, alpha);
else
  error('Wrong type of test.')
end