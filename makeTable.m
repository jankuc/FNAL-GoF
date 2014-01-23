function res = makeTable(particleIn, njetsIn, doData)
% function res = makeTable(particleIn, njetsIn, doData)
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

vars = 1:23;
if doParticle == 1
  vars = [vars, 24];
end

%% headr of table
kk = 1;
res = cell(24,8);
res{kk,1} = 'PARTICLE';
res{kk,2} = 'SETS';
res{kk,3} = 'NJETS';
res{kk,4} = 'VAR #';
res{kk,5} = 'VAR NAME';
res{kk,6} = 'H KS';
res{kk,7} = 'PVAL KS';
res{kk,8} = 'STAT KS';
res{kk,9} = 'H Cramer';
res{kk,10} = 'PVAL Cramer';
res{kk,11} = 'STAT Cramer';
res{kk,12} = 'STAT Renyi';
numResults = 1;

try leptonJetData = evalin( 'base', 'leptonJetData' );
catch
  leptonJetData = leptonJetsMat2Ram();
  assignin('base', 'leptonJetData', leptonJetData);
end

for k = doParticle
  for l = doData
    for m = doNJets
      njets = nJets{m};
      for n = 1:length(weighted)
        
        [X1, w1] = getLeptonJetsRamData(particle{k}, 1:leptonJetType.numTypes,...
          'njets', nJets{m}, data{l}{2}, data{l}{3});
        [X2, w2] = getLeptonJetsRamData(particle{k}, 1:leptonJetType.numTypes,...
          'njets', nJets{m}, data{l}{2}, data{l}{4});
        
        %         wYi = sum(w1)
        %         wDa = sum(w2)
        %         continue
        
        for v = vars
          % skip Lepemv (v==24) for muon (k==2)
          if k == 2 && v == 24
            continue
          end
          % skipt HT3 (v==5) for 2 jets
          if njets == 2 && v == 5
            continue
          end
          try
            numResults = numResults + 1;
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
              areBelowZero1 = logical(zeros(size(w1f)));
              areBelowZero2 = logical(zeros(size(w2f)));
            end
            
            %% resampling
            
            
            
            testType = 'kolm-smirn';
            [hypKS, pvalKS, statKS] = ...
              test1DEquality(X1f, w1f, X2f, w2f, testType);
            
            testType = 'cramer';
            [hypC, pvalC, statC] = ...
              test1DEquality(X1f, w1f, X2f, w2f, testType);
            
%             testType = 'renyi';
%             nbins = [25, 50, 100, 200, 1000, 2000];
%             for ren = 1:length(nbins);
%               nbin = nbins(ren);
%               renyiAlpha = 0.3;
%               [hypR, pvalR, statR{ren}] = ...
%               test1DEquality(X1f, w1f, X2f, w2f, testType, renyiAlpha, nbin, a, b);
%               statR{ren} = 0;
%             end
            
            %lepton, dataSet, nJets, var, H, pVal, stat
            %[k, l, njets, v, hyp, pval, stat]
            kk = numResults;
            res{kk,1} = particle{k};
            res{kk,2} = data{l}{1};
            res{kk,3} = njets;
            res{kk,4} = v;
            res{kk,5} = leptonJetVar(v).toString;
            res{kk,6} = hypKS;
            res{kk,7} = pvalKS;
            res{kk,8} = statKS;
            res{kk,9} = hypC;
            res{kk,10} = pvalC;
            res{kk,11} = statC;
            for ren = 1:length(nbins);
              res{kk,11 + ren} = statR{ren};
            end
            
            %% Histograms
            nbin1 = 60;
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
            sw1 = sum(w1f);
            sw2 = sum(w2f);
            sn1 = sum(w1(arenan1));
            sn2 = sum(w2(arenan2));
            sbz1 = sum(w1fbz(areBelowZero1));
            sbz2 = sum(w2fbz(areBelowZero2));
            
            legend([legendTitle1 ', w = ' num2str(floor(sw1)) ', #NaN: ' num2str(sn1),...
              ', #M<0: ' num2str(sbz1)],...
              [legendTitle2  ', w = ' num2str(floor(sw2)) ', #NaN: ' num2str(sn2),...
              ', #M<0: ' num2str(sbz2)])
            
            % Title
            vv= axis;
            titl = [particle{k}, '_ ', data{l}{1}, ' nJets: ', num2str(nJets{m}),...
              ' var  ',num2str(v), ...
              ' - ' currVar.toString];
            title(sprintf([titl '\n pval=',...
              num2str(pvalKS)])); %, 'EdgeColor','k');
            %set(th, 'Position',[vv(2)*0.45,vv(4)*0.7, 0])
            
            subplot(2,1,2)
            title('Rozdil histogramu.')
            hPomer = bar(x, (f2-f1),'k');
            set(hPomer(1),'BaseValue',0);
            drawnow
            mkdir(data{l}{1});
            saveas(h,[data{l}{1} '/' titl '.png']);
            %end
            close all
          end
        end
        end
      end
    end
  end
end


% for kk = 1:numResults
%   disp([res{kk,1} '_' res{kk,2} '_njets-' num2str(res{kk,3}),...
%             '_var-' num2str(res{kk,4}) '-' res{kk,5} '_H=' num2str(res{kk,6}),...
%             '_pval=' num2str(res{kk,7}) '_stat=' num2str(res{kk,8})  ])
% end
