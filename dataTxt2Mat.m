function [data, weigth] = dataTxt2Mat(directory, varargin)
% [data, flags, weigth] = dataTxt2Mat(directory, varargin)
%
%	directory ... e.g. /home/honza/Documents/FJFI/FNAL-INGO/data/subsets_txt_all_variables/small_training_sample
%

% p17_CC_wbb_EqOneTag_EqTwoJet_zero_small_training_sample.txt

spc = '_';

channel{1} = 'p17_CC';

tag{1} = 'EqOneTag';
tag{2} = 'EqTwoTag';

jet{1} = 'EqTwoJet';
jet{2} = 'EqThreeJet';

type{1} = 'diboson';
type{2} = 'QCD';
type{3} = 'tb';
type{4} = 'tqb';
type{5} = 'ttbar-dilepton';
type{6} = 'ttbar-lepjets';
type{7} = 'wbb';
type{8} = 'wcc';
type{9} = 'wlp';
type{10} = 'zbb';
type{11} = 'zcc';
type{12} = 'zlp';


if nargin > 1 && sum(strcmp(varargin,'test')) || ~isempty(regexp(directory,'test'))
	usage = 'zero_testing_sample';
elseif nargin > 1 && sum(strcmp(varargin,'train')) ||  ~isempty(regexp(directory,'train'))
	usage = 'zero_small_training_sample';
elseif nargin > 1 && sum(strcmp(varargin,'yield'))  || ~isempty(regexp(directory,'yield'))
	usage = 'zero_yield_sample';
	type{13} = 'DATA';
end

ext = '.txt';

weigth=cell(length(channel),length(tag),length(jet),length(type));
data=cell(length(channel),length(tag),length(jet),length(type));
disp(['Loading dir: ' directory])
for i=1:length(channel)
	for j=1:length(tag)
		for k=1:length(jet)
			for l=1:length(type)
				filename = [channel{i} spc type{l} spc tag{j} spc jet{k} spc usage ext];
				disp(['Loading file: ' filename])
				tmp = importdata([directory '/' filename]);
				weigth{i}{j}{k}{l} = tmp(:,end);
				data{i}{j}{k}{l} = tmp(:,1:end-1);
				
					
			end
		end
	end
end

save([directory '/' usage],'data','weigth');





