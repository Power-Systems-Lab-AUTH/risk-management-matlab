function risk_factor_sim = risk_factor_simulation_frac_boot_nonvol(ref_date,end_date,numscenarios,risk_factor,mean_model,sampling_window_length)


% Generate paths of standardized residuals

ref_date=datenum(ref_date);
end_date=datenum(end_date);

dates_sim=ref_date+1:end_date;
holding_period=length(dates_sim);

ehat = synchr_data(mean_model,risk_factor);

% New amendment----------------------
threshold=0.5;
ehat=filter_errors(ehat,threshold);
%----------------------

nobs=rows(ehat);
boot_data_indices=stationary_bootstrap3(nobs,holding_period,sampling_window_length,numscenarios);



e_sim = gen_boot_stand_errors(ehat,boot_data_indices);



risk_factor_sim = risk_factor_frac_sim(risk_factor,mean_model,e_sim,ref_date,end_date);


% file_name = strcat('Risk_Factor_Simulation_Boot_NonVol.mat');
% file = fullfile(subfolder, file_name);
% save(file);

% keyboard
