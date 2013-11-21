function [H, pValue, stat] = test_wRen2(x1, w1, x2, w2, a, varargin)
%	wRenTest2 Two-sample Renyi goodness-of-fit hypothesis test.
%   H = test_wRen2(X1,w1,X2,w2) performs a Kolmogorov-Smirnov (K-S) test
%   to determine if independent random samples, X1 and X2, are drawn from
%   the same underlying continuous population. H indicates the result of
%   the hypothesis.
%	a ... parametere for Renyi divergence
%
%   test:
%      H = 0 => Do not reject the null hypothesis at the 5% significance level.
%      H = 1 => Reject the null hypothesis at the 5% significance level.
%
%   Let S1(x) and S2(x) be the empirical distribution functions from the
%   sample vectors X1 and X2, respectively, and F1(x) and F2(x) be the
%   corresponding true (but unknown) population CDFs. The two-sample K-S
%   test tests the null hypothesis that F1(x) = F2(x) for all x, against the
%   alternative that they are unequal.
%
%   The decision to reject the null hypothesis occurs when the significance
%   level equals or exceeds the P-value.
%
%   X1 and X2 are vectors of lengths N1 and N2, respectively, and represent
%   random samples from some underlying distribution(s). Missing
%   observations, indicated by NaNs (Not-a-Number), are ignored.
%
%   [H,P] = KSTEST2(...) also returns the asymptotic P-value P.
%
%   [H,P,KSSTAT] = KSTEST2(...) also returns the K-S test statistic KSSTAT
%   defined above for the test type indicated by TYPE.
%
%   The asymptotic P-value becomes very accurate for large sample sizes, and
%   is believed to be reasonably accurate for sample sizes N1 and N2 such
%   that (N1*N2)/(N1 + N2) >= 4.
%
%   [...] = KSTEST2(X,Y,'PARAM1',val1,'PARAM2',val2,...) specifies one or
%   more of the following name/value pairs:
%
%       Parameter       Value
%       'alpha'         A value ALPHA between 0 and 1 specifying the
%                       significance level. Default is 0.05 for 5% significance.
%       'type'          A string indicating the type of test:
%          'unequal' -- "F1(x) not equal to F2(x)" (two-sided test) (Default)
%          'larger'  -- "F1(x) > F2(x)" (one-sided test)
%          'smaller' -- "F1(x) < F2(x)" (one-sided test)
%       For TYPE = 'unequal', 'larger', and 'smaller', the test statistics are
%       max|S1(x) - S2(x)|, max[S1(x) - S2(x)], and max[S2(x) - S1(x)],
%       respectively.
%
%   See also KSTEST, LILLIETEST, CDFPLOT.
%

% Copyright 1993-2012 The MathWorks, Inc.


% References:
%   Massey, F.J., (1951) "The Kolmogorov-Smirnov Test for Goodness of Fit",
%         Journal of the American Statistical Association, 46(253):68-78.
%   Miller, L.H., (1956) "Table of Percentage Points of Kolmogorov Statistics",
%         Journal of the American Statistical Association, 51(273):111-121.
%   Stephens, M.A., (1970) "Use of the Kolmogorov-Smirnov, Cramer-Von Mises and
%         Related Statistics Without Extensive Tables", Journal of the Royal
%         Statistical Society. Series B, 32(1):115-122.
%   Conover, W.J., (1980) Practical Nonparametric Statistics, Wiley.
%   Press, W.H., et. al., (1992) Numerical Recipes in C, Cambridge Univ. Press.

if nargin < 2
	error(message('stats:kstest2:TooFewInputs'));
end

% Parse optional inputs
alpha = []; tail = [];
if nargin >=6
	if isnumeric(varargin{1})
		% Old syntax
		alpha = varargin{1};
		if nargin == 7
			tail = varargin{2};
		end
		
	else
		% New syntax
		params = {'alpha', 'tail'};
		dflts =  { []     , []};
		
		[alpha, tail] =...
			internal.stats.parseArgs(params, dflts, varargin{:});
	end
end


%
% Ensure each sample is a VECTOR.
%

if ~isvector(x1) || ~isvector(x2)
	error(message('stats:kstest2:VectorRequired'));
end

%
% Remove missing observations indicated by NaN's, and
% ensure that valid observations remain.
%

x1  =  x1(~isnan(x1));
x2  =  x2(~isnan(x2));
x1  =  x1(:);
x2  =  x2(:);

if isempty(x1)
	error(message('stats:kstest2:NotEnoughData', 'X1'));
end

if isempty(x2)
	error(message('stats:kstest2:NotEnoughData', 'X2'));
end

%
% Ensure the significance level, ALPHA, is a scalar
% between 0 and 1 and set default if necessary.
%

if ~isempty(alpha)
	if ~isscalar(alpha) || (alpha <= 0 || alpha >= 1)
		error(message('stats:kstest2:BadAlpha'));
	end
else
	alpha  =  0.05;
end

%
% Calculate f1(x) and f2(x), the empirical (i.e., sample) PDFs.
%

x = sort(union(x1,x2));

n1 = length(x1);
n2 = length(x2);
%n = ceil(n1 * n2 /(n1 + n2));
%n = ceil(mean([n1, n2])); % number of bins for histogram
n = min(n1,n2);
[ePDF1, xNew1] = wEPDF(x1,w1,x,n);
[ePDF2, xNew2] = wEPDF(x2,w2,x,n);



if sum(xNew1 ~= xNew2) > 0
	error('wEPDF does not function properly.');
end




%
% Compute the test statistic of interest.
%

if ~prod(double(ePDF1 > 0 & ePDF2 > 0))
	error('Histogram is not possitive.')
end
k = length(ePDF1);
doubleSum = sum((ePDF1.^a) .* (ePDF2.^(1-a)));
logOfSum = log(doubleSum);
const =2*n/(a*(a-1)); 
stat = const * logOfSum;

chiQuant1 = icdf('chi2', alpha/2, k - 1);
chiQuant2 = icdf('chi2',1 - alpha/2, k - 1);

%
% Compute the asymptotic P-value approximation and accept or
% reject the null hypothesis on the basis of the P-value.
%

lambda =  max((sqrt(n) + 0.12 + 0.11/sqrt(n)) * stat , 0);

    % 2-sided test (default).
	%
	%  Use the asymptotic Q-function to approximate the 2-sided P-value.
	%
	j       =  (1:101)';
	pValue  =  2 * sum((-1).^(j-1).*exp(-2*lambda*lambda*j.^2));
	pValue  =  min(max(pValue, 0), 1);
	
H  =  (alpha >= pValue);
