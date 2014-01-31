
% Displays number of bins for histograms in dependance of number of data
% and usedheuristic for number of bins.
%
% Run it and see.

particle{1} = 'ele';
particle{2} = 'muo';
doParticle = 1;

data = {'Yield vs. Data',          'train', 0,3};

doNJets = [2,3,4];

vars = 1:23;
if doParticle == 1
  vars = [vars, 24];
end

histType = {'sqrt', 'rice', 'sturge', 'doane', 'scott'};

for part = doParticle
  table = cell(length(doParticle));
  tab_part = cell(length(doNJets)*length(histType) + 2, length(vars) + 2);
  for k = 1:length(vars)
    tab_part{1,k+2} = k;
    lepVar = leptonJetVar(k);
    tab_part{2,k+2} = lepVar.toString;
  end
  
  for k = 1:length(doNJets)
    tab_part{2 + 1 + (k-1)*length(histType)} = num2str(doNJets(k));
    for l = 1:length(histType)
      tab_part{(k-1)*length(histType) + l + 2,2} = histType{l};
    end
  end
  
  for k = doNJets
    [X, ~] = getLeptonJetsRamData(particle{part}, 1, 'njets', k, 'train', 3);
    for var = vars
      for l = 1:length(histType)
        tab_part{(k-2)*length(histType) + l + 2,var+2} = ...
          getHistogramNBin(X(:,var), histType{l});
      end
    end
  end
  table{part} = tab_part;
end


