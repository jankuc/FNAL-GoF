function B = getRanksFromMin(A)
% function B = getRanksFromMin(A)
%
%  0.1      1
%  0.3  ->  3
%  0.2      2

[n1, n2] = size(A);
n2 = size(A,2);

%plot(A-repmat(min(A), size(A,1),1));

%renNames = {'sqrt', 'rice', 'sturge', 'doane', 'scott', 'kernel'};
%legend(renNames);


sortedVars = A;
indeces = A;

for k = 1:n2
  [sortedVars(:,k) indeces(:,k)] = sort(A(:,k),'ascend');
  indeces(:,k) = length(indeces(:,k)) + 1 - indeces(:,k);
end

B = zeros(n1, n2);
for l = 1:n2
  for k = 1:n1
    B(n1-k+1,l) = find(indeces(:,l)==k);
  end
end


