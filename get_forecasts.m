function [dates_daily rel_data q risk_factor_sim] = get_forecasts(quantiles)

load setup.mat
risk_factor_sim = get_scenarios;

numrep=length(risk_factor_sim);

dates=dates(:,1);
data=data(:,1:24);


clear dates_daily;
for i=1:numrep

    % i

    
    dates_sim=risk_factor_sim(i).dates;
    
    dates_daily(i)=datenum(year(dates_sim(end)),month(dates_sim(end)),1);
    index=month(dates)==month(dates_sim(end)) & year(dates)==year(dates_sim(end));

    


    rel_data(i,:)=mean(mean(data(index,:),2));

    index2=month(dates_sim)==month(dates_sim(end)) & year(dates_sim)==year(dates_sim(end));
    data_sim=risk_factor_sim(i).time_series(index2,:);

    data_sim=mean(data_sim);
    % try
    q(i,:)=quantile(data_sim,quantiles);
    % catch
        % keyboard
    % end

end

[dates_daily I]=sort(dates_daily );

risk_factor_sim=risk_factor_sim(I);
q=q(I,:);
rel_data=rel_data(I,:);

% keyboard