n = 100;
x = randn(n,1);
w = ones(n,1);
xNew = sort(randn(n,1));

eCDF = wECDF(x,w,xNew);
figure(1)
stairs(xNew, eCDF);

[ePDF, xNew] =  wEPDF(x,w,xNew,length(x));
figure(2)
stairs(xNew,ePDF);
