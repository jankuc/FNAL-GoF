function [ data, weight ] = getLeptonJetsData(muoEle,lepJetType,varargin)
%	[ data, weight ] =  getLeptonJetsData(muoEle,lepJetType,varargin)
%
%
%	muoEle:		'muo', 'ele'
%	lepJetType:	leptonJetType, [leptonJetType1,leptonJetType2,...],[1:18]
%	train:		0...yield, data - maybe duplicit variable
%				1...train, test
%	val:		0... yield, data
%				1... train
%				2... test
%	njets:		2-7 (data), 2-8 (MC)
%	type:		?

paramStruct = nameValuePairToStruct(struct,varargin);

spc = '_';
ext = '.txt';
dataDim = 25;

if isreal(lepJetType)
	lepJetType = leptonJetType(lepJetType);
end

dirMuo = '/data/tt_leptonjets/samples_txt/split_trees_3samples_muo_1119';
dirEle = '/data/tt_leptonjets/samples_txt/split_trees_3samples_ele_1119';

if strcmp(muoEle, 'muo')
	dir = dirMuo;
elseif strcmp(muoEle, 'ele')
	dir = dirEle;
end
lepJetLength = length(lepJetType);
for k = 1:lepJetLength
	filename{k} = [lepJetType(k).toString ext];
end

for k = 1:lepJetLength
	try
		X{k} = importdata([dir '/' filename{k}]);
	catch
		disp(['Could not load: ' dir '/' filename{k} ])
	end
end
if size(X{1},2)~=30
	error('ERROR: Format of data has changed.')
end

% last columns of X: "NJets","type","Weight","train","val"
try	train = getfield(paramStruct, 'train');
	for k = 1:lepJetLength
		Y = X{k};
		Y = Y(Y(:,end-1)==train);
		X{k} = Y;
	end
end
try val = getfield(paramStruct,'val');
	for k = 1:lepJetLength
		Y = X{k};
		Y = Y(Y(:,end)==val);
		X{k} = Y;
	end
end
try njets = getfield(paramStruct,'njet');
	for k = 1:lepJetLength
		Y = X{k};
		Y = Y(Y(:,end-4)==njets);
		X{k} = Y;
	end
end
try type = getfield(paramStruct,'type');
	for k = 1:lepJetLength
		Y = X{k};
		Y = Y(Y(:,end-3)==type);
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

