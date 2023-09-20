function [Chat Ahat Bhat theta_hat ehat y exog_var_index] = mean_equation_estimate_frac(dates_daily,data_daily,trend_term,dummy_term,frac,lag_structure)

[numobs numvars]=size(data_daily);
y=log(data_daily);

if dummy_term~=0
    [MD WD]=make_dummies(dates_daily);

    if trend_term



        switch dummy_term

            case 1
                d=[MD WD(:,2:end)];
            case 2
                d=[WD(:,2:end)];
        end
    else
        switch dummy_term
            case 1
                d=[MD WD];
            case 2
                d=WD;
        end
    end
else

    d=[];
end
% lag_structure=[1 2 7];
% lag_structure=[1 ];

[Chat, Ahat,  Bhat, theta_hat, ehat, exog_var_index] = diag_frac_varx_estimate(y, lag_structure, d,trend_term,frac);


% subfolder = 'Simulation_Workspaces';
% file_name = strcat('Mean_Equation_Estimate.mat');
% file = fullfile(subfolder, file_name);
% save(file);
