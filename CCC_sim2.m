function [e_sim, mcov_sim] = CCC_sim2(resid,mcov_estim,u_sim,marginal_params,CCC_params)

[numrealizations,numfactors] = size(u_sim);
mcov_sim=nan(numfactors,numfactors,numrealizations);
e_sim=nan(numrealizations,numfactors);

v1=CCC_step(mcov_estim(:,:,end),resid(end,:),marginal_params,CCC_params,numfactors);

mcov_sim(:,:,1)=v1;
e_sim(1,:)=u_sim(1,:)*(v1^0.5);

for t=2:numrealizations
    e0=e_sim(t-1,:);
    mcov_0=mcov_sim(:,:,t-1);
    v1=CCC_step(mcov_0,e0,marginal_params,CCC_params,numfactors);
    
    mcov_sim(:,:,t)=v1;
    e_sim(t,:)=u_sim(t,:)*(v1^0.5);
end

% [sigmas mcorr] = cov2corr_3D(mcov_sim(:,:,1:t));

% subfolder = 'Simulation_Workspaces';
% file_name = strcat('CCC_Sim2.mat');
% file = fullfile(subfolder, file_name);
% save(file);
