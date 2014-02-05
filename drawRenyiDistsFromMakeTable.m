% drawRenyiDistsFromMakeTable


A = renyiTab(2:end-1,:);

nVars = size(A, 1);
plot(A-repmat(min(A), size(A,1),1));

renNames = {'sqrt', 'rice', 'sturge', 'doane', 'scott','kernel'};
legend(renNames);
nRenNames = length(renNames);

sortedVars = A;
indeces = A;

for k = 1:nRenNames
  [sortedVars(:,k) indeces(:,k)] = sort(A(:,k),'ascend');
  indeces(:,k) = length(indeces(:,k)) + 1 - indeces(:,k);
end

res = zeros(nVars, nRenNames);
for l = 1:nRenNames
  for k = 1:nVars
    res(nVars-k+1,l) = find(indeces(:,l)==k);
  end
end
res