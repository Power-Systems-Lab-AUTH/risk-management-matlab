function [Chat Ahat  Bhat theta_hat ehat exog_var_index] = diag_frac_varx_estimate(Y, lags, exog,trend_term,frac)

[numobs numvars]=size(Y);
numexog=cols(exog);

if ~isempty(lags)
    numlags=max(lags);
else
    numlags=0;
end

nparams=numexog+numlags;
if trend_term
    nparams=nparams+1;
end

ehat=nan(numobs,numvars);
Chat=nan(numvars,1);
Ahat=nan(numlags,numvars);
Bhat=nan(numvars,numexog);
theta_hat=Chat;
% A1{1}=nan;
% A1=repmat(A1,[numlags numvars]);
for i=1:numvars
    Y1=Y(:,i);
    nv_ri=any(isnan(Y1) | ~isfinite(Y1) | imag(Y1)~=0,2);
    Y1(nv_ri)=[];

    exog1=exog;
    exog_var_index=[];
    if ~isempty(exog1)
        exog1(nv_ri,:)=[];
        valid_var=std(exog1)>1e-6;
        valid_var=valid_var & any(exog1>0.99);

        exog_var_index=find(valid_var);
        % exog_var_index=[];
        exog1=exog1(:,exog_var_index);
    end

    %disp(['effective number of sample data available for estimation is ', num2str(rows(Y1))]);
    if nparams<rows(Y1)
        % [Chat(i,:), A1(:,i), B1, e1] = arx_estimation(Y1, lags, exog1);
        
        [theta_hat(i,:), dummy, e2, ahat] = FI_CSS_estimate2(Y1,lags,[],exog1,trend_term,frac);



        e1=nan(numobs,1);
        try
            l=length(e2);
            e1(end-l+1:end)=e2;
        catch
            keyboard
        end

        if trend_term

            Chat(i,:)=ahat(1);
            Ahat(:,i) = reorder_lags(ahat(1+(1:length(lags))),lags);

        else

            Chat=0;
            Ahat(:,i) = reorder_lags(ahat(1:length(lags)),lags);


        end
        B1=ahat(end-cols(exog1)+1:end);


        % if isnan(Chat(i,:))
        % [Chat(i,:), A1(:,i), B1, e1] = arx_estimation(Y1, lags, []);
        % Bhat(i,:)=0;
        % else
        Bhat(i,exog_var_index)=B1;
        % end

        ehat(~nv_ri,i)=e1;
    end
end

% for l=1:numlags
% Ahat{l}=diag([A1{l,:}]);
% end

% subfolder = 'Simulation_Workspaces';
% file_name = strcat('Diag_Varx_Estimate.mat');
% file = fullfile(subfolder, file_name);
% save(file);
