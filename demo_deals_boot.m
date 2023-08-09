function demo_deals_boot(vol_model)



% This is an example of two deals with two futures positions
% ------------------------------------------
deal = deal_declaration_file_spec_example3;

% This is an example of two deals with two physical positions
% deal = deal_declaration_file_two_physical_positions;

ref_date='15-dec-2022';

% Get historical data for risk factors
[deal_new, risk_factor]=get_risk_factors(deal,ref_date);

disp('---------------------------------')
disp('---------------------------------')

% Estimate the mean equation for each risk factor
mean_model=mean_model_estimation(risk_factor);

% Generate future scenarios
numscenarios=500;% Number of generated scenarios
end_date='31-May-2023';


if vol_model==1
    % Estimate the variance-covariance equation
    cov_model=cov_model_estimation(mean_model,risk_factor);
    disp('----------------------')
    disp('Scenario generation...')

    risk_factor_sim=risk_factor_simulation_boot_vol(ref_date,end_date,numscenarios,risk_factor,mean_model,cov_model);
else
    disp('----------------------')
    disp('Scenario generation...')

    risk_factor_sim=risk_factor_simulation_boot_nonvol(ref_date,end_date,numscenarios,risk_factor,mean_model);
end








% Calculate the portfolio value for each scenario
[final_value_portfolio final_value F0] = PnL_portfolio(risk_factor_sim,deal_new);


% Calculate risk metrics on two confidence levels
conf_level(1)=0.95;
metrics1 = risk_metrics([final_value final_value_portfolio],conf_level(1));
C1=-metrics1.CVAR(1:end);


conf_level(2)=0.99;
metrics2 = risk_metrics([final_value final_value_portfolio],conf_level(2));
metrics2.CVAR(1:end);


% Generate various plots
figure
hist(final_value_portfolio,100)

figure
h=plot(-[metrics1.VAR; metrics2.VAR]','.-','LineWidth',2,'MarkerSize',14);
hold off
title(['Extreme loss metrics']);
setfield(gca,'XTick',1:length(deal)+1);
ylabel('VAR (Euros)');
setfield(gca,'XTickLabels',[{deal.mat} 'Portfolio']);
legend(h,{['confidence level=' num2str(100*conf_level(1),'%d') '%'],['confidence level=' num2str(100*conf_level(2),'%d') '%']})

