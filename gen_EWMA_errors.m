function eboot = gen_EWMA_errors(ehat,lambda,holding_period,numscenarios)




[numobs numvars]=size(ehat);

mcov_insample = ewma_sim(ehat,lambda);

uhat = get_stand_errors(ehat,mcov_insample);

uboot=nan(holding_period,numvars,numscenarios);
w=round(holding_period/3);
% w=20;


[uboot(:,1,:), indices]=stationary_bootstrap2(uhat(:,1),numscenarios,w, holding_period);

for i=2:numvars
    u1=uhat(indices(:),i);
    uboot(:,i,:)=reshape(u1,[holding_period numscenarios]);
end

eboot=nan(size(uboot));

mcov(:,:,1)=lambda*mcov_insample(:,:,end)+(1-lambda)*(ehat(end,:)'*ehat(end,:));
for b=1:numscenarios
    u1=squeeze(uboot(:,:,b));
    e1(1,:)=u1(1,:)*(mcov(:,:,1)^0.5);

    for t=2:holding_period

        mcov(:,:,t)=lambda*mcov(:,:,t-1)+(1-lambda)*(e1(t-1,:)'*e1(t-1,:));
        e1(t,:)=u1(t,:)*(mcov(:,:,t)^0.5);

    end
    eboot(:,:,b)=e1;
    [sigmas mcorr] = cov2corr_3D(mcov);
end
% keyboard









