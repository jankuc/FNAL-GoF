function [ background, weight ] = loadLeptonJetBackround(trTeYi, vars, signal, nTag, nJet)
%	loadLeptonJetBackground(signal, directory)
%	loads leptonJetType(1,-,18) minus leptonJetTypes specified in signal.
%	Doesn't load DATA
%	
%   trTeYi:		'train', 'test', 'yield'
%	vars:		'BNN', 'BDT', 'BNNBDT', 'all'
%   signal:		vector of fnalTypes

allTypes = leptonJetType.getAll;

background = [];
a = 199;
weight = [];
for type = allTypes'
	if sum(type==signal) == 0 % type is not amongst signal, so we want to add it to background
		[x w] = getLeptonJetsData(trTeYi, vars, type, nTag, nJet);
		background = [background; x];
		weight = [weight; w];
	end
end


