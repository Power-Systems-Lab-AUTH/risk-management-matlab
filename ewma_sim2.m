function [e_sim, mcov_sim] = ewma_sim2(e_0,mcov_0,u_sim,lambda)


[numrealizations,numvars] = size(u_sim);
mcov_sim=nan(numvars,numvars,numrealizations);
e_sim=nan(numrealizations,numvars);



v1=lambda*mcov_0(:,:,end)+(1-lambda)*(e_0(end,:)'*e_0(end,:));


mcov_sim(:,:,1)=v1;


e_sim(1,:)=u_sim(1,:)*(v1^0.5);


for t=2:numrealizations
    e_0=e_sim(t-1,:);
    v0=mcov_sim(:,:,t-1);
    v1=lambda*v0+(1-lambda)*(e_0'*e_0);
    %         v1 = EWMA_step(e0,v0,lambda,numvars);
    mcov_sim(:,:,t)=v1;
    e_sim(t,:)=u_sim(t,:)*(v1^0.5);

[sigmas mcorr] = cov2corr_3D(mcov_sim(:,:,1:t));
end


