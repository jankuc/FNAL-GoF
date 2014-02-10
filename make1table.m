function [table, stats] = make1table(part, njets, typeOfData, vars, X1, w1, X2, w2)
% [table, res] = make1table(part, njets, vars, X1, w1, X2, w2)
%
%


particle{1} = 'ele';
particle{2} = 'muo';

data{1} = {'Train + Test vs. Yield',  'train',1,0};
data{2} = {'Train vs. Test',          'val',1,2};
data{3} = {'Train + Test vs. Data',   'train',1,3};
data{4} = {'Yield vs. Data',          'train', 0,3};

%% header of table
headerLine = {'Lept','Set', '#Jets','#var','var'};
testHeader{1} = {'H KS'; 'pval KS'; 'stat KS'};
testHeader{2} = {'H cra'; 'pval cra'; 'stat cra'};
testHeader{3} = {'H A-D'; 'pval A-D'; 'stat A-D'};
histType = {'sqrt', 'rice', 'sturge', 'doane', 'scott'};
renType = [histType 'kernel'];
nRenType = length(renType); % # of histoggrams + kernel
for k = 1:nRenType
  testHeader{3 + k} = renType{k};
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

lines = cell(length(vars),1);
for k = 1:length(lines)
  lines{k} = cell(1, colRanks + nRenType);
end

test = cell(max(vars),1);
parfor v = vars             
  if njets == 2 && v ==5
    continue
  end
  currVar = leptonJetVar(v);                                                                               
  line = cell(1, colRanks + nRenType);                                                                        
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

  [a, b] = currVar.histInterval(njets, part);                                                              

  %% TESTS     
  
  alpha = 0.01;
  % test{n} = {#cols in table, #col. for min-ranking, cell{nameOfCols}, test_pars} 
  test{v}{1} = {3, 3,testHeader{1}, 'kolm-smirn', alpha}; 
  test{v}{2} = {3, 3,testHeader{2}, 'cramer', alpha};
  test{v}{3} = {3, 3,testHeader{3}, 'anderson-darling', alpha};
 
  renyiAlpha = 0.3; 
  for l = 1:nRenType
    if l <= length(histType)
      nbin = getHistogramNBin(X2f, histType{l});
      test{v}{length(test{v})+1} = ...
        {1, 1,testHeader{3+l}, 'renyi',  {renyiAlpha, 'hist', nbin, a, b}};
    else
      test{v}{length(test{v})+1} = ...
        {1, 1,testHeader{3+l}, 'renyi',  {renyiAlpha, 'kernel', 100, a, b}};
    end
  end
  
  hyp = cell(nTest,1);
  pval = cell(nTest,1);
  stat = cell(nTest,1);
  
  for k = 1:nTest
    [hyp{k} pval{k} stat{k}] = ...
      test1DEquality(X1f, w1f, X2f, w2f, test{v}{k}{4}, test{v}{k}{5});
  end                                                                             

  %% histogram                                                                                             
  for nic = []
    figure;
    nbin = getHistogramNBin(X1f, 'doane');
    [f1, x1] = histwc(X1f, w1f,nbin,a, b);
    [f2, x2] = histwc(X2f, w2f,nbin,a, b);
    f2 = [f2; zeros(length(f1) - length(f2),1)];
    f1 = [f1; zeros(length(f2) - length(f1),1)];
    figure;
    bar(x1,[f1 f2], 0.9, 'LineStyle', 'none')
    title(leptonJetVar(v).toString())
  end

  %% printout of the KS, CM                                                                                
  %lepton, dataSet, nJets, var, H, pVal, stat                                                              
  %[k, l, njets, v, hyp, pval, stat]                                                                       
  line{1} = particle{part};                                                                                
  line{2} = data{typeOfData}{1};                                                                           
  line{3} = njets;
  line{4} = v;
  line{5} = leptonJetVar(v).toString;
  
  linePos = 6;
  for k=1:nTest
    if ~isnan(hyp{k})
      line{linePos} = hyp{k};
      linePos = linePos + 1;
    end
    if ~isnan(pval{k})
      line{linePos} = pval{k};
      linePos = linePos + 1;
    end
    if ~isnan(stat{k})
      line{linePos} = stat{k};
      linePos = linePos + 1;
    end
  end
  lines{v} = line;
end


for k = vars % lines
  for l = 1:length(lines{1}) % columns
    table{k+1, l} = lines{k}{l};
  end
end

stats = nan(length(lines), nTest); % maybe nTest 's scope is only the parfor loop

for k = 1:vars % lines==vars
  offset = 5;
  for l = 1:size(stats,2) % columns==tests
    stats(k,l) = lines{k}{offset + test{1}{l}{2}};
    offset = offset + test{1}{l}{1};
  end
end

for k = nTest:-1:1
  try 
    table{1, end - nTest + k -1} = testHeader{k}{test{1}{k}{2}};
  catch %#ok<CTCH>
    table{1, end - nTest + k -1} = testHeader{k};
  end
end

B = getRanksFromMin(stats);
%meanRR = mean(B,2);
medianRR = median(B,2);

for k = vars
  for l = 1:size(stats,2)
    table{k+1, colRanks - 1 + l} = B(k,l);
  end
  table{k+1,colRanks + nTest} = medianRR(k);
end

