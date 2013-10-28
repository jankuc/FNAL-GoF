function dataTxt2MatAll
dir = '/home/honza/Documents/FJFI/FNAL-INGO/data/subsets_txt_all_variables/';
train = 'small_training_sample'; 
test = 'testing_sample';
yield = 'yield_sample';

%[~, ~] = dataTxt2Mat([dir test]);
[~, ~] = dataTxt2Mat([dir train]);
[~, ~] = dataTxt2Mat([dir yield]);

end