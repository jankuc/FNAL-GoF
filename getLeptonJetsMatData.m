function [ data, weight ] = getLeptonJetsMatData(muoEle,lepJetType,varargin)
%	[ data, weight ] =  getLeptonJetsData(muoEle,lepJetType,varargin)
%
%
%	muoEle:		'muo', 'ele'
%	lepJetType:	leptonJetType, [leptonJetType1,leptonJetType2,...],[2:18]
%	train:		0...yield, data - maybe duplicit variable
%				1...train, test
%	val:		0... yield, data
%				1... train
%				2... test
%	njets:		2-7 (data), 2-8 (MC)
%	type:		?

paramStruct = nameValuePairToStruct(struct,varargin);
validStruct = struct('train',0,'val',0,'njets',0,'type',0);

if (sum(ismember(fieldnames(paramStruct),fieldnames(validStruct))) ~= length(fieldnames(paramStruct)))
    error('Fieldnames of structures do not correspond. Check Name-value pairs in the function input.')
end

ext = '.mat';
dataDim = 25;

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
end

X = cell(lepJetLength);
for k = 1:lepJetLength
    try
        Xtmp = load([dir '/' filename{k}]);
        X{k} = Xtmp.X;
    catch e
        disp(['Could not load: ' dir '/' filename{k} ])
        disp(e)
    end
end

% last columns of X: "NJets","type","Weight","train","val"
try	train = getfield(paramStruct, 'train');
    for k = 1:lepJetLength
        Y = X{k};
        Y = Y(Y(:,end-1)==train,:);
        X{k} = Y;
    end
end
try val = getfield(paramStruct,'val');
    for k = 1:lepJetLength
        Y = X{k};
        Y = Y(Y(:,end)==val,:);
        X{k} = Y;
    end
end
try njets = getfield(paramStruct,'njets');
    for k = 1:lepJetLength
        Y = X{k};
        Y = Y(Y(:,end-4)==njets,:);
        X{k} = Y;
    end
end
try type = getfield(paramStruct,'type');
    for k = 1:lepJetLength
        Y = X{k};
        Y = Y(Y(:,end-3)==type,:);c
        X{k} = Y;
    end
end

Z = [];
for k = 1:lepJetLength
    Z = [Z;X{k}];
end
data = Z(:,1:dataDim);
weight = Z(:, end-2);

end

