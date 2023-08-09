function mcov = ewma_sim_nan(e,lambda)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[numobs,numvars] = size(e);



mcov=NaN(numvars,numvars,numobs);
mcov(:,:,1)=cov(e,'partialrows');


for t=2:numobs

    p=e(t-1,:)'.*e(t-1,:);


    for i=1:numvars

        for j=1:numvars
            v=squeeze(mcov(i,j,1:t-1));

            % If there is no previous-day covariance estimate use the
            % last available one


            index=find(~isnan(v),1,'last');
            v=v(index);


            if ~isempty(v)
                if ~isnan(p(i,j))
                    mcov(i,j,t)=lambda*v+(1-lambda)*p(i,j);
                else
                    mcov(i,j,t)=lambda*v;
                end


            end

        end
    end
end