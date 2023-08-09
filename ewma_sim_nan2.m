function [e_sim, mcov_sim] = ewma_sim_nan2(e_0,mcov_0,u_sim,lambda)


[numrealizations,numvars,numscenarios] = size(u_sim);

mcov_sim=nan(numvars,numvars,numrealizations,numscenarios);
e_sim=nan(numrealizations,numvars,numscenarios);
function [e_sim, mcov_sim] = ewma_sim2(e_0,mcov_0,u_sim,lambda)


[numrealizations,numvars, numscenarios] = size(u_sim);
mcov_sim=nan(numvars,numvars,numrealizations, numscenarios);
e_sim=nan(numrealizations,numvars, numscenarios);

for b=1:numscenarios
    [e_sim1, mcov_sim1] = ewma_sim2(e_0,mcov_0,u_sim(:,:,b),lambda);
    e_sim(:,:,b)=e_sim1;
    mcov_sim(:,:,:,b)=mcov_sim1;
end

