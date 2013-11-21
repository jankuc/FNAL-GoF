% compare ecdf and DT_histcn

%% ecdf

n = 100000;

x1 = randn(n,1);
x1 = sort(x1);
x2 = randn(n,1);
x2 = sort(x2);
w = 1/n:1/n:1;
w1 = ones(size(w));

% w = w*n;

x =  sort(union(x1,x2));
f1 = wECDF(x1,w,x);
f2 = wECDF(x2,w,x);

plot(x,f1);
hold on; plot(x,f2,'k');
hold off

cmtest2(f1,f2,0.01)   
