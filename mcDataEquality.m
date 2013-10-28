function  [h, p, stat] = mcDataEquality(mcData, mcWeights, mcFlags,  exData, exWeights, exFlags)
% function [h p stat] = mcDataEquality(mcData, mcWeights, exData, exWeights)
%	
% depending on value of flags divides data into separate channels and then
% uses mcChannelEquality on these smaller subsets
% 

usedMcFlag = [];
usedExFlag = [];

% MC
for k = 1:200
	if ismember(k,mcFlags)
		mcChannel{k} = mcData(mcFlags==k,:);
        mcChannelWeights{k} = mcWeights(mcFlags==k);
		usedMcFlag = union(usedMcFlag,k);
	end
end

% Experimental data
for k = 1:200
	if ismember(k,exFlags)
		exChannel{k} = exData(exFlags==k,:);
        exChannelWeights{k} = exWeights(exFlags==k);
		usedExFlag = union(usedExFlag,k);
	end
end

% test if the flags are equal
equalityOfUnionAndIntersect = union(usedExFlag,usedMcFlag) == intersect(usedExFlag,usedMcFlag);
if sum(equalityOfUnionAndIntersect) ~= length(equalityOfUnionAndIntersect)
	error('Flags of MC data and Experimental data were different');
end
usedFlag = sort(unique(usedMcFlag));

% 1-D test for all of the variables on the equality of MC and experimental
% data
numFlags = length(usedFlag);
h = cell(numFlags,1);
p = cell(numFlags,1);
stat = cell(numFlags,1);
for k = usedFlag
	[h{k}, p{k}, stat{k}] = mcChannelEquality(mcChannel{k}, mcChannelWeights{k}, exChannel{k}, exChannelWeights{k});
end
	
	
