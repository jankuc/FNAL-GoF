function tab = tableOfQuantiles(muoEle, njets)
%function tab = tableOfQuantiles(muoEle, njets)


[X w] = getLeptonJetsRamData(muoEle, 2:18, 'njets', njets);

p1 = 0.025;
p2 = 0.975;
p1 = 0.005;
p2 = 0.995;
tab = [];
for v = 1:size(X,2);
  x = X(:,v);
  % filter out NaNs
  arenan = isnan(x);
  wf = w(~arenan);
  xf = x(~arenan);
  
  % filter out negative for Masses
  if ismember(v,6:14)
    areBelowZero1 = xf < 0;
    wf = wf(~areBelowZero1);
    xf = xf(~areBelowZero1);
  end
  
  
  line = wprctile(xf, [p1, p2], wf);
  tab = [tab; v, line];
end