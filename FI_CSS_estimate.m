function [theta_hat, std_theta, ehat, ahat,exog_params,XX_hat] = FI_CSS_estimate(y,AR,MA,exog)


% if nargin<5
%     AR=[];
%     MA=[];
% end

options=optimset('Display','off','TolFun',1e-6,'TolX',1e-6,'TolCon',1e-4);



% dy=fracdiff(y,dstar);
% dy=demean(dy);

% dy=fracdiff(y,dstar);

LB=0;
UB=3/2;
numobs=length(y);
dy=diff(y);

if ~isempty(exog)
    %     determ1=[ones(numobs-1,1) diff(determ)];
    exog1=[diff(exog)];
    % I=eye(numobs-1,numobs-1);
    exog_params=inv(exog1'*exog1)*exog1'*dy;
    % Md=I-determ1*inv(determ1'*determ1)*determ1';
    % dy=Md*dy;
    dy=dy-exog1*exog_params;
else
    exog_params=[];
end



numstartingvals=10;

theta_0=unifrnd(LB,UB,1,numstartingvals);

% b=-0.1:0.01:1;
% clear fhat
% for i=1:length(b);
%     [fhat(i), ehat] = fmin_thetas(b(i),dy,AR,MA);
% end
% plot(b,fhat)

% theta_0=0.8-dstar;
for i=1:length(theta_0)
    [theta_hat(:,i), f(i), exitflag(i)] = fmincon('fmin_theta2',theta_0(:,i),[],[],[],[],LB,UB,[],options,dy,AR,1);
end

% [model] = arfima_estimate(dy,'FWHI',[max(AR) 1]); model.d+dstar

[m i]=min(f);

theta_hat=theta_hat(i);

if exitflag(i)~=1
    %     disp('The algorithm did not converge')
end
% [~, ~, ahat] = fmin_thetas(theta_hat,y,AR);


[~, ehat, ahat,XX_hat] = fmin_theta2(theta_hat,dy,AR,1);

std_theta=sqrt(6)/pi/sqrt(numobs);
%
