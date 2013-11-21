
n = 1000;
x1 = randn(n,3);
w1 = ones(n,1);

m = 1000;
w2 = ones(m,1);
x2 = randn(m,3);

type{1}= 'kolm-smirn';
type{2} = 'cramer';
type{3} = 'wilcoxon';
testType = type{1};

r = 100;
s = 100;

alpha = 0.05;

[h p stat] = test_nDimE(x1, x2,alpha);

[h p]
