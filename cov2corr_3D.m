function [sigmas mcorr] = cov2corr_3D(mcov)

mcorr=nan(size(mcov));
numobs=size(mcov,3);
for t=1:numobs
    [sigmas(t,:),mcorr(:,:,t)] = cov2corr(mcov(:,:,t));
end
