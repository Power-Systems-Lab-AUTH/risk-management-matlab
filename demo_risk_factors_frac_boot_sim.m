function risk_factor_sim = demo_risk_factors_frac_boot_sim(file, start_date, ref_date, end_date, sig, vol_model, numscenarios, sampling_window_length, trend_term,exog_term,lag_structure)
% This function generates density forecasting corridors for an array of risk factors chosen by the user.
% Example: demo_risk_factors_boot('01-sep-22', '01-jan-23', '01-feb-23', 155, 0.05, 0, 500, 1)

%% Extract data on risk factors

numfactors=24;
start_date_str=start_date;
ref_date_str=ref_date;
end_date_str=end_date;

data = dlmread([file, '_price.csv'], ',');
data=data(:,1:24);
data(data<1e-1)=1e-1;
dates = dlmread([file, '_dates.csv'], ',');
dates_daily = dates(:,1);

% if(isdatetime(start_date))
    start_date=datenum(start_date_str);
    s1=find(datenum(dates_daily)==start_date);
if isempty(s1)
    s1 = find(datenum(dates_daily(1, 1)));
end

ref_date=datenum(ref_date_str);
end_date=datenum(end_date_str);
j1=find(datenum(dates_daily)==ref_date);
j2=find(datenum(dates_daily)==end_date);

for i=1:numfactors
    rf(i).time_series = data(s1:j1,i);
    rf(i).dates = dates_daily(s1:j1);
end

% Estimate the mean equation for each risk factor
% mean_model = mean_model_estimation(rf, subfolder);

mean_model = mean_model_estimation_frac(rf,trend_term,exog_term,lag_structure);


% Generate future scenarios
if vol_model==1
    % Estimate the variance-covariance equation
    cov_model=cov_model_estimation(mean_model,rf);
    % Simulate risk factors
    % risk_factor_sim=risk_factor_simulation_boot_vol(ref_date,end_date,numscenarios,rf,mean_model,cov_model,w, subfolder);
    
    risk_factor_sim = risk_factor_simulation_frac_boot_vol(ref_date,end_date,numscenarios,rf,mean_model,cov_model, sampling_window_length);
else
    tic
    risk_factor_sim=risk_factor_simulation_frac_boot_nonvol(ref_date,end_date,numscenarios,rf,mean_model,sampling_window_length);
    toc
end

risk_factor_sim1.time_series = structMean(risk_factor_sim);
risk_factor_sim1.dates = risk_factor_sim(1).dates;
risk_factor_sim = risk_factor_sim1;

keyboard

% % Produce graphs
% average_rf = 0;
% numfactors = 1;
% for i=1:numfactors
%     if(isdatetime(start_date))
%         start_idx=find(datenum(rf(i).dates)==start_date);
%     else
%         start_idx=find(datenum(rf(i).dates(1)));
%     end    
%     j=find(datenum(rf(i).dates)==ref_date);
% 
%     y_scen=risk_factor_sim(i).time_series(j-start_idx+1:end,:);
%     dates_sim=risk_factor_sim(i).dates(j-start_idx+1:end,:);
% 
%     value_range=[min(log(y_scen(:))) max(log(y_scen(:)))];
%     % value_range=[min(log(y_scen(1,:))) max(log(y_scen(1,:)))];
% 
%     figure
%     make_plot_density_for(rf(i).dates,log(rf(i).time_series),dates_sim(holding_period),log(y_scen(holding_period,:)),sig,value_range)
%     title([num2str(i) ', Holding period: ' num2str(holding_period) ' days'])
%     ylabel('log(price)')
% 
%     envelope=calc_envelope(y_scen,sig);
%     figure
%     plot(rf(i).dates,log(rf(i).time_series));
%     hold on;
%     plot(dates_sim,log(envelope),'r');
%     datetick('x','mmm yy');
%     title(['Scenarios: ' num2str(numscenarios), ' / W:' num2str(w)]);
%     ylabel('log(price)')
%     hold off
% % 
% end
% %     filename = fullfile(subfolder, 'envelope.png');
% %     saveas(gcf, filename);
% % 
% %     dates_sim=risk_factor_sim(i).dates(j-start_idx+1:end,:);
% %     for k=1:length(dates_sim)
% %         y_scen=risk_factor_sim(i).time_series(j-start_idx+k,:);
% %         metrics(k)=risk_metrics(y_scen',0.95);
% %     end
% % 
% %     average_rf = mean(mean(risk_factor_sim(i).time_series(j:end, :), 1));
% %     real_rf = data(s1:j2, i);
% %     mean_rf = [data(s1:j1, i); mean(risk_factor_sim(i).time_series(j+1:end, :), 2)];
% %     percentile_20 = [data(s1:j1, i); prctile(risk_factor_sim(i).time_series(j+1:end, :)', 20)'];
% %     percentile_50 = [data(s1:j1, i); prctile(risk_factor_sim(i).time_series(j+1:end, :)', 50)'];
% %     percentile_80 = [data(s1:j1, i); prctile(risk_factor_sim(i).time_series(j+1:end, :)', 80)'];
% %     dates_simulation = dates_daily(s1:j2, i);
% % 
% %     % plot result data
% %     figure
% %     plot(dates_simulation, percentile_20)
% %     hold on
% %     plot(dates_simulation, percentile_50)
% %     hold on
% %     plot(dates_simulation, percentile_80)
% %     hold on
% %     plot(dates_simulation, mean_rf)
% %     hold on
% %     plot(dates_simulation, real_rf)
% %     hold on
% % 
% %     if (vol_model == 1)
% %         title([file , ', w=', num2str(w), ', numscenarios=', num2str(numscenarios), ', with vol'], 'Interpreter', 'none');
% %     else
% %         title([file , ', w=', num2str(w), ', numscenarios=', num2str(numscenarios), ', with non vol'], 'Interpreter', 'none');
% %     end
% %     legend('p20', 'p50', 'p80', 'mean', 'real');
% %     datetick('x', 'mmm yy');
% %     hold off
% % 
% %     filename = fullfile(subfolder, 'price.png');
% %     saveas(gcf, filename);
% % end
% % 
% % %% Save workspace
% % 
% % file_name = 'Risk_Factors_Boot.mat';
% % file = fullfile(subfolder, file_name);
% % save(file);
% % 
% % %% Log data
% % if log_data
% %     %'boot_', start_date_str, '_', ref_date_str, '_', end_date, '_', 
% %     risk_factor_sim_res = mean(risk_factor_sim.time_series, 2);
% %     if vol_model==1
% %         vol_model_txt = 'vol';
% %     else
% %         vol_model_txt = 'nonvol';
% %     end
% %     filename = strcat(vol_model_txt, '_', num2str(numscenarios), '_', num2str(w), '_', comment, '.csv');
% %     csvwrite(filename, risk_factor_sim_res);
% % end
% 
% %mean(risk_factor_sim.time_series(j+1,:) > risk_factor_sim.time_series(j,:))
