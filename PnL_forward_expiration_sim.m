function [final_value,mark_to_market] = PnL_forward_expiration_sim(risk_factor_sim,deal,F0)

% F0 future price 

time_series=risk_factor_sim.time_series;
dates_sim=risk_factor_sim.dates;
del_period=deal.del_period;

size=deal.size;
sign_deal=deal.sign;


if strcmp(sign_deal,'long')
    sign=1;
else
    sign=-1;
end

[~,loc]=ismember(del_period,dates_sim);

rf=time_series(loc,:);

X=0.01; % Tick size 
% del_rate=1;
% del_hours=24 % Should be changed to differentiate between peak and base load contracts
% H=length(del_period)*del_rate*24 % Contract size/delivery hours

mark_to_market=(rf-F0).*size*sign; %daily valuation deals

final_value=mean(mark_to_market,1);






