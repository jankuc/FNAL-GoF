function [ data, weight ] = getLeptonJetsRamData(muoEle,lepJetType, varargin)
% [ data, weight ] =  getLeptonJetsRamData(muoEle, lepJetType, varargin)
%
% Loads mixture of specified sets of leptonJetTypes.
%
%       muoEle:       'muo', 'ele'
%       lepJetType:   leptonJetType, [leptonJetType1,leptonJetType2,...] or [2:18]
%
% VARARGIN:
%       val:    0... yield
%               1... train
%               2... test
%               3... data
%       njets:        2, 3, 4==(4,5,...)
%       type:         0... background ?
%  
%   EXAMPLE: getLeptonJetsRamData('muo',2:18, 'njets', 2:4, 'val', 0)
%     loads all of the channels of muon, all jets (2,3,4) and gets only
%     yield sample
%
%     getLeptonJetsRamData('muo',2:18, 'njets', 2:4, 'val', [0,1,2])
%         loads whole MC.

try leptonJetData = evalin( 'base', 'leptonJetData' );
catch
  leptonJetData = leptonJetsMat2Ram();
  assignin('base', 'leptonJetData', leptonJetData);
end

Y = getfield(leptonJetData,muoEle);

if ~isreal(lepJetType)
  lepJetType = lepJetType.abs;
end

if length(lepJetType) ~= leptonJetType.numTypes
  Y = Y(ismember(Y(:,end-3),lepJetType),:);
end

paramStruct = nameValuePairToStruct(struct,varargin);
validStruct = struct('val',0,'njets',0, 'type',0);

if (sum(ismember(fieldnames(paramStruct),fieldnames(validStruct))) ~= length(fieldnames(paramStruct)))
  error('Fieldnames of structures do not correspond. Check Name-value pairs in the function input.')
end

dataDim = 42;

% last columns of X: "", "NJets","type","Weight","train","val"

try njets = getfield(paramStruct,'njets');
  if (length(njets)==1 && njets >=4)
    Y = Y(Y(:,end-1)>=njets,:);
  else
    yFlagsCol = Y(:,end-1);
    logic = njets;
    Y = filterRows(Y, yFlagsCol, logic);
  end
end

try val = getfield(paramStruct,'val');
  yFlagsCol = Y(:,end-2);
  logic = val;
  Y = filterRows(Y, yFlagsCol, logic);
end

try type = getfield(paramStruct, 'type');
  warning('Column TYPE is not supported in new tt_leptonjets 42 data.');
end

data = Y(:,1:dataDim);
weight = Y(:, end);

end

function Y = filterRows(Y, yFlagsCol, logic)
  logic = logic(:)';
  if length(logic) > 1
    YFlagsRep = repmat(yFlagsCol,1,length(logic));
    logicRep = repmat(logic, size(YFlagsRep,1),1);
    Y = Y(sum(YFlagsRep==logicRep,2)>0,:);
  else
    Y = Y(yFlagsCol==logic,:);
  end
end
