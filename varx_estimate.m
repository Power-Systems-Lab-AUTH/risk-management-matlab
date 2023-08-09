function [Chat Ahat  Bhat ehat ] = varx_estimate(Y, lags, exog)

ne=size(exog,2);
[numobs numvars]=size(Y);

maxl=max(lags);

o=ones(numobs,1);
X=[o lagmatrix(Y,lags) exog];
X=X(maxl+1:end,:);
Y=Y(maxl+1:end,:);

n=size(X,2);

bhat=inv(X'*X)*(X'*Y);


Yhat=X*bhat;


ehat=Y-Yhat;

% Regroup coefficient estimates
Chat=bhat(1,:)';
Bhat=bhat(end-ne+1:end,:);

A1=bhat(2:n-ne,:)';

Ahat=cell(maxl,1);
Ahat{1}=zeros(numvars,numvars);
Ahat(2:end)=Ahat(1);
for j=1:length(lags)
    index=1+numvars*(j-1):numvars*j;

    Ahat{lags(j)}=A1(:,index);
end
