function plotRanks(tabl, vars)
part = tabl{2,1};
njet = tabl{2,3};
labs = {'KS', 'CM', 'AD', 'R-sqrt', 'R-rice','R-sturge','R-doane','R-scott', ...
  'R-kernel'};



nVars = max(vars);
nTest = length(labs);
ranks = nan(nVars, nTest);

for k = 1:max(vars)
  for l = 1:nTest
    if (tabl{2,3}==2 && k==5)
      ranks(k,l) = nan;
    else
      ranks(k,l) = tabl{k+1, end + l - nTest - 1};
    end
  end
end

drawtests = [1:3];
meds1 = median(ranks(:,drawtests),2);
stds1 = std(ranks(:,drawtests),[],2);

drawtests = [4:8];
meds2 = median(ranks(:,drawtests),2);
stds2 = std(ranks(:,drawtests),[],2);

labels = {};
hold on

cstep = floor(255/5);
colorMatrix = morgenstemning;

% h = plot( vars, ranks(:,1)', 'go'); labels{end + 1} = labs{1}; %KS
% plot(vars, ranks(:,2)', '*', 'Color', [1 0.4 0]);labels{end + 1} = labs{2}; %cra
% plot(vars, ranks(:,3)', 'k+');labels{end + 1} = labs{3}; %AD
h =  plot(vars, ranks(:,4)', 'x', 'Color',colorMatrix(0*cstep+1,:));labels{end + 1} = labs{4}; %Rh
plot(vars, ranks(:,5)', '+', 'Color',colorMatrix(1*cstep,:) );labels{end + 1} = labs{5};
plot(vars, ranks(:,6)', '*', 'Color',colorMatrix(2*cstep,:) );labels{end + 1} = labs{6};
plot(vars, ranks(:,7)', 'v', 'Color',colorMatrix(3*cstep,:) );labels{end + 1} = labs{7};
plot(vars, ranks(:,8)', 'o', 'Color',colorMatrix(4*cstep,:) );labels{end + 1} = labs{8}; %Rh
%plot(vars, ranks(:,9)', 'x', 'Color',colorMatrix(5*cstep,:) );labels{end + 1} = labs{9}; %Rk
% plot(vars, ranks(:,9)', 'rx');labels{end + 1} = labs{9}; %Rk

%h = plot(vars, meds1, 's');labels{end + 1} = 'median[KS,CM,AD]'; % Median for legend
 plot(vars, meds2, 's'); labels{end + 1} = 'median[Renyi hist]'; % Median for legend

%errorbar( vars, meds1, stds1, 's'); %labels{end + 1} = 'median of ranks'; labels{end + 1} = ' ';
 errorbar( vars, meds2, stds2, 's'); %labels{end + 1} = 'median of ranks'; labels{end + 1} = ' ';

for k = vars
  xtick{k} = tabl{k+1, 5}; %#ok<AGROW>
end
set(gca, 'XTick', vars, 'XTickLabel', xtick);
%title( [part ', njet:' num2str(njet)])
set(gca, 'YLim',[-3,40]);
xticklabel_rotate(vars, 90, xtick,'Interpreter', 'none');
% hleg = legend(labels);
tightfig(gcf);
columnlegend(2,labels,'boxon','Location','NorthWest');
%legend(gca,labels,'location','northeast');

% for line=5:5:20
% plot(vars, line*ones(size(vars)),'Color',[0.8 0.8 0.8]);
% end

%xticklabel_rotate(vars, 90, xtick)
%columnlegend(2,labels)

hold off
