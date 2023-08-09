function eboot = gen_boot_errors(ehat,holding_period,numscenarios)



[numobs numvars]=size(ehat);

eboot=nan(holding_period,numvars,numscenarios);
w=round(holding_period/3);
% w=20;


[eboot(:,1,:), indices]=stationary_bootstrap2(ehat(:,1),numscenarios,w, holding_period);

for i=2:numvars
    e1=ehat(indices(:),i);
    eboot(:,i,:)=reshape(e1,[holding_period numscenarios]);
end
% keyboard









