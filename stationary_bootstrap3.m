function indices=stationary_bootstrap3(estim_sample_size,sim_sample_size,w,numbootsamples)
% Implements the stationay bootstrap for bootstrapping stationary, dependent series

indices=nan(sim_sample_size,numbootsamples);
for j=1:numbootsamples
    indices(:,j) = StationaryBootstrap((1:estim_sample_size)', w, sim_sample_size);
end

