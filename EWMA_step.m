function mcov_new = EWMA_step(e,mcov_0,lambda,numvars)

p=e'.*e;

mcov_new=nan(numvars,numvars);

for i=1:numvars

    for j=1:numvars
        v=squeeze(mcov_0(i,j,1:end));

        % If there is no previous-day covariance estimate use the
        % last available one


        index=find(~isnan(v),1,'last');
        v=v(index);


        if ~isempty(v)
            if ~isnan(p(i,j))
                mcov_new(i,j)=lambda*v+(1-lambda)*p(i,j);
            else
                mcov_new(i,j)=lambda*v;
            end


        end

    end
end


end