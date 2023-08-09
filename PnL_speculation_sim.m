function final_value = PnL_speculation_sim(risk_factor_sim,dates_sim,deal)


open_date=deal.open_date;

close_date=deal.close_date;
size=deal.size;
sign_deal=deal.sign;

if strcmp(sign_deal,'long')
    sign=1;
else
    sign=-1;
end

start_p=find(dates_sim, open_date);
end_p=find(dates_sim, close_date);

final_value=(risk_factor_sim(end_p,:)-risk_factor_sim(start_p,:)).*size.*sign;






