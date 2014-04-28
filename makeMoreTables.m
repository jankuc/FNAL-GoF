function [tables, results] = makeMoreTables(particleIn, nJets, doData)
% [tables, results] = makeMoreTables(particleIn, njetsIn, doData)
%
% particleIn: 1 ... ele
%             2 ... muo
% njetsIn:    2,3,4
% doData:
%   data{1} = {'Train + Test vs. Yield',  'train',1,0};
%   data{2} = {'Train vs. Test',          'val',1,2};
%   data{3} = {'Train + Test vs. Data',   'train',1,3};
%   data{4} = {'Yield vs. Data',          'train', 0,3};
tic
particle{1} = 'ele';
particle{2} = 'muo';

data{1} = {'Train + Test vs. Yield',  'train',1,0};
data{2} = {'Train vs. Test',          'val',1,2};
data{3} = {'Train + Test vs. Data',   'train',1,3};
data{4} = {'Yield vs. Data',          'val', 0,3};

%% Load Data
try leptonJetData = evalin( 'base', 'leptonJetData' );
catch
  leptonJetData = leptonJetsMat2Ram();
  assignin('base', 'leptonJetData', leptonJetData);
end

%% Cycle
for part = particleIn
  for l = doData
    for njets = nJets
      [X1, w1] = getLeptonJetsRamData(particle{part}, 1:leptonJetType.numTypes,...
        'njets', njets, data{l}{2}, data{l}{3});
      [X2, w2] = getLeptonJetsRamData(particle{part}, 1:leptonJetType.numTypes,...
        'njets', njets, data{l}{2}, data{l}{4});
      %% vars
      if strcmp(particle{part},'ele')
        vars = 1:24;
      else
        vars = 1:23;
      end
%       if njets == 2
%         vars = setdiff(vars,5);
%       end
      [tables{part}{njets}{l} results{part}{njets}{l}] = make1table(part, njets, l, vars, X1, w1, X2, w2);
    end
  end
end
toc
        
