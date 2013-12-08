
particle{1} = 'ele';
particle{2} = 'muo';
doParticle = [2];

data{1} = {'Train + Test vs. Yield','train',1,0};
data{2} = {'Train vs. Test','val',1,2};
data{3} = {'Train + Test vs. Data','train',1,3};
data{4} = {'Yield vs. Data','train',0,3};
doData = [4];

nJets{1} = 2;
nJets{2} = 3;
nJets{3} = 4;
doNJets = [2 3];

weighted{1} = 1;
%weighted{2} = 0;

for k = doParticle
  for l = doData
    for m = doNJets
      for n = 1:length(weighted)
        vars = [1];
        njets = nJets{m};
        
        [X1 w1] = getLeptonJetsRamData(particle{k}, 1:leptonJetType.numTypes,...
          'njets', nJets{m}, data{l}{2}, data{l}{3});
        [X2 w2] = getLeptonJetsRamData(particle{k}, 1:leptonJetType.numTypes,...
          'njets', nJets{m}, data{l}{2}, data{l}{4});
        
        %         wYi = sum(w1)
        %         wDa = sum(w2)
        %         continue
        
        for v = vars
          testType = 'kolm-smirn';
          [hyp, pval, stat] = ...
            test1DEquality(X1(:,v), w1, X2(:,v), w2, testType);
          nbin1 = 60;
          [f1, x1] = histwc(X1(:,v), w1,nbin1);
          max1 = max(X1(:,v));
          min1 = min(X1(:,v));
          d1 = (max1 - min1)/nbin1;
          max2 = max(X2(:,v));
          min2 = min(X2(:,v));
          nbin2 = floor((max2-min2)/d1);
          [f2, x2] = histwc(X2(:,v), w2,nbin2);
          f2 = [f2; zeros(length(f1) - length(f2),1)];
          f1 = [f1; zeros(length(f2) - length(f1),1)];
          
          x = x1;
          if length(x2) > length(x1)
            x = x2;
          end
          
          h = figure;
          subplot(2,1,1)
          bar(x,[f1 f2], 0.98)
          colormap(autumn)
          
          % Legend
          vs = ' vs. ';
          legendTitle1 = data{l}{1}(1: strfind(data{l}{1}, vs)-1);
          legendTitle2 = data{l}{1}((strfind(data{l}{1}, vs) + length(vs)):end);
          legend(legendTitle1,legendTitle2)
          
          % Title
          vv= axis;
          titl = [particle{k}, ': ', data{l}{1}, ' nJets: ', num2str(nJets{m}),...
            ' weighted: ',num2str(weighted{n}),' var: ', num2str(v)];
          th = title(sprintf([titl '\n H=' num2str(hyp) ', pval=' num2str(pval)])); %, 'EdgeColor','k');
          %set(th, 'Position',[vv(2)*0.45,vv(4)*0.7, 0])
          
          subplot(2,1,2)
          hPomer = bar(x, f2-f1, 0.4,'k');
          set(hPomer(1),'BaseValue',1);
          saveas(h,['figures/' titl], 'png');
        end
      end
    end
  end
end

