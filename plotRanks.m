function plotRanks(tabl, vars)
part = tabl{2,1};
njet = tabl{2,3};
labs = {'KS', 'cram', 'AD', 'R-sqrt', 'R-rice','R-sturge','R-doane','R-scott', ...
        'R-kernel'};
nVars = max(vars);
nTest = length(labs);
ranks = nan(nVars, nTest);

for k = 1:max(vars)
  for l = 1:nTest
    ranks(k,l) = tabl{k+1, end + l - nTest - 1};
  end
end

meds = median(ranks,2);
stds = std(ranks,[],2);

labels = {};
hold on
h = plot( vars, ranks(:,1)', 'ro'); labels{end + 1} = labs{1};
plot( vars, ranks(:,2)', 'y^');labels{end + 1} = labs{2};
plot( vars, ranks(:,3)', 'k+');labels{end + 1} = labs{3};
%plot(vars, ranks(:,4)', 'bx');labels{end + 1} = labs{4};
%plot(vars, ranks(:,5)', 'gs');labels{end + 1} = labs{5};
%plot(vars, ranks(:,6)', 'y*');labels{end + 1} = labs{6};
%plot(vars, ranks(:,7)', 'm.');labels{end + 1} = labs{7};
%plot(vars, ranks(:,8)', 'cd');labels{end + 1} = labs{8};
%plot(vars, ranks(:,9)', 'rv');labels{end + 1} = labs{9};

h = errorbar( vars, meds, stds, 's');labels{end + 1} = 'median of ranks';
hold off
for k = vars
  xtick{k} = tabl{k+1, 5}; %#ok<AGROW>
end
set(gca, 'XTick', vars, 'XTickLabel', xtick);
title( [part ', njet:' num2str(njet)])

xticklabel_rotate(vars, 90, xtick)
columnlegend(2,labels)