function [h, p, stat] = test1DEquality(x1, w1, x2, w2, type, varargin)
% [h p stat] = test1DEquality(x1, w1, x2, w2, type, varargin)
%
%	alpha = 0.01;
%
% types:	kolm-smirn
%         cramer
%         ranksumsss
%         kstest2
%         renyi
%             a             parameter of robustness
%             pdfEstType    'hist' / 'kernel'
%             nbin          number of bins
%             aa            start of the  interval
%             bb            end of the  interval
%             optional (ksdensity)
%               kernelType
%               kernelWidth
%             

w1 = w1(~isnan(x1));
x1 = x1(~isnan(x1));

w2 = w2(~isnan(x2));
x2 = x2(~isnan(x2));

alpha = 0.01;

W_KOLM_SMIRN= 'kolm-smirn';
W_CRAMER = 'cramer';
W_RENYI = 'renyi';
WILCOXON = 'ranksum';
W_WILCOXON= 'wwilcoxon';
KOLM_SMIRN = 'kstest2';


switch type
  case 'kolm-smirn'
    if nargin > 5
      alpha = varargin{1};
    end
    [h, p, stat] = test_wKS2(x1, w1, x2, w2, alpha);
  case 'cramer'
    %% Cramer von Mises
    if nargin > 5
      alpha = varargin{1};
    end
    [h, p, stat] = test_wCM2(x1, w1, x2, w2, alpha);
  case 'renyi'
    %% Renyi
%     a = varargin{1}; % Renyi alpha
%     pdfEstType = varargin{2};
%     nbin = varargin{3};
%     aa .... 4
 %    bb ... 5
%     par1 = varargin{6}; kernelType...ksdensity
%     par2 = varargin{7}; width...ksdensity
    if length(varargin) > 5
    [h, p, stat] = ...
      test_wRen2(x1,x2, w1,w2, varargin{1}, varargin{2}, varargin{3},...
      varargin{4}, varargin{5},varargin{6}, varargin{7});
    else
      [h, p, stat] = ...
      test_wRen2(x1,x2, w1,w2, varargin{1}, varargin{2}, varargin{3},...
      varargin{4}, varargin{5});
    end
    
    % elseif strcmp(type,'renyi')
    % 	a = 0.3; %/ Renyi parameter
    %     [h, p, stat] = test_wRen2(x1, w1, x2, w2, a, alpha);
    % elseif strcmp(type,'tAlpha')
    % 	a = 2; % T_alpha parameter
    % 	[h, p, stat] = test_wTAlpha2(x1, w1, x2, w2, a, alpha);
  case 'ranksum'
    %% Wilcoxon - not weighted !!!
    [p,h, stats] = ranksum(x1,x2,'alpha',alpha);
    stat = stats.zval;
  case 'wwilcoxon'
    %% Weighted generalisation of Wilcoxon
    [p, h, stat] = test_wGMWW(x1, w1, x2, w2, alpha);
  case 'kstest2'
    %% Kolmogorov-Smirnov - not weighted
    [h, p, stat] = kstest2(x1,x2, alpha);
  otherwise
    error('Wrong type of test.')
end
