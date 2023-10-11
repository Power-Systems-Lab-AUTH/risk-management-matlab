function[dx,b] = fracdiff(x,d)
% function[dx] = fracdiff(x,d)
%
% fractional differencing procedure
%
% input = x,d
% output = (1-L)^d x
%
% THIS IS A NEW VERSION THAT USES FILTER INSTEAD OF CONV.
%
%			Katsumi Shimotsu, September 2003
%______________________________________________________

[n,dum] = size(x);
k = 1:1:n-1;
k = k';
b = (k-d-1)./k;
b = [1; cumprod(b)];
dx = filter(b,1,x);
y=1