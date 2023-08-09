function [Chat Ahat  Bhat ehat ] = arx_estimation(Y, lags, exog)

[numobs numvars]=size(Y);
ne=size(exog,2);
maxl=max(lags);
o=ones(numobs,1);
X=[o lagmatrix(Y,lags) exog];
X(1:maxl,:)=[];
Y(1:maxl,:)=[];
n=size(X,2);

bhat=inv(X'*X)*(X'*Y);
Yhat=X*bhat;

ehat=nan(maxl,1);
ehat=[ehat;Y-Yhat];

% Regroup coefficient estimates
Chat=bhat(1);
Bhat=bhat(end-ne+1:end);

A1=bhat(2:n-ne);
Ahat=cell(maxl,1);
Ahat{1}=zeros(numvars,numvars);
Ahat(2:end)=Ahat(1);
for j=1:length(lags)
    index=1+numvars*(j-1):numvars*j;

    Ahat{lags(j)}=A1(index);
end

% subfolder = 'Simulation_Workspaces';
% file_name = strcat('Arx_Estimation.mat');
% file = fullfile(subfolder, file_name);
% save(file);
