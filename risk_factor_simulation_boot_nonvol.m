function risk_factor_sim = risk_factor_simulation_boot_nonvol(ref_date,end_date,numscenarios,risk_factor,mean_model,w, subfolder)


% Generate paths of standardized residuals

ref_date=datenum(ref_date);
end_date=datenum(end_date);

dates_sim=ref_date+1:end_date;
holding_period=length(dates_sim);

ehat = synchr_data(mean_model,risk_factor, subfolder);



nobs=rows(ehat);
boot_data_indices=stationary_bootstrap3(nobs,holding_period,w,numscenarios);



e_sim = gen_boot_stand_errors(ehat,boot_data_indices);




% Restore price levels

for i=1:length(risk_factor)
    y=mean_model(i).y;
    Chat=mean_model(i).Chat;
    Ahat=mean_model(i).Ahat;
    Bhat=mean_model(i).Bhat;
    exog_var_index=mean_model(i).exog_var_index;

    dates_est=risk_factor(i).dates;


    % Calculate the simulation dates array
    % dates_sim=((ref_date+1):end_date)';
    % Calculate the extended dates array (covering the estimation and simulation periods)

    dates_ext=(dates_est(1):end_date)';


    dummies_ext=[diff(make_dummies(dates_ext,[]))];
    dummies_ext=[nan(1,cols(dummies_ext));dummies_ext];
    start_p=find(dates_ext==(ref_date+1));

    dummies_sim=dummies_ext(start_p:end,:);


    Bhat=Bhat(exog_var_index);
    dummies_sim=dummies_sim(:,exog_var_index);
    y_sim = varpx_sim(Chat,Ahat,Bhat,y,dummies_sim,e_sim(:,i,:));


    y1=squeeze(y_sim(start_p:end,:));
    y2=repmat(risk_factor(i).time_series,[1 numscenarios]);
    start_level=y2(end,:);

    time_series=[y2;start_level.*exp(cumsum(y1,1))];
    risk_factor_sim(i).time_series=time_series;
    risk_factor_sim(i).dates=dates_ext;

    %     final_value(i,:)=squeeze(risk_factor_sim(end,i,:));
end

file_name = strcat('Risk_Factor_Simulation_Boot_NonVol.mat');
file = fullfile(subfolder, file_name);
save(file);

% keyboard
