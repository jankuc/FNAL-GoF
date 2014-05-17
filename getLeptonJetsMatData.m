function [ data, weight, last6cols] = getLeptonJetsMatData(muoEle,lepJetType,varargin)
%	[ data, weight ] =  getLeptonJetsMatData(muoEle,lepJetType, varargin)
%
% Loads mixture of specified sets of leptonJetTypes.
% Consider loading leptonJets into RAM memory via LEPTONJETS2RAM
%
%	muoEle:       'muo', 'ele'
%	lepJetType:   leptonJetType, [leptonJetType1,leptonJetType2,...],[2:18]
%
% VARARGIN:
%	val:          0... yield
%               1... train
%               2... test
%               3... data
%	njets:        2, 3, 4==(4,5,...)
%
% EXAMPLE: getLeptonJetsRamData('muo',2:18, 'njets', 4, 'val', 0)
%     loads all of the channels of muon, all jets (2,3,4) and gets only
%     yield sample

paramStruct = nameValuePairToStruct(struct,varargin);
validStruct = struct('val',0,'njets',0);

if (sum(ismember(fieldnames(paramStruct),fieldnames(validStruct))) ~= length(fieldnames(paramStruct)))
  error('Fieldnames of structures do not correspond. Check Name-value pairs in the function input.')
end

ext = '.mat';
dataDim = 42;

if isreal(lepJetType)
  lepJetType = leptonJetType(lepJetType);
end

[str] = loadLocalConfig('local-config.xml');

dirMuo = str.dir.muo;
dirEle = str.dir.ele;
%dirMuo = '/work/budvar-clued0/francji/tt_leptonjets/samples_txt/split_trees_3samples_muo_1119';
%dirEle = '/work/budvar-clued0/francji/tt_leptonjets/samples_txt/split_trees_3samples_ele_1119';

if strcmp(muoEle, 'muo')
  dir = dirMuo;
elseif strcmp(muoEle, 'ele')
  dir = dirEle;
end

lepJetLength = length(lepJetType);
filename = cell(lepJetLength,1);
for k = 1:lepJetLength
  filename{k} = [lepJetType(k).toString '_miniTree' ext];
  if strcmp(dir,dirMuo)
    filename{k} = strrep(filename{k}, 'EE', 'MuMu');
  end
end

X = cell(lepJetLength);
for k = 1:lepJetLength
  try
    Xtmp = load([dir '/' filename{k}]);
    X{k} = [Xtmp.X(:,1:dataDim)   double(lepJetType(k).abs)*ones(size(Xtmp.X,1),1)   Xtmp.X(:,end-2:end)];
    disp([leptonJetType(k).toString()]);
    disp(['    Loaded: W = ', num2str(sum(Xtmp.X(:,end))),', N = ',num2str(size(Xtmp.X,1))])
  catch e
    disp(['Could not load: ' dir '/' filename{k} ])
    disp(e)
  end
end

% last columns ofSS8S X: "NJets","type ","Weight","train","val"
% try	train = getfield(paramStruct, 'train');
%   for k = 1:lepJetLength
%     Y = X{k};
%     Y = Y(Y(:,end-1)==train,:);
%     X{k} = Y;
%   end
% end
try val = getfield(paramStruct,'val');
  for k = 1:lepJetLength
    Y = X{k};
    Y = Y(Y(:,end-2)==val,:);
    X{k} = Y;
  end
end
try njets = getfield(paramStruct,'njets');
  for k = 1:lepJetLength
    Y = X{k};
    if njets >=4
      Y = Y(Y(:,end-1)>=njets,:);
    end
    Y = Y(Y(:,end-1)==njets,:);
    X{k} = Y;
  end
end

Z = [];
for k = 1:lepJetLength
  Z = [Z;X{k}];
end
data = Z(:,1:dataDim);
weight = Z(:, end);
last6cols = Z(:, end-3:end);
end

