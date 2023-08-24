% function [dx] = fracdiff(x, d)
% Andreas Noack Jensen & Morten Ã?rregaard Nielsen
% May 10, 2013
%
% fracdiff(x, d) is a fractional differencing procedure based on the fast fractional
%	differencing algorithm in
%
% Jensen and Nielsen (2013). A fast fractional differencing algorithm.
%	QED working paper 1307, Queen's University.
%
% input = vector of data x
%       scalar d is the value at which to calculate the fractional difference.
% 
% output = vector (1-L)^d x of same dimension as x.

function [dx b] = fracdiff_fast(x, d)

    T = size(x, 1);
    np2 = 2.^nextpow2(2*T - 1);
    k = (1:T-1)';
    b = [1; cumprod((k - d - 1)./k)];
    dx = ifft(fft(x, np2).*fft(b, np2));
    dx = dx(1:T,:);
end