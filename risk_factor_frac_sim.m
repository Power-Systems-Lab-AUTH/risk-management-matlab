function risk_factor_sim = risk_factor_frac_sim(risk_factor,mean_model,e_sim,ref_date,end_date)

numscenarios=size(e_sim,3);

for i=1:length(risk_factor)
    y=mean_model(i).y;
    Chat=mean_model(i).Chat;
    Ahat=mean_model(i).Ahat;
    Bhat=mean_model(i).Bhat;
    exog_var_index=mean_model(i).exog_var_index;
    theta_hat=mean_model(i).theta_hat;

    dates_est=risk_factor(i).dates;

    % Calculate the simulation dates array
    % dates_sim=((ref_date+1):end_date)';

    % Calculate the extended dates array (covering the estimation and simulation periods)
    dates_ext=(dates_est(1):end_date)';

    if exog_var_index
        [MD WD]=make_dummies(dates_ext);
        dummies_ext=[MD WD(:,2:end)];
        dummies_ext=dummies_ext(:,exog_var_index);
        Bhat=Bhat(exog_var_index);
    else
        dummies_ext=[];
        Bhat=[];
    end

    % start_p=find(dates_ext==(ref_date+1));
    % dummies_sim=dummies_ext(start_p:end,:);



    y_sim = frac_arx_sim(Chat,Ahat,Bhat,theta_hat,y,dummies_ext,squeeze(e_sim(:,i,:)));


    % y1=squeeze(y_sim(start_p:end,:));
    % y2=repmat(risk_factor(i).time_series,[1 numscenarios]);
    % start_level=y2(end,:);

    % time_series=[y2;start_level.*exp(cumsum(y1,1))];
    time_series=exp(y(1))*exp(cumsum(fracdiff(y_sim,1-theta_hat)));
    risk_factor_sim(i).time_series=time_series;
    risk_factor_sim(i).dates=dates_ext;
end


