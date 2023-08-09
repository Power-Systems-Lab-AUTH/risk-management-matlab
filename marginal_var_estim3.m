function results=marginal_var_estim3(resid)

num_starting_points=2;

% if isexog
%     exog=exog(end-T+1:end,:);
% end

arch=1;
garch=1;
startingvals=variance_starting_values(resid, arch,garch,'n',num_starting_points);
results=garch_n(resid , startingvals, arch , garch);
