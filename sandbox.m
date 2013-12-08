n = 500;
nHist = ceil(2*n^(1/3));
mu = 0;
a = .3;
c = (-2.5 + mu):0.3:(2.5 + mu);
X = sort(randn(n,1)) + mu;
epdf = hist(X,c)/n;
bar(c, epdf)
if sum(epdf == 0)>0
    error('0 in histogram.')
end
alpha = 0.05;

if 0
    %% renyi
    k = length(epdf);
    doubleSum = sum((epdf.^(a)) .* (pdf('norm',c,0,1)).^(1-a));
    logOfSum = log(doubleSum)
    const =2*k/(a*(a-1))
    stat = const * logOfSum
    
end
if 0
    %% T_alpha
    k = length(epdf);
    doubleSum = sum((epdf.^(a)) .* (pdf('norm',c,0,1)).^(1-a))
    const =2*k/(a*(a-1))
    stat = const * (doubleSum - 1)
end
if 1
end

chiQuant = icdf('chi2', [alpha/2, 1 - alpha/2], k - 1)

[h_ks, p_ks, stat_ks] = kstest(X);
disp('kolmogorov-Smirnov')
disp([h_ks, p_ks, stat_ks])

%%%%

%% 2D kolmogorov smirnov for muon for separate njets cahnnels
c = clock;
time = c(4:6)
njets = 4
[X1 w1] = getLeptonJetsRamData('muo', 1:leptonJetType.numTypes,...
    'njets',njets, 'val', 1);

[X2 w2] = getLeptonJetsRamData('muo', 1:leptonJetType.numTypes,...
    'njets',njets, 'val', 2);
dims = [1 2];
tic
[h, pval, stat] = test_wKS2s2d(X1(:,dims), w1, X2(:,dims),w2,0.05);
[h, pval, stat]
toc
% 45 min
  
c = clock;
time = c(4:6)
njets = 3
[X1 w1] = getLeptonJetsRamData('muo', 1:leptonJetType.numTypes,...
    'njets',njets, 'val', 1);

[X2 w2] = getLeptonJetsRamData('muo', 1:leptonJetType.numTypes,...
    'njets',njets, 'val', 2);
dims = [1 2];
tic
[h, pval, stat] = test_wKS2s2d(X1(:,dims), w1, X2(:,dims),w2,0.05);
[h, pval, stat]
toc
% 4 hours

c = clock;
time = c(4:6)
njets = 2
[X1 w1] = getLeptonJetsRamData('muo', 1:leptonJetType.numTypes,...
    'njets',njets, 'val', 1);

[X2 w2] = getLeptonJetsRamData('muo', 1:leptonJetType.numTypes,...
    'njets',njets, 'val', 2);
dims = [1 2];
tic
[h, pval, stat] = test_wKS2s2d(X1(:,dims), w1, X2(:,dims),w2,0.05);
[h, pval, stat]
toc
% 28.5 hours
  

