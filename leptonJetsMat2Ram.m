function leptonJetData = leptonJetsMat2Ram()
% loads all the lepJet data into one matrix

[data, ~, last6cols]= getLeptonJetsMatData('muo',1:leptonJetType.numTypes);
leptonJetData.muo = [data, last6cols];

[data, ~, last6cols]= getLeptonJetsMatData('ele',1:leptonJetType.numTypes);
leptonJetData.ele = [data, last6cols];

end