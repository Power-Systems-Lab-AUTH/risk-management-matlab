function [outputArg1,outputArg2] = demo_risk_factors_param(market,security,mat, ref_date, end_date,sig)

numfactors=length(security);

ref_date=datenum(ref_date);
end_date=datenum(end_date);


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


% mean_model = mean_model_estimation(risk_factor);
% 
% cov_model=cov_model_estimation(mean_model,risk_factor);

% numscenarios=1000;
% risk_factor_sim=risk_factor_simulation(ref_date,end_date,numscenarios,risk_factor,mean_model,cov_model);

holding_period=30;
dates_sim=ref_date+1:end_date;

for i=1:numfactors

    [mu sigma envelope ]= parametric_risk_calc(risk_factor(i).time_series,1:holding_period,sig);
    
    dates_for=risk_factor(i).dates(end)+holding_period;

    v_range=mu(holding_period)+[-3 3]*sigma(holding_period);
    v_range=risk_factor(i).time_series(end)*exp(v_range);
    make_plot_density_for_param(risk_factor(i).dates,risk_factor(i).time_series,dates_for,mu(holding_period),sigma(holding_period),sig,v_range)

    y_scen = gen_scen_hist_sim(log(risk_factor(i).time_series),log(risk_factor(i).time_series(end,:)),holding_period);
    
    
    value_range=[min(y_scen(:)) max(y_scen(:))];

    
    figure
    make_plot_density_for(risk_factor(i).dates,log(risk_factor(i).time_series),dates_sim(holding_period),y_scen,sig,value_range)

    str=[market{i} ' ' security{i} ' ' mat{i}];
    title([str ', Holding period: ' num2str(holding_period) ' days'])
ylabel('log(price)')
    
for j=1:length(dates_sim)
        y_scen = gen_scen_hist_sim(log(risk_factor(i).time_series),log(risk_factor(i).time_series(end,:)),j);
y_scen(isnan(y_scen))=[];
envelope(j,:)=calc_envelope(y_scen',sig);
metrics(j)=risk_metrics(exp(y_scen),0.95);
end

    figure
    plot(risk_factor(i).dates,log(risk_factor(i).time_series));
    hold on;
    plot(dates_sim,envelope,'r');
    datetick('x','mmm yy');
    title([str]);
    ylabel('log(price)')
    hold off

    figure

    plot(1:length(dates_sim),[[metrics.VAR];[metrics.CVAR]])
xlabel('Holding period')
ylabel('Euros')
legend('VAR','CVAR')
end


