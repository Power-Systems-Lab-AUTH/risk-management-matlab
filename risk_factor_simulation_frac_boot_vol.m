function risk_factor_sim = risk_factor_simulation_frac_boot_vol(ref_date,end_date,numscenarios,risk_factor,mean_model,cov_model, w)

% Generate paths of standardized residuals
ref_date=datenum(ref_date);
end_date=datenum(end_date);
dates_sim=ref_date+1:end_date;
holding_period=length(dates_sim);

uhat=cov_model.uhat;
nobs=rows(uhat);

boot_data_indices=stationary_bootstrap3(nobs,holding_period,w,numscenarios);
u_sim = gen_boot_stand_errors(uhat,boot_data_indices);

ehat=cov_model.ehat;
numfactors=size(ehat,2);
marginal_models=cov_model.marginal_models;
CCC_params=cov_model.param;

for i=1:numfactors
    marginal_params(:,i)=marginal_models(i).param;
end

mcov_estim=cov_model.mcov;
e_sim=nan(holding_period,numfactors,numscenarios);
for b=1:numscenarios
    [e_sim(:,:,b) mcov_sim]= CCC_sim2(ehat,mcov_estim,u_sim(:,:,b),marginal_params,CCC_params);
    [sigmas mcorr] = cov2corr_3D(mcov_sim);
end

% e_sim = gen_boot_stand_errors(ehat,boot_data_indices);

risk_factor_sim = risk_factor_frac_sim(risk_factor,mean_model,e_sim,ref_date,end_date);

% keyboard