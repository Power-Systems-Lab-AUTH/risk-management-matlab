function mcov_for=CCC_step(mcov_0,e0,marginal_params,CCC_params,numfactors)
% Performs 1-step forecast for the variance-covariance matrix based on CCC model

h0=diag(mcov_0);
hf=nan(1,numfactors);
for i=1:numfactors
    hf(:,i) = garch_step(e0(i),h0(i),marginal_params(:,i));
end

if any(hf<0)
    hf(hf<0)=h0(hf<0);
end

std_f=hf.^(0.5);
std_f=diag(std_f);
mcov_for=std_f*CCC_params*std_f;
