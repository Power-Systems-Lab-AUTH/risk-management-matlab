function [Chat Ahat Bhat ehat y exog_var_index] = mean_equation_estimate(dates_daily,data_daily,trend_term, exog_term,lag_structure)

[numobs numvars]=size(data_daily);
y=log(data_daily);
if exog_term
    {MD WD]=make_dummies(dates_daily);
    d=[MD WD];
else
    d=[];
end

numexog=cols(d);
y=[nan(1,numvars);diff(y,1)];
dd=[nan(1,numexog);diff(d,1)];

% lag_structure=[1 2 7];
% lag_structure=1;
[Chat Ahat Bhat ehat exog_var_index] = diag_varx_estimate(y, lag_structure, dd);

% subfolder = 'Simulation_Workspaces';
% file_name = strcat('Mean_Equation_Estimate.mat');
% file = fullfile(subfolder, file_name);
% save(file);
