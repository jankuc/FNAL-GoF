% amount of data
nTraining = 000;
nTesting = 000;

% Loading of data
try
  if dataAlreadyDefined && nTraining==nTrainingOld && nTesting==nTestingOld
    disp('Data are already defined, I continue without loading them.');
  else
    [data, flags, weights, dataAlreadyDefined] = DT_loadFNALData(nTraining,nTesting);
    nTrainingOld = nTraining;
    nTestingOld = nTesting;
  end
catch
  [data, flags, weights, dataAlreadyDefined] = DT_loadFNALData(nTraining,nTesting);
  nTrainingOld = nTraining;
  nTestingOld = nTesting;
end

mcBool = flags < 100;
mcData = data(mcBool,:);
mcWeights = weights(mcBool);
mcFlags = flags(mcBool);
exBool = flags >= 100;
exData = data(exBool,:);
exWeights = weights(exBool);
exFlags = flags(exBool) - 100;

[h, p, stat] = mcDataEquality(mcData, mcWeights, mcFlags, exData, exWeights, exFlags);

tmp = h{1};
for l = 1:length(tmp)
  if tmp(l)
    disp(strcat('Variable num.  ', num2str(l), ' has problem'))
  end
end

disp('Done');