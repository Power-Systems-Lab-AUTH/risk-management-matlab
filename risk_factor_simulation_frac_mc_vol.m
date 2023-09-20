function risk_factor_sim = risk_factor_simulation_frac_mc_vol(ref_date,end_date,numscenarios,risk_factor,mean_model,cov_model)

% Generate paths of standardized residuals
ref_date=datenum(ref_date);
end_date=datenum(end_date);
dates_sim=ref_date+1:end_date;
holding_period=length(dates_sim);

numfactors=length(mean_model);

u_sim=randn(numfactors*numscenarios*holding_period,1);
u_sim=reshape(u_sim, [holding_period,numfactors,numscenarios]);




marginal_models=cov_model.marginal_models;

CCC_params=cov_model.param;

for i=1:numfactors
    marginal_params(:,i)=marginal_models(i).param;
end


mcov_estim=cov_model.mcov;
e_sim=nan(holding_period,numfactors,numscenarios);
ehat=cov_model.ehat;
parfor b=1:numscenarios
    [e_sim1 mcov_sim]= CCC_sim2(ehat,mcov_estim,u_sim(:,:,b),marginal_params,CCC_params);
    e_sim(:,:,b)=e_sim1;
    % [sigmas mcorr] = cov2corr_3D(mcov_sim);
end

% e_sim = gen_boot_stand_errors(ehat,boot_data_indices);

risk_factor_sim = risk_factor_frac_sim(risk_factor,mean_model,e_sim,ref_date,end_date);

% keyboard