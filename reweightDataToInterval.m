function [x, w] = reweightDataToInterval(x,w,a,b)
%
% [x, w] = reweightDataToInterval(x,w,a,b)
%
% returns data x, which are all in interval [a,b] and weights w, which are the
% same length as new x and reweighted, so largest and smallest element of x has 
% the weight added by the sum of weights of deleted elements of x.
%

logmin = x >= a;
logmax = x <= b;

xmin = min(x(logmin));
imin = find(x==xmin);
xmax = max(x(logmax));
imax = find(x==xmax);

w(imin) = w(imin) + sum(w(~logmin));
w(imax) = w(imax) + sum(w(~logmax));

logic = logmin & logmax;

w = w(logic);
x = x(logic);


