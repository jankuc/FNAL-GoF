function [h, p, stat] = test1DEquality(x1, w1, x2, w2, type, varargin)
% [h p stat] = test1DEquality(x1, w1, x2, w2, type, varargin)
%
%	alpha = 0.01;
%
% varargin has one element, which is cell of other parameters. So not usual
% calling (..., a, b, c), but (...,{a, b, c})
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
      if isnumeric(varargin{1})
        alpha = varargin{1};
      else
        alpha = varargin{1}{1};
      end
    end
    [h, p, stat] = test_wKS2(x1, w1, x2, w2, alpha);
  case 'ren-kolm-smirn'
    if nargin > 5
      if isnumeric(varargin{1})
        alpha = varargin{1};
      else
        alpha = varargin{1}{1};
      end
    end
    [h, p, stat] = test_wRKS2(x1, w1, x2, w2, alpha);
  case 'cramer'
    %% Cramer von Mises
    if nargin > 5
      if isnumeric(varargin{1})
        alpha = varargin{1};
      else
        alpha = varargin{1}{1};
      end
    end
    [h, p, stat] = test_wCM2(x1, w1, x2, w2, alpha);
   case  'anderson-darling'
    %% Anderson-Darling
    if nargin > 5
      if isnumeric(varargin{1})
        alpha = varargin{1};
      else
        alpha = varargin{1}{1};
      end
    end
    [h, p, stat] = test_wAD2(x1, w1, x2, w2, alpha);
  case 'renyi'
    %% Renyi
%     a = pars{1}; % Renyi alpha
%     pdfEstType = pars{2};
%     nbin = pars{3};
%     aa .... 4
%     bb ... 5
%     par1 = pars{6}; kernelType...ksdensity
%     par2 = pars{7}; width...ksdensity
    pars = varargin;
    par = pars{1};
    if length(pars) > 5
    [h, p, stat] = ...
      test_wRen2(x1,x2, w1,w2, pars{1}, pars{2}, pars{3},...
      pars{4}, pars{5},pars{6}, pars{7});
    else
      if length(pars) < 5
        pars = pars{1};
      end  
      [h, p, stat] = ...
      test_wRen2(x1,x2, w1,w2, pars{1}, pars{2}, pars{3},...
      pars{4}, pars{5});        
    end
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
