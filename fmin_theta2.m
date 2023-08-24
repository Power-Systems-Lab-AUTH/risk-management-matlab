function [f, ehat,ahat, XX_hat] = fmin_theta2(d,X_dstar,AR,dstar)

numobs=rows(X_dstar);

X_theta=fracdiff_fast(X_dstar,d-dstar);

if ~isempty(AR)
    maxlag=max(AR);
    YY=X_theta(maxlag+1:end,:);
    % XX=[lagmatrix(X_theta,AR)];
    XX=[ones(numobs,1) lagmatrix(X_theta,AR)];
    XX=XX(maxlag+1:end,:);
    ahat=inv(XX'*XX)*XX'*YY;
    
    [rho, stationary]=inverse_ar_roots(ahat);
    if ~stationary
        ehat=1e6*ones(numobs,1);
    else
        XX_hat=XX*ahat;
        ehat=YY-XX_hat;
    end
    
else
    maxlag=0;
    ehat=X_theta;
    ahat=[];
end


f=trace(ehat'*ehat)/rows(ehat);
