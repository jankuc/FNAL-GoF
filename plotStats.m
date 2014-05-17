function plotStats(SIG, RANKSTAT)
% function plotStats(sig, rankStat)
%
% enter numbers/vectors of indeces for filling the following vectors:
% sigs = {'ttA', 'ttAll', 'ttAHer','ttMCNLO'};
% rankStats = {'KS','Ren'};

for sig = SIG
  for rankStat = RANKSTAT
    
    close all
    
    sigs = {'ttA', 'ttAll', 'ttAHer','ttMCNLO'};
    sigS = sigs{sig};
    tabs = evalin('base',['tabs42_' sigS]);
    statistics = evalin('base',['stats42_' sigS]);
    
    rankStats = {'KS','Ren'};
    rankStatS = rankStats{rankStat};
    
    
    %path(path,'colorblind_colormaps');
    %colormap(morgenstemning)
    
    dim = 42;
    stats = 1:7;
    
    partsS = {'ele', 'muo'};
    labs = {'KS', 'CM', 'AD', 'R-sqrt', 'R-rice','R-sturge','R-doane','R-scott', ...
      'R-kernel'};
    for dat = [6]
      for part= [1 2]
        if part == 1
          vars = 1:dim;
        else
          vars = 1:dim;
        end
        %% njets
        for njet = [2 3 4]
          st = statistics{part}{njet}{dat};
          st = st(1:dim,:);
          stn = st;
          if njet==2
            st(5,:) = st(1,:);
          end
          for k = 1:size(stn,2)
            stn(:,k) = st(:,k)/norm(st(:,k));
          end
          if njet==2
            stn(5,:) = nan(size(stn(5,:)));
          end
          
          rankInd = 1;
          if rankStat == 1
            rankInd = 1;
          elseif rankStat == 2
            rankInd = 7;
          end
          
          [~, ind] = sort(stn(:,rankInd));
          stn = stn(ind,:);
          
          figure;
          plot(stn(:,stats), '-')
          clear xtick;
          for k = vars
            xtick{k} = [tabs{1}{3}{6}{k+1, 5}]; %#ok<AGROW>
          end
          xtick = xtick(ind);
          %       if njet == 2
          %         xtick = xtick(1:end-1);
          %         vars = vars([1:4, 6:end]);
          %       end
          
          
          set(gca, 'XTick', vars, 'XTickLabel', xtick);
          %title( [part ', njet:' num2str(njet)])
          set(gca, 'YLim',[0,0.7]);
          %       if part==2 && k==23
          %         for k = 1:22
          %           xtick_new{k} = xtick{k};
          %         end
          %       end
          %       if njet == 2
          %         xticklabel_rotate(1:max(vars-1), 90, xtick,'Interpreter', 'none');%, 'FontWeight','bold');
          %       else
          xticklabel_rotate(vars, 90, xtick,'Interpreter', 'none');%, 'FontWeight','bold');
          %       end
          ylabel('Values of normalized statistics')
          legend(labs(stats), 'Location', 'Northwest')
          tightfig(gcf);
          
          mkdir(['stats_plots/' sigS]);
          mypath = ['stats_plots/' sigS '/' sigS '-sorted_by_' rankStatS  '-'  partsS{part} '-njet_' num2str(njet)];
          saveas(gcf,[ mypath '.pdf']);
          saveas(gcf,[ mypath '.png']);
        end
      end
    end
  end
end