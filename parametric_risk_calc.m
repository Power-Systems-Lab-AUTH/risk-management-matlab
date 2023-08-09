function [mu sigma envelope]  = parametric_risk_calc(risk_factor_time_series,holding_period,sig)


y1=diff(log(risk_factor_time_series));
y1=[nan; y1];

mu1=nanmean(y1);
sigma1=sqrt(var(y1,'omitnan'));
mu=mu1*holding_period;
sigma=sigma1*sqrt(holding_period);

envelope(:,1)=norminv(sig/2,mu,sigma);
envelope(:,2)=norminv(1-sig/2,mu,sigma);


envelope=risk_factor_time_series(end)*exp(envelope);



