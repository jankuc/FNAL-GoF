function [ background, weight ] = loadBackround(trTeYi, vars, signal, nTag, nJet)
%	loadBackground(signal, directory)
%	loads fnalType(1,-,12) minus fnalTypes specified in signal. Doesn't load DATA
%	
%   trTeYi:		'train', 'test', 'yield'
%	vars:		'BNN', 'BDT', 'BNNBDT', 'all'
%   signal:		vector of fnalTypes

allTypes = fnalType.getAll;

background = [];
weight = [];
for type = allTypes'
	if sum(type==signal) == 0 % type is not amongst signal, so we want to add it to background
		[x w] = getFnalData(trTeYi, vars, type, nTag, nJet);
		background = [background; x];
		weight = [weight; w];
	end
end

