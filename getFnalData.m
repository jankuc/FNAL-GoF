function [ data, weight ] = getFnalData(trTeYi,vars, type, nTag, nJet)
%	[ data, weight ] =  getFnalData(trTeYi,vars, type, nTag, nJet)
%
%   trTeYi:		'train', 'test', 'yield'
%	vars:		'BNN', 'BDT', 'BNNBDT', 'all'
%	type:		1,...,13 or fnalType
%	nTag:		1,2
%	nJet:		2,3


spc = '_';
ext = '.txt';

if isreal(type)
	type = fnalType(type);
end

channel{1} = 'p17_CC';

tag{1} = 'EqOneTag';
tag{2} = 'EqTwoTag';

jet{2} = 'EqTwoJet';
jet{3} = 'EqThreeJet';

dirAll = '/home/honza/Documents/FJFI/FNAL-INGO/data/subsets_txt_all_variables/';
dirBNN = '/home/honza/Documents/FJFI/FNAL-INGO/data/subsets_txt_BNN_variables/';
dirBDT = '/home/honza/Documents/FJFI/FNAL-INGO/data/subsets_txt_BDT_variables/';
dirBNNBDT = '/home/honza/Documents/FJFI/FNAL-INGO/data/subsets_txt_BNNBDT_variables/';

if strcmp(vars, 'BNN')
	dir = dirBNN;
elseif strcmp(vars, 'BDT')
	dir = dirBDT;
elseif strcmp(vars, 'BNNBDT')
	dir = dirBNNBDT;
elseif strcmp(vars, 'all')
	dir = dirAll;
end

train = 'small_training_sample'; 
test = 'testing_sample';
yield = 'yield_sample';
zero = 'zero';

if strcmp(trTeYi, 'train')
	trTeYi = [dir train];
	usage = [zero spc train];
elseif strcmp(trTeYi, 'test')
	trTeYi = [dir test];
	usage = [zero spc test];
elseif strcmp(trTeYi, 'yield')
	trTeYi = [dir yield];
	usage = [zero spc yield];
else
	error('wrongly specified train/test/yield.')
end

filename = [channel{1} spc type.toString spc tag{nTag} spc jet{nJet} spc usage ext];

try
	tmp = importdata([trTeYi '/' filename]);
catch
	disp(['couldnt: ' trTeYi '/' filename ])
end

weight = tmp(:,end);
data = tmp(:,1:end-1);

end

