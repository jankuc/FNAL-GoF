function [h, p, stat] = mcChannelEquality(x1, w1, x2, w2)
% [h p stat] = MC_data_equality(mcData,mcWeights, exData, exWeights)
%
% data already have to be only from 1 channel and Weighted
%

[numOfData, dimData]= size(x1);



typeOfTest = 'kolm-smirn';
typeOfTest = 'cramer';
%typeOfTest = 'kolm-smirn-2D';
testDim = 1;

variableCombinations = combnk(1:dimData,testDim);

numOfTests = size(variableCombinations,1);

h = nan(numOfTests,1);
p = nan(numOfTests,1);
stat = nan(numOfTests,1);

if testDim == 1
    for i = 1:size(variableCombinations,1)
        k = variableCombinations(i,:);
        [h(k), p(k), stat(k)] = test1DEquality(x1(:,k), w1, x2(:,k), w2, typeOfTest);
    end
elseif testDim == 2
    for i = 1:size(variableCombinations,1)
        k = variableCombinations(i,:);
        [h(k), p(k), stat(k)] = test2DEquality(x1(:,k),x2(:,k),typeOfTest);
    end
end	
	