function make_commands_VaR


load IT_PUN_data


[data_new dates_new vnames_new excluded_vertices] = data_preprocessing2(data,maturities,dates_daily,vnames);
% y=log(data_new);
% nvi=any(~isfinite(y) | imag(y),2);
% y(nvi,:)=[];
% data_new(nvi,:)=[];
% dates_new(nvi)=[];
% 



[numobs numvars]=size(data);

y=log(data);
y=[nan(1,numvars);diff(y,1)];
d=make_dummies(dates_daily,[]);
numexog=cols(d);
dd=[nan(1,numexog);diff(d,1)];


lag_structure=[1 2 7];

[Chat Ahat Bhat ehat] = diag_varx_estimate(y, lag_structure, dd);


holding_period=250;

for i=1:holding_period
    y_sim = gen_scen_hist_sim(y_trans,y_trans(end,:),i);
    y_sim=logsigm(y_sim);
    m(i,:)=mean(y_sim);
    s(i,:)=std(y_sim);
end


var_index=1;

plot_scen(y(:,var_index),dates_daily,dates_daily(end), holding_period,y_sim(:,var_index))




% Bootstrap

numscenarios=100;
dates_sim=dates_new(end)+(1:holding_period)';
dates_ext=[dates_new;dates_sim];

d_ext=diff(make_dummies(dates_ext,[]));
d_sim=d_ext(end-holding_period+1:end,:);

e_sim = gen_boot_errors(ehat,holding_period,numscenarios);

yhat=y(max(lag_structure)+1:end,:)-ehat;

y_sim = varpx_sim(Chat,Ahat,Bhat,y,d_sim,e_sim);

% Restore price levels
start_level=repmat(data_new(1,:), [1 1 numscenarios]);
data_sim=[start_level;start_level.*exp(cumsum(y_sim,1))];

final_value=squeeze(data_sim(end,:,:))';


% Set deals 


