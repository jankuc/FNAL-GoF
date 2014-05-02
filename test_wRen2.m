function [H, pValue, stat] = test_wRen2(x1,x2, w1,w2, a, pdfEstType, nbin, ...
                                        aa, bb, varargin)
% 
% [H, pValue, stat] = test_wRen2(x1, x2, w1, w2, a, pdfEstType, nbin, aa, bb, varargin)
%
%
% a             renyi alpha
% pdfEstType    'hist'/'kernel'
%
% HISTOGRAM
% nbin          number of bins
% aa             start of first bin 
% bb             end of last bin
%
% KERNEL
% nbin          number of evaluation points for kernel
% aa            start of first bin 
% bb             end of last bin
%
%
% Varargin
% kernelType    type of kernel. See also ksdensity.
% width         width of kernel. See also ksdensity.
%
% alpha         test significance level - NOT SUPPORTED due to
%                         lack of theory for testing
%
%   See also test_wKS2, test_wCM2, ksdensity, histwc.


%
%% Calculate f1(x) and f2(x), the empirical (i.e., sample) PDFs.
%
switch pdfEstType
  case 'hist'
    [ePDF1, ~] = histwc(x1, w1, nbin, aa, bb);
    [ePDF2, ~] = histwc(x2, w2, nbin, aa, bb);
  case 'kernel'
    % define shared x
    [x1, w1] = reweightDataToInterval(x1, w1, aa, bb);
    [x2, w2] = reweightDataToInterval(x2, w2, aa, bb);
    x = aa : (bb-aa)/nbin : bb;
    % nbin is already specified in x
    if ~isempty(varargin)
      [ePDF1] = ksdensity(x1, x, 'kernel', varargin{1},...
                            'width', varargin{2}, 'weights', w1);
      [ePDF2] = ksdensity(x2, x, 'kernel', varargin{1},...
                            'width', varargin{2}, 'weights', w2);
    else
      [ePDF1] = ksdensity(x1, x,'kernel','epanechnikov', 'weights', w1);
      [ePDF2] = ksdensity(x2, x,'kernel','epanechnikov', 'weights', w2);
    end
end
ePDF1(ePDF1<=0) = 1e-8;
ePDF2(ePDF2<=0) = 1e-8;
ePDF1 = ePDF1/sum(ePDF1);
ePDF2 = ePDF2/sum(ePDF2);

%
% Compute the test statistic of interest.
%

if ~prod(double(ePDF1 > 0 & ePDF2 > 0))
	error('Histogram is not possitive.')
end
k = length(ePDF1);
doubleSum = sum((ePDF1.^a) .* (ePDF2.^(1-a)));
logOfSum = log(doubleSum);
const =1/(a*(a-1)); 
stat = const * logOfSum;
H = nan;
pValue = nan;
