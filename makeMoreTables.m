function [tables, results] = makeMoreTables(particleIn, nJets, doData, varargin)
% [tables, results] = makeMoreTables(particleIn, njetsIn, doData)
%
% particleIn: 1 ... ele
%             2 ... muo
% njetsIn:    2,3,4
% doData:
% data{1} = {'Train + Test vs. Yield',  'val',[1,2],0};
% data{2} = {'Train vs. Test',          'val',1,2};
% data{3} = {'Train + Test vs. Data',   'val',[1,2],3};
% data{4} = {'Yield vs. Data',          'val', 0,3};
% data{5} = {'MC vs. Data',             'val',[0,1,2],3};
% data{6} = {'sig vs. bg',              'type',1,0};

tic
particle{1} = 'ele';
particle{2} = 'muo';

if doData==6
  currSig = varargin{1};
  currSigS = leptonJetType(currSig).toString;
end

data{1} = {'Train + Test vs. Yield',  'val',[1,2],0};
data{2} = {'Train vs. Test',          'val',1,2};
data{3} = {'Train + Test vs. Data',   'val',[1,2],3};
data{4} = {'Yield vs. Data',          'val', 0,3};
data{5} = {'MC vs. Data',             'val',[0,1,2],3};
data{6} = {[currSigS ' vs. bgs'],              'type',1,0};

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
      if doData == 6
          channels1 = currSig;
          backgrounds = [2:4, 7:18];
          channels2 = 1:backgrounds;
      else
        channels1 = 1:leptonJetType.numTypes;
        channels2 = channels1;
      end
        [X1, w1] = getLeptonJetsRamData(particle{part}, channels1,...
          'njets', njets, data{l}{2}, data{l}{3});
        [X2, w2] = getLeptonJetsRamData(particle{part}, channels2,...
          'njets', njets, data{l}{2}, data{l}{4});
      %% vars
      vars = 1:42;
      %       if njets == 2
      %         vars = setdiff(vars,5);
      %       end
      [tables{part}{njets}{l} results{part}{njets}{l}] = make1table(part, njets, l, vars, X1, w1, X2, w2);
    end
  end
end
toc

