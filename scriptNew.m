% new script:

%% finds difference between SIGNAL and BACKGROUND

directory1 = 'train';
directory2 = 'test';

nTag = 2;
nJet = 3;
vars = 'BNN';
[X1 w1] = getFnalData(directory1,vars, fnalType.tb, nTag, nJet);
[X2 w2] = loadBackround(directory2,vars, fnalType.tb, nTag, nJet);

type{1}= 'kolm-smirn';
type{2} = 'cramer';
type{3} = 'wilcoxon';
testType = type{1};

h = nan(size(X1,2),1); p = h; stat = h;
for k = 1:size(X1,2)
	[h(k), p(k), stat(k)] = test1DEquality(X1(:,k), w1, X2(:,k), w2, testType);
end

[h p]
