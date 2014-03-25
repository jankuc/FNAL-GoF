% first load MadeNewTables

close all

parts = [1,2];
njets = [2,3,4];
dataSets = 4;

partsS{1} = 'ele';
partsS{2} = 'muo';

dat = 4;

labs = {'KS', 'cram', 'AD', 'R-sqrt', 'R-rice','R-sturge','R-doane','R-scott',...
  'R-kernel'};
hf = {};
%% parts
for part= parts
  if part == 1
    vars = 1:24;
  else
    vars = 1:23;
  end
  partS = partsS{part};
  %% njets
  for njet = njets   
    tabl  = tables{part}{njet}{dat};
    stat = stats{part}{njet}{dat};
%     if part==1 && njet == 2
%       vars = setdiff(vars, 5);
%       tabl = tabl{[1:4 6:end],:};
%       stat = stat([1:4 6:end],:);
%     end
    
    %subplot(2,3,part*(njet-1), 'Parent', hrank);
    hf{end + 1} = figure(length(hf)+1); %#ok<SAGROW>
    plotRanks(tabl, vars);
    
    
    %set(hf{end},'PaperSize',fliplr(get(hf{end},'PaperSize'))) 
    %rotate(gca,[1 1 1],180)
    %view([90 90]);
    %set(gca,'PaperSize',fliplr(get(gca,'PaperSize'))) 
    
    saveas(gcf,['testFigs/KS-Rhist-' partS '-njet_' num2str(njet) '.pdf']);
    %% vars
  end
end
  
% for i in `ls KS-Rhist-*.pdf`; do pdftk $i cat 1north output ./rotated/${i}; done