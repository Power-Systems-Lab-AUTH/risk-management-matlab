function Ahat = reorder_lags(ahat,lags)

maxl=max(lags);
Ahat=zeros(maxl,1);
Ahat(lags)=ahat;
