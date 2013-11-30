
clear all;

particle{1} = 'ele';
particle{2} = 'muo';

data{1} = {'TT-Y','train',1,0};
data{2} = {'T-T','val',1,2};
data{3} = {'TT-D','train',1,3};
data{4} = {'Y-D','val',0,3};

nJets{1} = 2;
nJets{2} = 3;
nJets{3} = 4;

weighted{1} = 1;
%weighted{2} = 0;

for k = 1:length(particle)
  for l = 1:length(data)
    for m = 1:length(nJets)
      for n = 1:length(weighted)
        dir = particle{k};
        njets = nJets{m} ;
        [X1 w1] = getLeptonJetsRamData(dir,1:leptonJetType.numTypes,...
          'njets',njets,data{l}{2},data{l}{3});
        [X2 w2] = getLeptonJetsRamData(dir, 1:leptonJetType.numTypes,...
          'njets',njets,data{l}{2},data{l}{4});
        
        X1 = X1(:,1:5);
        X2 = X2(:,1:5);
        
        type{1}= 'kolm-smirn';
        type{2} = 'cramer';
        type{3} = 'ranksum';
        type{5} = 'kstest2';
        w = '';
        if weighted{n}
          testType = type{1};
          w = 'w';
        else
          testType = type{5};
        end
        
        h1d = nan(size(X1,2),1);
        p1d = h1d;
        stat1d = h1d;
        for o = 1:size(X1,2)
          [h1d(o), p1d(o), stat1d(o)] = ...
            test1DEquality(X1(:,o), w1, X2(:,o), w2, testType);
          disp(['Test ', testType, ' dim ', num2str(o), ' ended.' ])
        end
        
        disp([dir, '_', data{l}{1}, '_nJets-',num2str(njets),'_',w,':'])
        stats{k,l,m,n} = [h1d p1d stat1d];
        vpa([h1d p1d stat1d],3)
      end
    end
  end
end
