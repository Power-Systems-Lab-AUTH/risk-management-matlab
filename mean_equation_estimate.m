function [Chat Ahat Bhat ehat y exog_var_index] = mean_equation_estimate(dates_daily,data_daily)

[numobs numvars]=size(data_daily);
y=log(data_daily);
y=[nan(1,numvars);diff(y,1)];
d=make_dummies(dates_daily,[]);
numexog=cols(d);
dd=[nan(1,numexog);diff(d,1)];

lag_structure=[1 2 7];
[Chat Ahat Bhat ehat exog_var_index] = diag_varx_estimate(y, lag_structure, dd);

% subfolder = 'Simulation_Workspaces';
% file_name = strcat('Mean_Equation_Estimate.mat');
% file = fullfile(subfolder, file_name);
% save(file);
