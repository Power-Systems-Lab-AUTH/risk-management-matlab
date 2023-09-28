function optimization_test(dy, dexog, AR, trend_term)

options=optimset('Display','off','TolFun',1e-6,'TolX',1e-6,'TolCon',1e-4);

LB=0;
UB=3/2;
%numobs=length(y);

numstartingvals=10;

theta_0=unifrnd(LB,UB,1,numstartingvals);
theta_hat=theta_0;
for i=1:length(theta_0)
    try
        [theta_hat(:,i), f(i), exitflag(i) output] = fmincon('fmin_theta_exog',theta_0(:,i),[],[],[],[],LB,UB,[],options,dy,dexog,AR,1,trend_term);
    end

end
y=1;