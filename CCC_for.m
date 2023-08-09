function mcov_for=CCC_for(parameters,u_sim,VaRCoV,stdresid,arch,garch)
% PURPOSE:
%     Function designed to perform 1-step forecast for the variance-covariance matrix based on CCC model
%
%
% USAGE:
%     [results] = DCCcov(data, arch, garch, dccarch, dccgarch)
%
%
% INPUTS:
%       parameters  - the parameters for the univariate conditional variances
%       data        - a vector of residuals
%       h           - the estimated conditional variances
%       arch        - # of arch coefficients in uni variance equations
%       garch       - # of garch coefficients in uni variance equation
%
%
%
%RETURNS:
%
%
%
%
%
%
%
% COMMENTS:
%
%
%
%
% Authors:

nX=cols(exog);
[t,k]=size(data);

if ~(isempty(arch) | length(arch)==1 | length(arch)==k)
    error('Wrong size for archP')
end

if ~(isempty(garch) | length(garch)==1 | length(garch)==k)
    error('Wrong size for garchQ')
end

if isempty(arch)
    arch=ones(1,k);
elseif length(arch)==1
    arch=ones(1,k)*arch;
end

if isempty(garch)
    garch=ones(1,k);
elseif length(garch)==1
    garch=ones(1,k)*garch;
end



h=diag(VaRCoV)';
index=1;
h_f=nan(1,k);

for i=1:k
    univariateparameters=parameters(index:index+arch(i)+garch(i)+nX);
    h_f(1,i) = gardch_for(univariateparameters, data(end,i) ,h(i), arch(i) ,garch(i),exog(end,:));
    index=index+arch(i)+garch(i)+1+nX;
end

if any(h_f<0)
    h_f(h_f<0)=h(h_f<0);
end

R=corr(stdresid);

Hstd_f=h_f.^(0.5);

mcov_for=diag(Hstd_f(1,:))*R*diag(Hstd_f(1,:));