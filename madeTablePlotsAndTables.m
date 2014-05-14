function madeTablePlotsAndTables(tables, stats, particles, njets, dataSets, drawstats)
% function madeTablePlotsAndTables(tables, stats, particles, njets, dataSets)
%
% tables and stats come from makeMoteTables

%close all

parts = particles;

partsS{1} = 'ele';
partsS{2} = 'muo';

labs = {'KS', 'cram', 'AD', 'R-sqrt', 'R-rice','R-sturge','R-doane','R-scott',...
  'R-kernel'};
hf = {};
%% parts
for dat = dataSets
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
      %saveas(gcf,['rankFigs/KS_CM_AD/KS_CM_AD-' partS '-data_' num2str(dat) '-njet_' num2str(njet) '.pdf']);
      %saveas(gcf,['rankFigs/medianDiff/medianDiff-' partS '-data_' num2str(dat) '-njet_' num2str(njet) '.pdf']);
      saveas(gcf,['rankFigs/renyiH/renyiH-' partS '-data_' num2str(dat) '-njet_' num2str(njet) '.pdf']);
      %saveas(gcf,['rankFigs/renyiHK/renyiHK-' partS '-data_' num2str(dat) '-njet_' num2str(njet) '.pdf']);
      
      %% vars
    end
  end
end

% for i in `ls KS-Rhist-*.pdf`; do pdftk $i cat 1north output ./rotated/${i}; done
