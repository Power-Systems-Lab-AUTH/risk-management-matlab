function corr_model=CCC_sim(cov_model, u_sim)
% PURPOSE:
%     Function designed to estimate the CCC model.
%
%
% USAGE:
%     [results] = DCCcov(data, arch, garch, dccarch, dccgarch)
%
%
% INPUTS:
%       data     - A matrix m x n of data input (m: # of observations, n: # of time series
%       dccarch  - # of alpha coefficient in DCC model
%       dccgarch - # of beta coefficient in DCC model
%       arch     - # of arch coefficients in uni variance equations
%       garch    - # of garch coefficients in uni variance equation
%
%
%
%RETURNS: a structure:
%                   results.CovCCC =             VarianceCovariance matrix
%                   results.CoefCCC =            Vector with the estimated parameters
%                   results.Optim_LoglikeCCC =   LogLike at the optimum
%                   results.likelihoodsCCC =     Estimated likelihoods
%                   results.VarCCC=              Time varying variances for each time series
%                   results.CorrCCC=             Matrix of estimated constant correlations
%
% COMMENTS:
%
%
%
%
% Authors:
%
% Date: 03/2009


%%%%%%    VarianceCovariance matrix   %%%%%%




parameters=corr_model.Coef;

for 
mcov_for=CCC_step(mcov_0,e0,marginal_params,CCC_params)





Resid=corr_model.data;
marginal_models=corr_model.marginal_models;

%We now have Ht and the likelihood


[numobs numvars]=size(Resid);

for i=1:numvars
   ht(:,i)=var_models(i).ht;
   stdresid(:,i)=Resid(:,i)./sqrt(ht(:,i));
end

Ht=NaN(numvars,numvars,numobs);
% stdresid=NaN(T,numvars);
Hstd=ht.^(0.5);
for i=1:numobs
    Ht(:,:,i)=diag(Hstd(i,:))*Rbar*diag(Hstd(i,:));   % the variance-covariance matrix
    %     stdresid(i,:)=stdresid(i,:)*Ht(:,:,i)^(-0.5);
end

[Var, Corr] = cond_var(Ht);
if any(any(Var<0))
    keyboard;
end




corr_model.FullVarCov = Ht;                        %Full time-varying VarianceCovariance matrix
corr_model.LastVarCov = Ht(:,:,end);              %Last VarianceCovariance matrix
corr_model.LLF = -LLF;   %LogLike at the optimum
corr_model.LLF_contr = LLF_contr;       %estimated likelihoods
corr_model.Var=Var;
corr_model.Corr=Corr;
corr_model.Qt = [];                        %give us the time-varying matrix Q
corr_model.Rbar=Rbar;
corr_model.Asym = [];
corr_model.sResid=stdresid;
corr_model.UV_models_spec=var_models_spec;

corr_model_spec.type='CCC';
corr_model.MV_model_spec=corr_model_spec;


