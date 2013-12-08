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

maxLines = 1e5;
format = '';
numColumnsInFile = 30;
for l = 1:numColumnsInFile
    format = [format, '%f '];
end
format = [format, '\n'];

for k = 1:length(dirListing)
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
    
<<<<<<< HEAD
    if ~isempty( strfind(filename{k},'data.txt'))
=======
    % change flag of 'train' and 'val' of data to 3
    if ~isempty( strfind(filename{k},'data'))
>>>>>>> 9ce3edec0656a63611870b7ccf7ceb02da4cf457
        X(:,end) = 3;
        X(:,end-1) = 3;
    end
    
    save(strrep(filename{k},'.txt','.mat'),'X');
    
    disp([filename{k}, ' converted succesfully. W = ', num2str(sum(X(:,end-2))), ' N = ', num2str(size(X,1)) ])
end


