
n1 = 1e3;
n2 = 1e3;

mu_bMC1     = [11  11];
mu_sMC1     = [9    9];
Sigma_bMC1  = [8  0;  0  3]; 
Sigma_sMC1  = [12 0;  0  10]; 

mu_bMC2     = [11  11];
mu_sMC2     = [11  11];
Sigma_bMC2  = [8 0; 0 3 ]; 
Sigma_sMC2  = [8 0; 0 4]; 

mu_bData    = [10  10];
mu_sData    = [13.5 13.5];
Sigma_bData = [10 0; 0 2  ]; 
Sigma_sData = [5  0; 0 0.2]; 

bMC1   = mvnrnd(mu_bMC1,Sigma_bMC1,n1);
sMC1   = mvnrnd(mu_sMC1,Sigma_sMC1,n2);
bMC2   = mvnrnd(mu_bMC2,Sigma_bMC2,n1);
sMC2   = mvnrnd(mu_sMC2,Sigma_sMC2,n2);
bData  = mvnrnd(mu_bData,Sigma_bData,1160);
sData  = mvnrnd(mu_sData,Sigma_sData,40);


pdf_bMC1  = mvnpdf(bMC1, mu_bMC1, Sigma_bMC1);
pdf_sMC1  = mvnpdf(sMC1, mu_sMC1, Sigma_sMC1);
pdf_bMC1w = mvnpdf(bMC1, mu_bMC2, Sigma_bMC2);
pdf_sMC1w = mvnpdf(sMC1, mu_sMC2, Sigma_sMC2);
pdf_bMC1 = pdf_bMC1w./pdf_bMC1;
pdf_sMC1 = pdf_sMC1w./pdf_sMC1;
w_bMC1 = 1160*pdf_bMC1/sum(pdf_bMC1);
w_sMC1 = 40*pdf_sMC1/sum(pdf_sMC1);
% mean(w_bMC1)
% sum(w_bMC1)
% mean(w_sMC1)
% sum(w_sMC1)

Xb1 = bMC1;
wb1 = w_bMC1;

Xs1 = sMC1;
ws1 = w_sMC1;

Xb2 = bMC2;
wb2 = 1/size(bMC2,1)*ones(size(bMC2,1),1);

Xs2 = sMC2;
ws2 = 1/size(sMC2,1)*ones(size(sMC2,1),1);


%% 1-D
type{1}= 'kolm-smirn';
type{2} = 'cramer';
type{3} = 'ranksum';
type{4} = 'kstest2';
testType = type{1};

h1d = nan(size(Xb1,2),1); 
p1d = h1d; 
stat1d = h1d;
for k = 1:2
	[h1d(k), p1d(k), stat1d(k)] = test1DEquality(Xb1(:,k), wb1, Xs1(:,k), ws1, testType);
    disp(['Test ', testType, ' dim ', num2str(k), ' ended.' ])
end

[h1d p1d stat1d]

[h p st] = test_wKS2s2d(Xs1,ws1,Xs2,ws2,0.05);
%[h p st] = test_KS2s2d(Xb1,Xs2,0.05);
[h p st]
