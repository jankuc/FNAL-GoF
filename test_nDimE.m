function [e z stat] = test_nDimE(x1,x2,alpha)
n1 = size(x1,1);
n2 = size(x2,1);
z = En1n2(x1,x2);
p = 2*normcdf(-abs(z));
stat = nan;
chiQuant1 = icdf('norm', alpha/2, 0,1);
chiQuant2 = icdf('norm',1 - alpha/2,0,1);
my = icdf('norm',z,0,1);
h = (p<=alpha);
end


function e = En1n2(x1,x2)
n1 = size(x1,1);
n2 = size(x2,1);

A = 0; B = 0; C = 0;

for i = 1:n1
	for m = 1:n2
		A = A + norm(x1(i,:) - x2(m,:));
	end
end
A = 2/(n1*n2) * A;

for i = 1:n1
	for j = i+1:n1
		B = B + norm(x1(i,:) - x1(j,:));
	end
end
B = 2/(n1^2) * B;

for l = 1:n2
	for m = l+1:n2
		C = C + norm(x2(l,:) - x2(m,:));
	end
end
C = 2/(n2^2) * C;

e = n1*n2 / (n1 + n2) * (A - B - C);
end
