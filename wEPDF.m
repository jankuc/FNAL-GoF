function [f, xNew ] = wEPDF(data, w, dataNew, n)
%	[ f, xNew ] = wEPDF( data, w, dataNew, n)
%
%	returns weighted empirical distrbution function (histogram)
%
%	w ...	weights of data	
%	dataNew ...	has to be sorted (from MIN to MAX) array.
%				the following must be true: 
%					dataNew(1) >= min(data)  &&  dataNew(end) <= max(data)
%				usually dataNew = union(x1, x2)
%				used for wECDF and determining quntiles for uniformPoints
%	n ...	size of data for uniformPoints 
%			n = ceil(mean([length(x1), lenght(x2)]))
%
%	f ...	column vector of histogram counts with bin centers xNew
%   xNew ... bin centers
%	Uses  intepStairs
%
%   for better performance use uniformly distributed data points

eCDF = wECDF(data, w, dataNew);
q = 0.0015;
xNew = uniformPoints(n, q, dataNew);
f = ecdfhist(eCDF, dataNew, xNew);
f = f./sum(f);
%% following is old try to implement histogram 
%
% eCDFPlus = [eCDF; 1; 1];
% eCDFMinus = [0; 0; eCDF];
% 
% xMedianDelta = median([dataNew; inf] - [-inf; dataNew]);
% 
% xPlus = [dataNew; dataNew(end) + xMedianDelta; rand(1)];
% xMinus = [rand(1); dataNew(1) - xMedianDelta; dataNew];
% 
% 
% 
% f = (eCDFPlus - eCDFMinus);
% x = (xPlus - xMinus);
% f = f(2:end-1) ./ x(2:end-1);

end

