function [theta_hat, std_theta, ehat, ahat,XX_hat] = FI_CSS_estimate2(y,AR,MA,exog,trend_term,frac)


% if nargin<5
%     AR=[];
%     MA=[];
% end
dy=diff(y);
dexog=diff(exog);

if frac

    options=optimset('Display','off','TolFun',1e-6,'TolX',1e-6,'TolCon',1e-4);

    LB=0;
    UB=3/2;
    numobs=length(y);

    numstartingvals=10;

    theta_0=unifrnd(LB,UB,1,numstartingvals); % same seed
    theta_hat=theta_0;
    for i=1:length(theta_0)
        try
            [theta_hat(:,i), f(i), exitflag(i) output] = fmincon('fmin_theta_exog',theta_0(:,i),[],[],[],[],LB,UB,[],options,dy,dexog,AR,1,trend_term);
        end

    end

    % [model] = arfima_estimate(dy,'FWHI',[max(AR) 1]); model.d+dstar

    [m i]=min(f);

    theta_hat=theta_hat(i);

    if exitflag(i)~=1
        %     disp('The algorithm did not converge')
    end
    % [~, ~, ahat] = fmin_thetas(theta_hat,y,AR);


    [~, ehat, ahat,XX_hat] = fmin_theta_exog(theta_hat,dy,dexog,AR,1,trend_term);

    std_theta=sqrt(6)/pi/sqrt(numobs);
    %
else
    theta_hat=1;
    [~, ehat, ahat,XX_hat] = fmin_theta_exog(1,dy,dexog,AR,1,trend_term);
    std_theta=[];

end