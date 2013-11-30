function [ data, weight ] = getLeptonJetsRamData(muoEle,lepJetType, varargin)
%	[ data, weight ] =  getLeptonJetsRamData(muoEle, lepJetType, varargin)
%
% Loads mixture of specified sets of leptonJetTypes.
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

try leptonJetData = evalin( 'base', 'leptonJetData' );
catch
  leptonJetData = LeptonJetsMat2Ram(); 
  assignin('base', 'leptonJetData', leptonJetData);
end

Y = getfield(leptonJetData,muoEle);

if ~isreal(lepJetType)
  lepJetType = lepJetType.abs;
end

if length(lepJetType) ~= leptonJetType.numTypes
  Y = Y(ismember(Y(:,end-5),lepJetType),:);
end

paramStruct = nameValuePairToStruct(struct,varargin);
validStruct = struct('train',0,'val',0,'njets',0,'type',0);

if (sum(ismember(fieldnames(paramStruct),fieldnames(validStruct))) ~= length(fieldnames(paramStruct)))
  error('Fieldnames of structures do not correspond. Check Name-value pairs in the function input.')
end

dataDim = 25;

% last columns of X: "NJets","type","Weight","train","val"
try	train = getfield(paramStruct, 'train');
    Y = Y(Y(:,end-1)==train,:); 
end
try val = getfield(paramStruct,'val');
    Y = Y(Y(:,end)==val,:);
end
try njets = getfield(paramStruct,'njets');
    if njets >=4
      Y = Y(Y(:,end-4)>=njets,:);
    end
    Y = Y(Y(:,end-4)==njets,:);
end
try type = getfield(paramStruct,'type');
    Y = Y(Y(:,end-3)==type,:);
end

data = Y(:,1:dataDim);
weight = Y(:, end-2);

end

