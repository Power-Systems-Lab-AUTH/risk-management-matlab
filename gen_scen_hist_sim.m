function Y_for = gen_scen_hist_sim(Y,Y0,holding_period)

numobs=size(Y,1);

D=Y(holding_period+1:end,:)-Y(1:end-holding_period,:);

numscenarios=size(D,1);

Y_for=repmat(Y0,[numscenarios 1])+D;

