function [results]=CCC_est(var_models)
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

numvars=cols(var_models);
uni_parameters=[];
for i = 1:numvars
    stdresid(:,i)=var_models(i).sResid;
    %     end
    ht=var_models(i).ht;
    LLF=var_models(i).LLF;
    uni_parameters1=var_models(i).param(:,1);
    data(:,i)=var_models(i).Resid;
    
    H(:,i)=ht;
    uni_parameters=[uni_parameters;uni_parameters1];
    %     marginal_LLF=marginal_LLF-LLF;
end


T=rows(stdresid);


% The estimated parameters are real easy
Rbar=cov(stdresid);
r = sqrt(diag(Rbar));
Rbar = Rbar ./ (r*r');




% We now have all of the estimated parameters
parameters=[uni_parameters;corr_vech(Rbar)];

    

Ht=NaN(numvars,numvars,T);
% stdresid=NaN(T,numvars);
Hstd=H.^(0.5);
for i=1:T
    Ht(:,:,i)=diag(Hstd(i,:))*Rbar*diag(Hstd(i,:));   % the variance-covariance matrix
%     stdresid(i,:)=stdresid(i,:)*Ht(:,:,i)^(-0.5);
end

[Var, Corr] = cond_var(Ht);
if any(any(Var<0))
    keyboard;
end


results.data=data;
results.FullVarCov = Ht;                        %Full time-varying VarianceCovariance matrix
results.LastVarCov = Ht(:,:,end);              %Last VarianceCovariance matrix
results.Coef = [parameters];               %Vector with the estimated parameters
results.Var=Var;
results.Corr=Corr;
results.Qt = [];                        %give us the time-varying matrix Q
results.Rbar=Rbar;
results.Asym = [];
results.sResid=stdresid;
% results.UV_models_spec=var_models_spec;

MV_model_spec.type='CCC';


results.MV_model_spec=MV_model_spec;



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper Function
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [parameters]=ccvech(CorrMat)
% [k,t]=size(CorrMat);
%
% parameters=zeros(k*(k-1)/2,1);
% index=1;
% for i=1:k
%     for j=i+1:k
%         parameters(index)=CorrMat(i,j);
%         index=index+1;
%     end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Helper Function
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [CorrMat]=ccivech(params)
% [k,t]=size(params);
% for i=2:m
%     if (k/((i*(i-1))/2))==1
%         sizes=i;
%         break
%     end
% end
%
% index=1;
% CorrMat=eye(sizes)
% for i=1:sizes
%     for j=i+1:sizes
%         CorrMat(i,j)=params(index);
%         CorrMat(j,i)=params(index);
%         index=index+1;
%     end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
