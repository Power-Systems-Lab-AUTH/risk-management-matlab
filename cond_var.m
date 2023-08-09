function [Var Corr Cov] = cond_var(Ht);
% PURPOSE:
%     Function designed to extract the conditional variances from the VarianceCovariance matrix.
%
%
% USAGE:
%     [var_vector] = cond_var(var_cov)
%
%
% INPUTS:
%     data     - A matrix n x n x m of data input (m: # of observations, n: # of time series
%
%
%RETURNS:
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
%
% Date: 03/2009


[n n r]=size(Ht);

Var=nan(r,n);
Corr=nan(r,floor(n*(n-1)/2));
Cov=nan(r,floor(n*(n-1)/2));
for t=1:r
    
    
    H1=Ht(:,:,t);
    if all(all(~isnan(H1)))
        if any(any(H1~=H1'));
            H1=0.5*(H1+H1');
        end
%         t
        Var(t,:)=diag(H1)';
        Cov(t,:)=corr_vech(H1);
        Corr(t,:)=corr_vech(H1./(sqrt(Var(t,:)')*sqrt(Var(t,:))));
    end
end
