function [table, result] = make1table(part, njets, typeOfData, vars, X1, w1, X2, w2)
% [table, res] = make1table(part, njets, vars, X1, w1, X2, w2)
%
%


particle{1} = 'ele';
particle{2} = 'muo';

data{1} = {'Train + Test vs. Yield',  'train',1,0};
data{2} = {'Train vs. Test',          'val',1,2};
data{3} = {'Train + Test vs. Data',   'train',1,3};
data{4} = {'Yield vs. Data',          'train', 0,3};

%% headr of table
kk = 1;
table = cell(24,24);
table{kk,1} = 'PARTICLE';
table{kk,2} = 'SETS';
table{kk,3} = 'NJETS';
table{kk,4} = 'VAR #';
table{kk,5} = 'VAR NAME';
table{kk,6} = 'H KS';
table{kk,7} = 'PVAL KS';
table{kk,8} = 'STAT KS';
table{kk,9} = 'H Cramer';
table{kk,10} = 'PVAL Cramer';
table{kk,11} = 'STAT Cramer';
histType = {'sqrt', 'rice', 'sturge', 'doane', 'scott'};
renType = [histType 'kernel'];
nRenType = length(renType); % # of histoggrams + kernel
colR = 12;
colRR = colR + nRenType; % first column of renyi ranks

for k = 1:2*length(renType)
  table{kk,colR - 1 + k} = renType{mod(k-1,nRenType) + 1};
end

for v = vars
  kk = kk + 1;
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
  
  [a, b] = currVar.histInterval(njets, part);
  
  %% TESTS
  alpha = 0.01;
  testType = 'kolm-smirn';
  [hypKS, pvalKS, statKS] = ...
    test1DEquality(X1f, w1f, X2f, w2f, testType, alpha);
  
  testType = 'cramer';
  [hypC, pvalC, statC] = ...
    test1DEquality(X1f, w1f, X2f, w2f, testType, alpha);
  
  statR = cell(nRenType,1);
  
  %% histogram
  figure;
  nbin = getHistogramNBin(X1f, 'doane');
  [f1, x1] = histwc(X1f, w1f,nbin,a, b);
  [f2, x2] = histwc(X2f, w2f,nbin,a, b);
  f2 = [f2; zeros(length(f1) - length(f2),1)];
  f1 = [f1; zeros(length(f2) - length(f1),1)];
  figure;
  bar(x1,[f1 f2], 0.9, 'LineStyle', 'none')
  title(leptonJetVar(v).toString())
  
  testType = 'renyi';
  % histType = {'sqrt', 'rice', 'sturge', 'doane', 'scott'};
  for r = 1:length(histType) ;
    nbin = getHistogramNBin(X2f, histType{r});
    renyiAlpha = 0.3;
    [~, ~, statR{r}] = ...
      test1DEquality(X1f, w1f, X2f, w2f, testType, renyiAlpha,'hist', nbin, a, b);
  end
  [~, ~, statR{nRenType}] = ...
    test1DEquality(X1f, w1f, X2f, w2f, testType, renyiAlpha,'kernel', 300, a, b);
  
  
  %% printout of the KS, CM
  %lepton, dataSet, nJets, var, H, pVal, stat
  %[k, l, njets, v, hyp, pval, stat]
  table{kk,1} = particle{part};
  table{kk,2} = data{typeOfData}{1};
  table{kk,3} = njets;
  table{kk,4} = v;
  table{kk,5} = leptonJetVar(v).toString;
  table{kk,6} = hypKS;
  table{kk,7} = pvalKS;
  table{kk,8} = statKS;
  table{kk,9} = hypC;
  table{kk,10} = pvalC;
  table{kk,11} = statC;
  
  %% Printout of Renyi dists.
  for l = 1:nRenType;
    table{kk,colR - 1 + l} = statR{l};
    result(kk-1, l) = statR{l};
  end
  
end

B = getRanksFromMin(result);
%meanRR = mean(B,2);
medianRR = median(B,2);

for k = 1:length(vars)
  for l = 1:nRenType;
    table{k+1, colRR - 1 + l} = B(k,l);
  end
  table{k+1 ,colRR + nRenType} = medianRR(k);
end


