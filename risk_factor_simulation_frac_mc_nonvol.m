function risk_factor_sim = risk_factor_simulation_frac_mc_nonvol(ref_date,end_date,numscenarios,risk_factor,mean_model)

% Generate paths of standardized residuals
ref_date=datenum(ref_date);
end_date=datenum(end_date);
dates_sim=ref_date+1:end_date;
holding_period=length(dates_sim);

ehat = synchr_data(mean_model,risk_factor);

mu=nanmean(ehat);
cov_matr=nancov(ehat);

e_sim=nan(holding_period,length(mu),numscenarios);
for t=1:holding_period
    e1=mvnrnd(mu,cov_matr,numscenarios); % same seed
    e_sim(t,:,:)=e1';
end



% e_sim = gen_boot_stand_errors(ehat,boot_data_indices);

risk_factor_sim = risk_factor_frac_sim(risk_factor,mean_model,e_sim,ref_date,end_date);

% keyboard