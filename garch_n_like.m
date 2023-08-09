function [LLF, LLF_contr, h] = garch_n_like(parameters , data , arch , garch)
% PURPOSE:
%     Function designed to estimate the likelihood for the univariate Garch model.
%
%
% USAGE:
%     [results] = uni_garch_like(startparam, data, arch, garch,
%
%
% INPUTS:
%     startparam     - A vector with the starting values [constant arch garch]
%     data           - A matrix m x n of data input (m: # of observations, n: # of time series
%     arch           - # of arch coefficients in uni variance equations
%     garch          - # of garch coefficients in uni variance equation
%
%
%
%RETURNS:
%          LogLike       = the value of maximumized log likelihood
%          h             = estimated conditional variance
%          likelihoods   = the likelihoods
%
% COMMENTS:
%
%
%
%
% Authors:
%
% Date: 03/2009
%%%%%%%%%%%%%%%%%%
% check and arrange the starting values


[r,c]=size(parameters);
if c>r
    parameters=parameters';
end


% parameters(find(parameters(1:end-nr) <= 0)) = realmin;




if isempty(garch)
    m=arch;
else
    m  =  max(arch,garch);
end
T=size(data,1);

constp=parameters(1);
archp=parameters(2:arch+1);
garchp=parameters(arch+2:arch+garch+1);

h = garch_simulate(data,arch,garch,constp,archp,garchp);



LLF_contr=zeros(T,1);

if all(h>0)
    
    LLF_contr = -0.5*(log(2*pi*h)+ data.^2./h);    
    LLF = -sum(LLF_contr);
else
    LLF=1e06;
end


