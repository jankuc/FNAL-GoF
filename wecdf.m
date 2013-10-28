function [ f ] = wecdf( data, w, dataNew )
%	[ f ] = wecdf( data, w, dataNew )
%
%	Uses  intepStairs

[ff, xx] = ecdf(data,'frequency',w);

f = interpStairs(xx,ff,dataNew);

end

