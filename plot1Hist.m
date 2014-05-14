function plot1Hist(part, njets, typeOfData, vars, X1, w1, X2, w2)
% [table, res] = make1table(part, njets, vars, X1, w1, X2, w2)
%
%

close all
particle{1} = 'ele';
particle{2} = 'muo';

data{1} = {'Train + Test vs. Yield',  'val',[1,2],0};
data{2} = {'Train vs. Test',          'val',1,2};
data{3} = {'Train + Test vs. Data',   'val',[1,2],3};
data{4} = {'Yield vs. Data',          'val', 0,3};
data{5} = {'MC vs. Data',             'val',[0,1,2],3};
data{6} = {'sig vs. bg',              'type',1,0};

%% header of table
headerLine = {'Lept','Set', '#Jets','#var','var', 'X1 0.025', 'X1 0.975',  'X2 0.025',  'X2 0.975'};
offset = length(headerLine);
testHeader{1} = {'H KS'; 'pval KS'; 'stat KS'};
%testHeader{2} = {'H KS'; 'pval RKS'; 'stat RKS'};
testHeader{2} = {'H cra'; 'pval cra'; 'stat cra'};
%testHeader{3} = {'H craW'; 'pval craW'; 'stat craW'};
testHeader{3} = {'H A-D'; 'pval A-D'; 'stat A-D'};
numOfNoRenyis = length(testHeader);

histType = {'sqrt', 'rice', 'sturge', 'doane', 'scott'};
renType = [histType 'kernel'];
nRenType = length(renType); % # of histoggrams + kernel
for k = 1:nRenType
  testHeader{numOfNoRenyis + k} = renType{k};
end

nTest = length(testHeader);

colRanks = length(headerLine) + 1;
for k = 1:length(testHeader)
  colRanks = colRanks + size(testHeader{k},1);
end

widthTable = colRanks - 1 + length(testHeader) + 1;
table = cell(max(vars) + 1,widthTable);

for k = 1:length(testHeader)
  if ischar(testHeader{k})
    headerLine = horzcat(headerLine, (testHeader{k}));
  else
    headerLine = horzcat(headerLine, (testHeader{k})');
  end
end

for k = 1:length(headerLine)
  table{1,k} = headerLine{k};
end

lines = cell(max(vars),1);
for k = 1:length(lines)
  lines{k} = cell(1, colRanks + nRenType);
end

test = cell(max(vars),1);
parfor v = vars
  line = cell(1, colRanks + nRenType);
  if njets == 2 && v ==5
    for k = 1:length(line)
      line{k} = nan;
    end
    continue
    lines{v} = line;
  end
  currVar = leptonJetVar(v);
  %[XX1, ww1] = cropVarToHistInterval(X1(:,v),w1,v);
  %[XX2, ww2] = cropVarToHistInterval(X2(:,v),w2,v);
  
  % filter out NaNs
  arenan1 = isnan(X1(:,v));
  w1f = w1(~arenan1);
  X1f = X1(~arenan1,v);
  arenan2 = isnan(X2(:,v));
  w2f = w2(~arenan2);
  X2f = X2(~arenan2,v);
  
  % filter out negative for Masses
  if ismember(v,6:14)
    areBelowZero1 = X1f < 0;
    w1f = w1f(~areBelowZero1);
    X1f = X1f(~areBelowZero1);
    areBelowZero2 = X2f < 0;
    w2f = w2f(~areBelowZero2);
    X2f = X2f(~areBelowZero2);
  else
    areBelowZero1 = logical(zeros(size(w1f)));
    areBelowZero2 = logical(zeros(size(w2f)));
  end
  
  %[a, b] = currVar.histInterval(njets, part);
  a = wprctile([X1f(:); X2f(:)],0.005,[w1f(:); w2f(:)]);
  b = wprctile([X1f(:); X2f(:)],0.995,[w1f(:); w2f(:)]);
  
  %% histogram
  for nic = 1
    figure;
    nbin = getHistogramNBin(X1f, 'doane');
    [f1, x1] = histwc(X1f, w1f,nbin,a, b);
    [f2, x2] = histwc(X2f, w2f,nbin,a, b);
    f2 = [f2; zeros(length(f1) - length(f2),1)];
    f1 = [f1; zeros(length(f2) - length(f1),1)];
    
    f1 = [0; f1; 0];
    f2 = [0; f2; 0];
    x1 = [x1(1) - (x1(2)-x1(1)), x1, 2*x1(end) - x1(end-1)];
    
    stairs(x1,[f1 f2], 'LineWidth',1)
   % figure;
   % bar(x1,[f1 f2], 0.9, 'LineStyle', 'none')
   legend('Signal', 'Background')
   tightfig(gcf);
    %title(leptonJetVar(v).toString())
    saveas(gcf,['Sig_vs_BG/SB_' particle{part} '_njet_'  num2str(njets) '_' currVar.toString '.pdf']);
  end
end


