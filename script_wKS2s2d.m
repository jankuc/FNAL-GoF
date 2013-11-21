n1 = 1000;
n2 = 1000;

x1 = sort(randn(n1,2));

%w1 = ones(n1,1);
w1 = 1:n1;
w1 = w1';

x2 = sort(randn(n2,2)*1.0);
w2 = w1;%ones(n2,1);


alpha = 0.05;
[p h stat] = test_wKS2s2d(x1,w1,x2,w2,alpha);
%[p h stat] = test_KS2s2d(x1,x2,alpha);
[p h stat]


