function [x, w] = reweightDataToInterval(x,w,a,b)


logmin = x >= a;
logmax = x <= b;

xmin = min(x(logmin));
imin = find(x==xmin);
xmax = max(x(logmax));
imax = find(x==xmax);

w(imin) = w(imin) + sum(w(~logmin));
w(imax) = w(imax) + sum(w(~logmax));
w = w(logmin & logmax);
x = x(logmin & logmax);


