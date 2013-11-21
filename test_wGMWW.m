function [h p stat] = test_wGMWW(x1, w1, x2, w2, alpha, r, s)
% function [h p stat] = test_wGMWW(x1, w1, x2, w2, alpha)
%
% A weighted generalization of the Mann–Whitney–Wilcoxon statistic
%
% theorem 2.1 on p.446 in "A weighted generalization of the
% Mann–Whitney–Wilcoxon statistic" by Jingdong Xie, Carey E. Priebe


n = length(x1);
m = length(x2);

%x1sub = randsample(x1,r);
%x2sub = randsample(x2,s);
xRank = tiedrank([x1; x2]);
x1rank = xRank(1:n);
x2rank = xRank(n+1:end);

delta = 0;

for k = 1:r
	for l = 1:s
		for i = k:n-r+k
			for j = l:m-s+l
				if (x1rank(i) < x2rank(j))
					tmp = w1(k) * w2(l) * nchoosek(i-1,k-1)* nchoosek(n-i,r-k)* nchoosek(j-1,l-1)* nchoosek(m-j,s-l);
					delta =  delta + tmp;
				end
			end
		end
	end
end

% finish the enumeration of the statistic.


				
