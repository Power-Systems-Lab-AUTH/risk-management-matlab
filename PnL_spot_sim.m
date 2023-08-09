function [final_value, mark_to_market] = PnL_spot_sim(risk_factor_sim,deal)


time_series=risk_factor_sim.time_series;
dates_sim=risk_factor_sim.dates;


open_date=datenum(deal.open_date);

close_date=datenum(deal.close_date);

size=deal.size;
sign_deal=deal.sign;

if strcmp(sign_deal,'buy')
    sign=-1;
else
    sign=1;
end

start_p=find(dates_sim== open_date);
end_p=find(dates_sim==close_date);

mark_to_market=time_series(start_p:end_p,:).*size.*sign;

final_value=sum(mark_to_market,1)';






