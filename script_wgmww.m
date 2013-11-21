
n = 100;
x1 = randn(n,1);
w1 = ones(n,1);

m = 100;
w2 = ones(m,1);
x2 = randn(m,1) + 0.1;

type{1}= 'kolm-smirn';
type{2} = 'cramer';
type{3} = 'wilcoxon';
testType = type{1};

r = 100;
s = 100;

alpha = 0.05;

test_wGMWW(x1, w1, x2, w2, alpha, r, s);

[h p]
