function txt2matTop(dir)
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

dirListing = dir2cell([dir,'p17*.txt']);

for k = 1:length(dirListing)
   filename{k} = [dir, dirListing{k}];
end

maxLines = 1e5;
format = '';
numColumnsInFile = 33;
for l = 1:numColumnsInFile
    format = [format, '%f '];
end
format = [format];

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
    save(strrep(filename{k},'.txt','.mat'),'X');
    
    disp([filename{k}, ' converted succesfully.'])
end


