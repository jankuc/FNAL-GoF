ele = 'ele';
muo = 'muo';

njets ={2,3,[4,5,6,7,8]}; 

njets = 3;

%% EE:MC vs. data
dir = ele;
% mc   
[X1 w1] = getLeptonJetsMatData(dir, [2:leptonJetType.numTypes], 'njets',njets);
% data
[X2 w2] = getLeptonJetsMatData(dir, leptonJetType.data, 'njets',njets);

%% 1-D
type{1}= 'kolm-smirn';
type{2} = 'cramer';
type{3} = 'ranksum';
testType = type{2};

h1d = nan(size(X1,2),1); 
p1d = h1d; 
stat1d = h1d;
for k = 1:size(X1,2)
	[h1d(k), p1d(k), stat(k)] = test1DEquality(X1(:,k), w1, X2(:,k), w2, testType);
    disp(['Test ', testType, ' dim ', num2str(k), ' ended.' ])
end

[h1d p1d]
