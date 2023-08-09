function [Chat Ahat  Bhat ehat exog_var_index] = diag_varx_estimate(Y, lags, exog)

[numobs numvars]=size(Y);
numexog=cols(exog);
numlags=max(lags);
nparams=1+numexog+numlags;

ehat=nan(numobs,numvars);
Chat=nan(numvars,1);
Bhat=nan(numvars,numexog);

A1{1}=nan;
A1=repmat(A1,[numlags numvars]);
for i=1:numvars
    Y1=Y(:,i);
    nv_ri=any(isnan(Y1) | ~isfinite(Y1) | imag(Y1)~=0,2);
    Y1(nv_ri)=[];

    exog1=exog;
    if ~isempty(exog1)
        exog1(nv_ri,:)=[];
        nv_var=std(exog1)>1e-6;

        exog_var_index=find(nv_var);
        exog1=exog1(:,exog_var_index);
    end

    %disp(['effective number of sample data available for estimation is ', num2str(rows(Y1))]);
    if nparams<rows(Y1)
        [Chat(i,:), A1(:,i), B1, e1] = arx_estimation(Y1, lags, exog1);

        if isnan(Chat(i,:))
            [Chat(i,:), A1(:,i), B1, e1] = arx_estimation(Y1, lags, []);
            Bhat(i,:)=0;
        else
            Bhat(i,exog_var_index)=B1;
        end

        ehat(~nv_ri,i)=e1;
    end
end

for l=1:numlags
    Ahat{l}=diag([A1{l,:}]);
end

% subfolder = 'Simulation_Workspaces';
% file_name = strcat('Diag_Varx_Estimate.mat');
% file = fullfile(subfolder, file_name);
% save(file);
