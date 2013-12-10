function makeHistograms(particleIn, njetsIn, doData)
% makeHistograms(particleIn, njetsIn)
%
% particleIn: 1 ... ele, 2 ... muo
% njetsIn: 2,3,4
% doData:
%   data{1} = {'Train + Test vs. Yield',  'train',1,0};
%   data{2} = {'Train vs. Test',          'val',1,2};
%   data{3} = {'Train + Test vs. Data',   'train',1,3};
%   data{4} = {'Yield vs. Data',          'train', 0,3};

particle{1} = 'ele';
particle{2} = 'muo';
doParticle = particleIn;

data{1} = {'Train + Test vs. Yield',  'train',1,0};
data{2} = {'Train vs. Test',          'val',1,2};
data{3} = {'Train + Test vs. Data',   'train',1,3};
data{4} = {'Yield vs. Data',          'train', 0,3};

nJets{2} = 2;
nJets{3} = 3;
nJets{4} = 4;
doNJets = njetsIn;

weighted{1} = 1;
%weighted{2} = 0;

for k = doParticle
  for l = doData
    for m = doNJets
      for n = 1:length(weighted)
        vars = [1:25];
        njets = nJets{m};
        
        [X1, w1] = getLeptonJetsRamData(particle{k}, 1:leptonJetType.numTypes,...
          'njets', nJets{m}, data{l}{2}, data{l}{3});
        [X2, w2] = getLeptonJetsRamData(particle{k}, 1:leptonJetType.numTypes,...
          'njets', nJets{m}, data{l}{2}, data{l}{4});
        
        %         wYi = sum(w1)
        %         wDa = sum(w2)
        %         continue
        
        for v = vars
          
          currVar = leptonJetVar(v);
          
          %[XX1, ww1] = cropVarToHistInterval(X1(:,v),w1,v);
          %[XX2, ww2] = cropVarToHistInterval(X2(:,v),w2,v);
          
          % filter out NaNs
          arenan1 = isnan(X1(:,v));
          w1f = w1(~arenan1);
          X1f = X1(~arenan1,v);
          arenan2 = isnan(X2(:,v));
          w2f = w2(~arenan2);
          X2f = X2(~arenan2,v);
          
          % filter out negative for Masses
          if ismember(v,6:14)
            areBelowZero1 = X1f < 0;
            w1f = w1f(~areBelowZero1);
            X1f = X1f(~areBelowZero1);
            areBelowZero2 = X2f < 0;
            w2f = w2f(~areBelowZero2);
            X2f = X2f(~areBelowZero2);
          else
            areBelowZero1 = nan;
            areBelowZero2 = nan;
            
          end
          testType = 'cramer';
          [hyp, pval, stat] = ...
            test1DEquality(X1f, w1f, X2f, w2f, testType);
          nbin1 = 60;
          try
            [a, b] = currVar.histInterval(njets);
            %           max1 = max(X1f);
            %           min1 = min(X1f);
            %           d1 = (max1 - min1)/nbin1;
            %           max2 = max(X2f);
            %           min2 = min(X2f);
            %           nbin2 = floor((max2-min2)/d1);
            [f1, x1] = histwc(X1f, w1f,nbin1,a, b);
            [f2, x2] = histwc(X2f, w2f,nbin1, a, b);
            f2 = [f2; zeros(length(f1) - length(f2),1)];
            f1 = [f1; zeros(length(f2) - length(f1),1)];
          catch
            
          end
          x = x1;
          if length(x2) > length(x1)
            x = x2;
          end
          
          %% figure
          h = figure(1000*v + 100*l+ 10*k + m);
          subplot(2,1,1)
          bar(x,[f1 f2], 0.9, 'LineStyle', 'none')
          colormap(copper)
          
          % Legend
          vs = ' vs. ';
          legendTitle1 = data{l}{1}(1: strfind(data{l}{1}, vs)-1);
          legendTitle2 = data{l}{1}((strfind(data{l}{1}, vs) + length(vs)):end);
          sw1 = floor(sum(w1f));
          sw2 = floor(sum(w2f));
          sn1 = sum(arenan1);
          sn2 = sum(arenan2);
          sbz1 = sum(areBelowZero1);
          sbz2 = sum(areBelowZero2);
          
          legend([legendTitle1 ', w = ' num2str(sw1) ', #NaN: ' num2str(sn1) ', #M<0: ' num2str(sbz1)],...
            [legendTitle2  ', w = ' num2str(sw2) ', #NaN: ' num2str(sn2) ', #M<0: ' num2str(sbz2)])
          
          % Title
          vv= axis;
          titl = [particle{k}, ': ', data{l}{1}, ' nJets: ', num2str(nJets{m}),...
            ' weighted: ',num2str(weighted{n}),' var: ',num2str(v), ' - ' currVar.toString];
          th = title(sprintf([titl '\n H=' num2str(hyp) ', pval=' num2str(pval)])); %, 'EdgeColor','k');
          %set(th, 'Position',[vv(2)*0.45,vv(4)*0.7, 0])
          
          subplot(2,1,2)
          hPomer = bar(x, f2-f1,'k');
          set(hPomer(1),'BaseValue',1);
          saveas(h,['figs-YiDa-cramer/' titl '.png']);
          
        end
      end
    end
  end
end

