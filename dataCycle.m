function [data, weight] = dataCycle(vars, directory)
% [data, flags, weight] = dataCycle(vars, directory)
%
%	directory ... e.g. /home/honza/Documents/FJFI/FNAL-INGO/data/subsets_txt_all_variables/small_training_sample
%

% p17_CC_wbb_EqOneTag_EqTwoJet_zero_small_training_sample.txt

tag = 1:2;
jet = 2:1:3;

type = 1:12;

channel = 1;

weight=cell(length(channel),length(tag),length(jet),length(type));
data=cell(length(channel),length(tag),length(jet),length(type));

disp(['Loading dir: ' directory])
for i=1:length(channel)
	for j=1:length(tag)
		for k=1:length(jet)
			for l=1:length(type)

				%[data{i}{j}{k}{l} weight{i}{j}{k}{l}]
				[~,~] = getData(directory, type(l), tag(j), jet(k), vars);
				
					
			end
		end
	end
end




