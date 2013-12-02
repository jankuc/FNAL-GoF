function [ data, weight ] = getLeptonJetsData(muoEle,lepJetType,varargin)
%	[ data, weight ] =  getLeptonJetsData(muoEle, lepJetType, varargin)
%
% Loads mixture of specified sets of leptonJetTypes.
% Consider loading MAT files with GETLEPTONJETSDATA or even loading
% leptonJets into RAM memory via LEPTONJETS2RAM
%
%	muoEle:       'muo', 'ele'
%	lepJetType:   leptonJetType, [leptonJetType1,leptonJetType2,...],[2:18]
%
% VARARGIN:
%	train:        0... yield,
%               1... train, test
%               3... data
%	val:          0... yield
%               1... train
%               2... test
%               3... data
%	njets:        2, 3, 4==(4,5,...)
%	type:         0... background ?
%               1... signal ?

paramStruct = nameValuePairToStruct(struct,varargin);
validStruct = struct('train',0,'val',0,'njets',0,'type',0);

if (sum(ismember(fieldnames(paramStruct),fieldnames(validStruct))) ~=...
    length(fieldnames(paramStruct)))
  error(['Fieldnames of structures do not correspond.',...
    ' Check Name-value pairs in the function input.'])
end

ext = '.txt';
dataDim = 25;

if isreal(lepJetType)
  lepJetType = leptonJetType(lepJetType);
end

[str] = loadLocalConfig('./local-config.xml');

dirMuo = str.dir.muo;
dirEle = str.dir.ele;
%dirRoot = '/work/budvar-clued0/francji/tt_leptonjets/samples_txt/';
%dirMuo = [dirRoot '/split_trees_3samples_muo_1119'];
%dirEle = [dirRoot '/split_trees_3samples_ele_1119'];

if strcmp(muoEle, 'muo')
  dir = dirMuo;
elseif strcmp(muoEle, 'ele')
  dir = dirEle;
end
lepJetLength = length(lepJetType);
filename = cell(lepJetLength,1);
for k = 1:lepJetLength
  filename{k} = [lepJetType(k).toString '_miniTree' ext];
end

maxLines = 1e5;
format = '';
numColumnsInFile = 30;
for l = 1:numColumnsInFile
  format = [format, '%f '];
end
format = [format, '\n'];

X = cell(lepJetLength);
for k = 1:lepJetLength
  try
    try
      [~, result] = system( ['wc -l ', [dir '/' filename{k}]] );
      numLines = sscanf(result, '%d');
    catch
      numLines = 1e7;
    end
    numOfReads = floor(numLines/maxLines) + 1;
    fid = fopen([dir '/' filename{k}]);
    Xtmp = cell(numOfReads,1);
    
    for l = 1:numOfReads
      Xtmp{l} = textscan(fid,format,maxLines,'CollectOutput', 1);
    end
    
    %X{k} = importdata([dir '/' filename{k}]);
  catch e
    disp(['Could not load: ' dir '/' filename{k} ])
    disp(e)
  end
  X{k} = [];
  for l=1:numOfReads
    X{k} = [X{k}; Xtmp{l}{1}];
  end
  fclose(fid);
end
if size(X{1},2)~=numColumnsInFile
  error('ERROR: Format of data has changed.')
end

% last columns of X: "NJets","type","Weight","train","val"
end

function Y = filterRows(Y, yFlagsCol, logic)
  if size(logic,2) > 1
    YFlagsRep = repmat(yFlagsCol,1,size(logic,2));
    logicRep = repmat(logic, size(YFlagsRep,1),1);
    Y = Y(sum(YFlagsRep==logicRep,2)>0,:);
  else
    Y = Y(yFlagsCol==logic,:);
  end
end

