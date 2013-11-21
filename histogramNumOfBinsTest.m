
% Displays number of bins for histograms in dependance of number of data
% and usedheuristic for number of bins.
%
% Run it and you'll see.

n = [20 50 100:100:900 1e3:1e3:1e4 1e5:1e5:1e6];
X = cell(length(n),1);
g1 = zeros(1,length(n));
for k = 1: length(n)
    X{k} = randn(n,1);
    g1(k) = skewness(X{k});
end

% Number of bins (different sources)
% different numbers are: k1, k2, k3, k4, k5, s1
k1 = sqrt(n);
k2 = ceil(2*n.^(1/3));
k3 = ceil(log2(n) + 1);
s1 = sqrt(6*(n-2)./(n+1)./(n+3));
k4 = 1 + log2(n) + log2(1 + g1./s1); 
for k = 1:length(n)
    w5(k) = ceil(3.49*std(X{k}) * n(k)^(-1/3));
    a = min(X{k});
    b = max(X{k});
    k5(k) = ceil((b-a)./w5(k));
end

x = 1:length(n);
figure(666);

plot(x,k1,'rx',x,k2,'kd',x,k3,'ko',x,k4,'ks',x,k5,'k*');
legend('\sqrt{n}', 'ceil(2n^{1/3})', 'ceil(log_2(n)','Doane','w = 3.49*sdt(X)*n^{-1/3}')
set(gca,'XTick',1:length(n))
set(gca,'XTickLabel',{'20', '50', '100', '200','300','400','500','600',...
    '700','800','900','1000',   '2000',   '3000',   '4000',   '5000', ...
    '6000',   '7000',   '8000',   '9000',  '10000', '100000','200000','300000','400000','500000','600000','700000', '800000','900000','1000000'})


