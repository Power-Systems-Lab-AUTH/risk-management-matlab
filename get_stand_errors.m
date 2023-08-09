function uhat = get_stand_errors(ehat,mcov)


[numobs numvars]=size(ehat);

uhat=nan(numobs,numvars);

for t=1:numobs
    ic=mcov(:,:,t)^(-0.5);
    uhat(t,:)=ehat(t,:)*ic;
end