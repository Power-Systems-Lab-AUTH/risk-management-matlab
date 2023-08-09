function demo_risk_factors_mc(market,security,mat, ref_date, end_date,holding_period,sig,vol_model)

% This function generates density forecasting corridors for an array of
% risk factors chosen by the user using the Monte Carlo method 

% Example
% demo_risk_factors_mc({'IT','IT'},{'electricity','electricity'},{'spot','M01'}, '25-dec-22', '31-mar-23', 91, 0.05, 1)

% Extract data on risk factors
numfactors=length(security);
ref_date=datenum(ref_date);
for i=1:numfactors


    switch security{i}

        case 'gas'

            switch mat{i}
                case 'spot'
                    file_name='TTF_spot_data.mat';
                otherwise
                    file_name='TTF_fut_data.mat';

            end

        case 'electricity'

            switch mat{i}
                case 'spot'
                    file_name='IT_power_spot_data.mat';
                otherwise
                    file_name='IT_power_fut_data.mat';

            end

    end

    s=load(file_name,'data_daily','dates_daily','vnames');

    risk_factor1=s.data_daily;
    dates_daily1=s.dates_daily;

    vnames=[];
    if isfield(s,'vnames')
        vnames=s.vnames;
        index = find_vertices(vnames,mat(i));
        risk_factor1=risk_factor1(:,index);
    end

    j=find(datenum(dates_daily1)==ref_date);

    risk_factor(i).dates=datenum(dates_daily1(1:j));
    risk_factor(i).time_series=risk_factor1(1:j);


end


% Estimate the mean equation for each risk factor
mean_model = mean_model_estimation(risk_factor);


numscenarios=1000; % Set the number of scenarios


if vol_model==1
    % Estimate the variance-covariance equation
cov_model=cov_model_estimation(mean_model,risk_factor);
    risk_factor_sim=risk_factor_simulation_mc_vol(ref_date,end_date,numscenarios,risk_factor,mean_model,cov_model);
else

    risk_factor_sim=risk_factor_simulation_mc_nonvol(ref_date,end_date,numscenarios,risk_factor,mean_model);
end








% Produce graphs 
for i=1:numfactors
    j=find(datenum(dates_daily1)==ref_date);
    y_scen=risk_factor_sim(i).time_series(j+1:end,:);



    dates_sim=risk_factor_sim(i).dates(j+1:end,:);


    value_range=[min(log(y_scen(:))) max(log(y_scen(:)))];


    figure
    make_plot_density_for(risk_factor(i).dates,log(risk_factor(i).time_series),dates_sim(holding_period),log(y_scen(holding_period,:)),sig,value_range)

    str=[market{i} ' ' security{i} ' ' mat{i}];
    title([str ', Holding period: ' num2str(holding_period) ' days'])
    ylabel('log(price)')
    envelope=calc_envelope(y_scen,sig);

    figure
    plot(risk_factor(i).dates,log(risk_factor(i).time_series));
    hold on;
    plot(dates_sim,log(envelope),'r');
    datetick('x','mmm yy');
    title([str]);
    ylabel('log(price)')
    hold off





    dates_sim=risk_factor_sim(i).dates(j+1:end,:);

    for k=1:length(dates_sim)
        y_scen=risk_factor_sim(i).time_series(j+k,:);

        metrics(k)=risk_metrics(y_scen',0.95);

    end
end


% keyboard

