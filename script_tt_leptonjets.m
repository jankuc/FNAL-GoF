ele = 'ele';
muo = 'muo';

njets ={2,3,[4,5,6,7,8]}; 

njets = 2;

%% EE:MC vs. data
dir = ele;
% mc
[X1 w1] = getLeptonJetsData(dir, [2:leptonJetType.getNumOfTypes()],'njets',njets);
% data
[X2 w2] = getLeptonJetsData(dir, leptonJetType.data, 'njets',njets);

type{1}= 'kolm-smirn';
type{2} = 'cramer';
type{3} = 'wilcoxon';
testType = type{1};

h1d = nan(size(X1,2),1); p1d = h1d; stat1d = h1d;
%% 1-D
for k = 1:size(X1,2)
	[h(k), p(k), stat(k)] = test1DEquality(X1(:,k), w1, X2(:,k), w2, testType);
end

[h p]
