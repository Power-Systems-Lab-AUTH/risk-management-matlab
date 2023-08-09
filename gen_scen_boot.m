function Y_sim = gen_sim_boot(Y,ehat,holding_period,numscenarios)



[numobs nvars]=size(Y);

w=20;

for i=1:nvars
    [e1, indices]=stationary_bootstrap2(ehat(:,i),numscenarios,w, holding_period);
    eboot(:,i,:)=e1;
end




Y_scen=repmat(Y0,[numscenarios 1])+;

