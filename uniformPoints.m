function [ xNew ] = uniformXPoints(n, q, data)
%	[ xNew ] = uniformXPoints(n, q, data)
%
%	n ...	size of data for uniformPoints 
%			n = ceil(mean([length(x1), lenght(x2)]))
%	data ...data from which we'll count q-quantiles and therefore starting
%	and ending point for histogram
%
%n = sqrt(n);
%n = ceil(log2(n));

n = ceil(2*n^(1/3));
p =  quantile(data, [q, 1-q]);

xNew = p(1) : (p(2) - p(1))/(n-1) : p(2);

end

