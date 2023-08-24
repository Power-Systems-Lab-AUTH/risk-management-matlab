function mean_model = mean_model_estimation_frac(risk_factor,trend_term,exog_term,frac,lag_structure)

% q=0.05;
numfactors=length(risk_factor);
for i=1:numfactors
    %disp(['Estimating the mean model of factor #' num2str(i)]);
    time_series=risk_factor(i).time_series;
    
    dates=datenum(risk_factor(i).dates);
    % [Chat, Ahat, Bhat, ehat y, exog_var_index] = mean_equation_estimate(dates,time_series);
    [Chat Ahat Bhat theta_hat ehat y exog_var_index] = mean_equation_estimate_frac(dates,time_series,trend_term,exog_term,frac,lag_structure);

    % q1=quantile(ehat,[q 1-q]);

    % nvi=ehat<q1(1) | ehat>q1(2);

    % ehat1=ehat;
    % ehat1(nvi)=nan;
    % m1=nanmedian(ehat1);
    % ehat(nvi)=nan;

    



    mean_model(i).y=y;
    mean_model(i).ehat=ehat;
    mean_model(i).Chat=Chat;
    mean_model(i).Ahat=Ahat;
    mean_model(i).Bhat=Bhat;
    mean_model(i).theta_hat=theta_hat;
    mean_model(i).exog_var_index=exog_var_index;
end

% folderPath = fullfile(pwd, subfolder);  
% if ~isfolder(folderPath)  
%     mkdir(folderPath);  
% end
% 
% file_name = 'Mean_Model_Estimation.mat';
% file = fullfile(subfolder, file_name);
% save(file);