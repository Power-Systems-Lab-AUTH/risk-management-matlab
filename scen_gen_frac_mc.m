function [risk_factor_sim, risk_factor,mean_model, cov_model] = scen_gen_frac_mc(data, dates_daily,start_date, ref_date, end_date, vol_model, numscenarios,trend_term,dummy_term,frac,lag_structure )
% This function generates density forecasting corridors for an array of risk factors chosen by the user.
% Example: demo_risk_factors_boot('01-sep-22', '01-jan-23', '01-feb-23', 155, 0.05, 0, 500, 1)

%% Extract data on risk factors

% if(isdatetime(start_date))

%trend_term, dummy_term,frac,lag_structure are parameters of the mean model

% TREND_TERM is the fractional trend indicator variable (takes the value 1
% if the mean model includes a fractional trend term) 

% DUMMY_TERM is the dummy indicator variable (takes the value 1 both
% monthly and weekday
% dummies are included, 2 if only weekday dummies are included and 0 if the
% mean model does not include seasonal deterministics)

% FRAC is an indicator variable taking value 1 if energy index is assumed
% fractionally integrated with parameter D. If FRAC=0 the mean model is
% based on log-differences of index levels

% LAG_STRUCTURE is an integer array specifying the number and order or
% lagged dependent variables (AR terms) in the mean model. LAG_STRUCTURE=[1
% 2 7] means that the model includes 1st, 2nd and 7th order lags. If
% LAG_STRUCTURE=[] the mean model includes no lagged dependent variables  
% 

numfactors=cols(data);
start_date=datenum(start_date);
s1=find(datenum(dates_daily)==start_date);
if isempty(s1)
    s1 = find(datenum(dates_daily(1, 1)));
end

ref_date=datenum(ref_date);
end_date=datenum(end_date);
j1=find(datenum(dates_daily)==ref_date);
j2=find(datenum(dates_daily)==end_date);

for i=1:numfactors
    risk_factor(i).time_series = data(s1:j1,i);
    risk_factor(i).dates = dates_daily(s1:j1);
end

% Estimate the mean equation for each risk factor
% mean_model = mean_model_estimation(rf, subfolder);

% risk_factor=risk_factor(1);
mean_model = mean_model_estimation_frac(risk_factor,trend_term,dummy_term,frac,lag_structure);


% Generate future scenarios
if vol_model==1
    % Estimate the variance-covariance equation
    cov_model=cov_model_estimation(mean_model,risk_factor);
    
    % Simulate risk factors
     risk_factor_sim = risk_factor_simulation_frac_mc_vol(ref_date,end_date,numscenarios,risk_factor,mean_model,cov_model);
    
else
    % tic
    cov_model=[];
    % Simulate risk factors
    risk_factor_sim = risk_factor_simulation_frac_mc_nonvol(ref_date,end_date,numscenarios,risk_factor,mean_model);
    % toc
end

risk_factor_sim1.time_series = structMean(risk_factor_sim);
risk_factor_sim1.dates = risk_factor_sim(1).dates;
risk_factor_sim = risk_factor_sim1;

s1=400;
real_rf = mean(data(s1:j2, :), 2);
mean_rf = [mean(data(s1:j1, :), 2); mean(risk_factor_sim.time_series(j1+1:end, :), 2)];
percentile_20 = [mean(data(s1:j1, :), 2); prctile(risk_factor_sim.time_series(j1+1:end, :)', 20)'];
percentile_50 = [mean(data(s1:j1, :), 2); prctile(risk_factor_sim.time_series(j1+1:end, :)', 50)'];
percentile_80 = [mean(data(s1:j1, :), 2); prctile(risk_factor_sim.time_series(j1+1:end, :)', 80)'];

figure
plot(percentile_20)
hold on
plot(percentile_50)
hold on
plot(percentile_80)
hold on
plot(mean_rf)
hold on
plot(real_rf)
legend('p20', 'p50', 'p80', 'mean', 'real')
%ylim([0 750])
y=1;

% keyboard

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
