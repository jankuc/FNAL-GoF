function yi = interpStairs(x,y,xi)
% yi = interpStairs(x,y,xi)
%
% Stairwise interpolation for creating empirical cumulative function.
% yi(xi) is constant and equal to lefthand side point x until next point x
% is found on the righthand side. 
%
% always:
% yi(1) = 0;
% for all k: xi(k) > x(end) [yi(k):=1] 
%			

yi = ones(size(xi));
yi(1) = 0;
k = 2;
l = 0;

while k < length(xi) && l < length(x)
	l = l + 1;
	while xi(k) < x(l) && k < length(xi)
		yi(k) = y(l);
		k = k + 1;
	end
end
