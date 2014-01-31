
% Displays number of bins for histograms in dependance of number of data
% and usedheuristic for number of bins.
%
% Run it and you'll see.

n = [2300 3000 9000 12000 44000 60000];

for part = 1:2
  for njet = 2:4
    [X1, w1] = getLeptonJetsRamData(particle{k}, 1:leptonJetType.numTypes,...
          'njets', nJets{m}, data{l}{2}, data{l}{3});
  end
end

X = cell(length(n),1);
g1 = zeros(1,length(n));
for k = 1: length(n)
    X{k} = randn(n,1);
    g1(k) = skewness(X{k});
end

% Number of bins (different sources)
% different numbers are: k1, k2, k3, k4, k5, s1
k1 = sqrt(n);
% Rice rule
k2 = ceil(2*n.^(1/3));
%sturge's formula
k3 = ceil(log2(n) + 1);
s1 = sqrt(6*(n-2)./(n+1)./(n+3));
% Doane's modification of k3 for non-normal data
k4 = 1 + log2(n) + log2(1 + abs(g1)./s1); 
for k = 1:length(n)
    w5(k) = ceil(3.49*std(X{k}) * n(k)^(-1/3));
    a = min(X{k});
    b = max(X{k});
    k5(k) = ceil((b-a)./w5(k));
end

x = 1:length(n);
figure(666);

plot(x,k1,'rx',x,k2,'kd',x,k3,'ko',x,k4,'ks',x,k5,'k*');
legendStr = {'\sqrt{n}', 'ceil(2n^{1/3})', 'ceil(log_2(n)','Doane', ...
  'w=3.49*sdt(X)*n^{-1/3}'}; 
legend(legendStr)
set(gca,'XTick',1:length(n))
set(gca,'XTickLabel',{num2str(n(1)), num2str(n(2)),num2str(n(3)), ...
    num2str(n(4)),num2str(n(5)),num2str(n(6))})
  
tab = cell(length(legendStr),length(n)+1);
for k = 2:length(legendStr)+1
  tab{k,1} = legendStr{k-1};
end
for k = 1:length(n)
  tab{1,k+1} = n(k);
  tab{2,k+1} = round(k1(k));
  tab{3,k+1} = round(k2(k));
  tab{4,k+1} = round(k3(k));
  tab{5,k+1} = round(k4(k));
  tab{6,k+1} = round(k5(k));
end
tab


