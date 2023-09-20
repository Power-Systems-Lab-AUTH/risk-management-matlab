function risk_factor_sim = risk_factor_simulation_hist(ref_date,end_date,numscenarios,risk_factor)


% Generate paths of standardized residuals

ref_date=datenum(ref_date);
end_date=datenum(end_date);

dates_sim=(ref_date+1:end_date)';
holding_period=length(dates_sim);
numfactors=length(risk_factor);

risk_factor_sim=risk_factor;
for i=1:numfactors
    risk_factor1=risk_factor(i);
    risk_factor1.time_series=repmat(risk_factor1.time_series,[1 numscenarios]);

    y_scen=nan(holding_period,length(risk_factor1.time_series)-1);
    for j=1:length(dates_sim)
        y_scen1 = gen_scen_hist_sim(log(risk_factor(i).time_series),log(risk_factor(i).time_series(end,:)),j);
        y_scen1=exp(y_scen1);
        n=length(y_scen1);
        y_scen(j,1:n)=y_scen1';
    end

    nv_scen_index=any(isnan(y_scen),1);
    y_scen(:,nv_scen_index)=[];

    if cols(y_scen)>numscenarios
        y_scen=y_scen(:,1:numscenarios);
    end

    risk_factor1.time_series=[risk_factor1.time_series(:,1:cols(y_scen));y_scen];
    risk_factor1.dates=[risk_factor1.dates; dates_sim];
    risk_factor_sim(i)=risk_factor1;
end









