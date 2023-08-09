function mcov = ewma_sim(e,lambda)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[numobs,numvars] = size(e);


mcov=NaN(numvars,numvars,numobs);
mcov(:,:,1)=cov(e,'partialrows');


for t=2:numobs

    p=e(t-1,:)'*e(t-1,:);
    v=mcov(:,:,t-1);
    mcov(:,:,t)=lambda*v+(1-lambda)*p;

end

