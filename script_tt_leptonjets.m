ele = 'ele';
muo = 'muo';

njets ={2,3,[4,5,6,7,8]};

njets = 2;

%% EE:MC vs. data
dir = ele;

if 1
  % yield
  [X1 w1] = getLeptonJetsMatData(dir, 2:leptonJetType.numTypes,...
    'njets',njets,'train',0);
  % train+test
  [X2 w2] = getLeptonJetsMatData(dir, 2:leptonJetType.numTypes,...
    'njets',njets,'train',1);
  
  
  %% Fix negative Mass (variables )
  if 0
    massColumns = 6:14;
    for k = massColumns
      col = X1(:,k);
      col(col<0) = 0;
      X1(:,k) = col;
      col = X2(:,k);
      col(col<0) = 0;
      X2(:,k) = col;
    end
  end
  
  %% Fix Jetm
  X1 = X1(:,1:5);
  X2 = X2(:,1:5);
  
  %% Fix NaN
  
end

n1 = size(X1,1);
n2 = size(X2,1);

%% 1-D
type{1}= 'kolm-smirn';
type{2} = 'cramer';
type{3} = 'ranksum';
type{5} = 'kstest2';
testType = type{1};

h1d = nan(size(X1,2),1);
p1d = h1d;
stat1d = h1d;
for k = 1:size(X1,2)
  [h1d(k), p1d(k), stat1d(k)] = test1DEquality(X1(:,k), w1,...
    X2(:,k), w2, testType);
  disp(['Test ', testType, ' dim ', num2str(k), ' ended.' ])
end

[h1d vpa(p1d) stat1d]
