function plotSB(variables)

close all

path(path,'colorblind_colormaps');
%colormap(morgenstemning)


partsS = {'ele', 'muo'};
labs = {'KS', 'CM', 'AD', 'R-sqrt', 'R-rice','R-sturge','R-doane','R-scott', ...
        'R-kernel'};
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