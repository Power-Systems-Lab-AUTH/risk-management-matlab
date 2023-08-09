function cov_model = cov_model_estimation(mean_model,risk_factor, subfolder)

numfactors=length(mean_model);
[ehat,dates] = synchr_data(mean_model,risk_factor, subfolder);
numobs=rows(ehat);

% lambda=0.85;
% mcov = ewma_sim_nan(ehat,lambda);
% [sigmas mcorr] = cov2corr_3D(mcov);

for i=1:numfactors
    garch_model(i)=marginal_var_estim3(ehat(:,i));
end

CCC_model=CCC_est(garch_model);
mcov=CCC_model.FullVarCov;

for t=1:numobs
    uhat(t,:)=ehat(t,:)*(mcov(:,:,t))^(-0.5);
end

cov_model.ehat=ehat;
cov_model.dates=dates;
cov_model.mcov=mcov;
cov_model.uhat=uhat;
cov_model.param=CCC_model.Rbar;
cov_model.marginal_models=garch_model;

folderPath = fullfile(pwd, subfolder);  
if ~isfolder(folderPath)  
    mkdir(folderPath);  
end

file_name = strcat('Cov_Model_Estimation.mat');
file = fullfile(subfolder, file_name);
save(file);
