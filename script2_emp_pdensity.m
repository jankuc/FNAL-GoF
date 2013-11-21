n = 100;
x = randn(n,1);
w = ones(n,1);
xNew = sort(randn(n,1));



eCDF = wECDF(x,w,xNew);
figure(1)
stairs(xNew, eCDF);

% [ePDF, xNew] =  wEPDF(x,w,xNew,length(x));
% figure(2)
% stairs(xNew,ePDF);

kernels{1} = 'normal';
kernels{2} = 'box';
kernels{3} = 'triangle';
kernels{4} = 'epanechnikov';

for k = 1:4
	figure(k+2)
	kpdf = ksdensity(x, xNew, 'kernel', kernels{k});
	stairs(xNew, kpdf);
end
