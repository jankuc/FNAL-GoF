function [ f ] = wECDF( data, w, dataNew )
%	[ f ] = wECDF( data, w, dataNew )
%	
%	Returns weighted empirical cumulative ditribution function.
%
%	dataNew ... has to be sorted (from MIN to MAX) array.
%				the following must be true: 
%					dataNew(1) >= min(data)  &&  dataNew(end) <= max(data)
%	f ... column vector
%	Uses  intepStairs

% ensure dataNew is column vector:
dataNew = dataNew(:);

[ff, xx] = ecdf(data,'frequency',w);

f = interpStairs(xx,ff,dataNew);

end

