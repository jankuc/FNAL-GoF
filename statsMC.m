
% MC
particle{1} = 'ele';
particle{2} = 'muo';
doParticle = [1,2];

nJets{2} = 2;
nJets{3} = 3;
nJets{4} = 4;
doNJets = [2,3,4];

data{1} = {'Train + Test vs. Yield',  'train',1,0};
data{2} = {'Train vs. Test',          'val',1,2};
data{3} = {'Train + Test vs. Data',   'train',1,3};
data{4} = {'Yield vs. Data',          'train', 0,3};

try leptonJetData = evalin( 'base', 'leptonJetData' );
catch
  leptonJetData = leptonJetsMat2Ram();
  assignin('base', 'leptonJetData', leptonJetData);
end

clear resStat

lineNum = 1;
for k = doParticle
  resStat{lineNum,1} = particle{k};
  lineNum = lineNum + 1;
  for m = doNJets
    njets = nJets{m};
    resStat{lineNum,1} = ['njets = ' num2str(nJets{m})];
    lineNum = lineNum + 1;
    if m==2
    resStat{lineNum,2} = 'W train';
    resStat{lineNum,3} = 'W test';
    resStat{lineNum,4} = 'W yield';
    resStat{lineNum,5} = '% of yield w_i in MC';
    resStat{lineNum,6} = 'N train';
    resStat{lineNum,7} = 'N test';
    resStat{lineNum,8} = 'N yield';
    lineNum = lineNum + 1;
    end
    for l = 2:18
      %
      [~, w1] = getLeptonJetsRamData(particle{k}, l,...
        'njets', nJets{m}, 'val', 1);
      % test
      [~, w2] = getLeptonJetsRamData(particle{k}, l,...
        'njets', nJets{m}, 'val', 2);
      % yield
      [~, w3] = getLeptonJetsRamData(particle{k}, l,...
        'njets', nJets{m}, 'val', 0);
      
      lepJetType = leptonJetType(l);
      line{1} = lepJetType.toString;
      line{2} = sum(w1);
      line{3} = sum(w2);
      line{4} = sum(w3);
      %line{5} = 
      line{6} = numel(w1);
      line{7} = numel(w2);
      line{8} = numel(w3);
      
      resStat{lineNum,1} = num2str(line{1});
      for kk = [2:4,6:8]
        resStat{lineNum,kk} = num2str(line{kk});
      end
      lineNum = lineNum + 1;
    end
    %sum
    resStat{lineNum,1} = 'MC';
    for kk = [2:4,6:8]
      for kl=1:17
        w(18-kl,kk) = str2num(resStat{lineNum-kl,kk});
      end
      resStat{lineNum,kk} = num2str(sum(w(:,kk)));
    end
    
    for l = 1:17
      percentage(l) =  sum(w(end-l +1,4))/sum(w(:,4))*100;
      resStat{lineNum-l, 5} = num2str(percentage(l));
    end
    
    lineNum = lineNum + 1;
    % data
    resStat{lineNum,1} = 'data';
    [X4, w4] = getLeptonJetsRamData(particle{k},1,'njets',nJets{m},'val',3);
    resStat{lineNum,4} = num2str(sum(w4));
    resStat{lineNum,5} = num2str(100*str2num(resStat{lineNum,4})/str2num(resStat{lineNum-1,4}));
    resStat{lineNum,6} = '%';
    resStat{lineNum,7} = numel(w4);
    lineNum = lineNum + 1;
  end
end

