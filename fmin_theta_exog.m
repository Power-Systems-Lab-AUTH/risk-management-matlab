function [f, ehat,ahat, XX_hat] = fmin_theta_exog(d,X_dstar,exog_dstar,lag_structure,dstar,trend_term)

numobs=rows(X_dstar);

X_theta=fracdiff(X_dstar,d-dstar);
exog_theta=fracdiff(exog_dstar,d-dstar);

if ~isempty(lag_structure)
    maxlag=max(lag_structure);
    YY=X_theta(maxlag+1:end,:);

    XX=[lagmatrix(X_theta,lag_structure) exog_theta];
    if trend_term
        XX=[ones(numobs,1) XX];

    end

    XX=XX(maxlag+1:end,:);
    ahat=inv(XX'*XX)*XX'*YY;

    if trend_term

        [rho, stationary]=inverse_ar_roots(ahat(1+(1:length(lag_structure))));

    else
        
        [rho, stationary]=inverse_ar_roots(ahat((1:length(lag_structure))));

    end
    % [rho, stationary]=inverse_ar_roots(ahat(1:length(AR)));
    if ~stationary
        ehat=1e6*ones(numobs,1);
        XX_hat=[];
    else
        XX_hat=XX*ahat;
        ehat=YY-XX_hat;
    end

else
    maxlag=0;


    XX=exog_theta;
    if trend_term
        XX=[ones(numobs,1) XX];
    end

    if ~isempty(XX)
        YY=X_theta;
        ahat=inv(XX'*XX)*XX'*YY;
        XX_hat=XX*ahat;
        ehat=YY-XX_hat;

    else

        ehat=X_theta;
        ahat=[];
        XX_hat=[];

    end




end


f=trace(ehat'*ehat)/rows(ehat);
