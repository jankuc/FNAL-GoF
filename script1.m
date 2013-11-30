n1 = 1e4;
n2 = 1e6;
x1 = sort(randn(n1,1));
w1 = floor(sort(randn(n1,1))*1000);

mu = -1.8;
sig = 1.5;
x2 = sort((randn(n2,1)-mu)/sig);
w2 = ones(n2,1)/n2;

ecdf(x1,'frequency',w1);
hold on
[f,x] = ecdf(x2);
stairs(x,f,'k')
hold off

%w2 = (1:n2)./sum(1:n2);

[h, p, stat] = test1DEquality(x1,w1,x2,w2,'cramer');

[h, p, stat] 
