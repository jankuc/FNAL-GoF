function txt2mat(dir)
% function txt2mat(dir)
%
% takes all *.txt files in directory dir and their data in them saves as
% variable X in appropriately named *.mat files. 
% 
% txt2mat('/work/budvar-clued0/francji/tt_leptonjets/samples_txt/split_trees_3samples_muo_1119');
% txt2mat('/work/budvar-clued0/francji/tt_leptonjets/samples_txt/split_trees_3samples_ele_1119');

if ~(dir(end)=='/')
    dir = [dir,'/'];
end

dirListing = dir2cell([dir,'*.txt']);

for k = 1:length(dirListing)
   filename{k} = [dir, dirListing{k}];
end
%clear filename;
%filename{1} = [ dir, 'ttAll_172_miniTree.txt'];

maxLines = 1e5;
format = '';
numColumnsInFile = 45;
for l = 1:numColumnsInFile
    format = [format, '%f '];
end
format = [format, '\n'];

% matlabpool
for k = 1:length(filename)
    try
        try
            [status, result] = system( ['wc -l ', [filename{k}]] );
            numLines = sscanf(result, '%d');
        catch
            numLines = 1e7;
        end
        numOfReads = floor(numLines/maxLines) + 1;
        fid = fopen([filename{k}]);
        Xtmp = cell(numOfReads,1);
        
        for l = 1:numOfReads
            Xtmp{l} = textscan(fid,format,maxLines,'CollectOutput', 1);
        end
        
    catch e
        disp(['Could not load: ', filename{k} ])
        disp(e)
    end
    X = [];
    for l=1:numOfReads
        X = [X; Xtmp{l}{1}];
    end
    fclose(fid);
    
    if ~isempty( strfind(filename{k},'data_miniTree'))
    % change flag of 'train' and 'val' of data to 3
        X(:,end-2) = 3;
        % X(:,end-1) = 3; % was excluded from the new data
    end
    
    mySave(strrep(filename{k},'txt','mat'),X);
    
    disp([filename{k}, ' converted succesfully. W = ', num2str(sum(X(:,end-1))), ' N = ', num2str(size(X,1)) ])
end
end

function mySave(path, X)
  save(path,'X');
end

