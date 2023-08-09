function y_sim = varx1_sim(Chat,Ahat,Bhat,yhat,d_sim,e_sim)

[sim_hor numvars numscenarios]=size(e_sim);

d_sim=d_sim';


yhat=yhat';

sim_period=1:sim_hor;

[numvars numobs]=size(yhat);
y_sim=cat(2,repmat(yhat, [1 1 numscenarios]), nan(numvars,sim_hor, numscenarios));

for b=1:numscenarios
    for i=sim_period
        y_sim(:,numobs+i,b)=Chat+Ahat*y_sim(:,numobs+i-1,b)+Bhat*d_sim(:,i)+e_sim(:,i,b);
    end
end
y_sim=y_sim';


