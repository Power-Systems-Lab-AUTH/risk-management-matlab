function [startingvals,nu,lambda,LLs,output_parameters]=variance_starting_values(data,arch,garch,distr_model,numvals)
% Perform a grid search to find decent starting values for TARCH(arch,O,Q)
% esimtation.  If starting values are user supplied (and thus nonempty), reformats
% starting values depending on error_type.
%
% USAGE:
%   [STARTINGVALS,NU,LAMBDA,LLS,OUTPUT_PARAMETERS] = ...
%        tarch_starting_values(STARTINGVALS,DATA,FDATA,FIDATA,arch,O,garch,T,ERROR_TYPE,TARCH_TYPE);
%
% INPUTS:
%   STARTINGVALS     - A vector of starting values or empty to perform a grid search
%   DATA             - Vector of mean zero residuals
%   FDATA            - Either abs(data) or data.^2, depending on tarch_type
%   FIDATA           - fdata times an indicator for negative, e.g. fdata.*(data<0)
%   arch                - The lag order length for ARCH
%   O                - The lag order of asymmetric terms
%   garch                - The lag order length for GARCH
%   T                - Length of data
%   ERROR_TYPE       - The type of error being assumed, valid types are:
%                        1 if 'NORMAL'
%                        2 if 'STUDENTST'
%                        3 if 'GED'
%                        4 if 'SKEWT'
%   TARCH_TYPE        - 1 for absolute vale of return
%                     - 2 for squared returns (standard case)
%
% OUTPUTS:
%   STARTINGVALS      - A vector of starting values (1+arch+o+garch) by 1
%   NU                - Distribution kurtosis parameter, empty if not applicable
%   LAMBDA            - Distribution asymmetry parameter, empty if not applicable
%   LLS               - A vector of log likelihoods corresponding to OUTPUT_PARAMETERS
%   OUTPUT_PARAMETERS - A matrix of alternative starting values, sorted by log likelihood
%
% COMMENTS:
%   See also TARCH

% Copyright: Kevin Sheppard
% kevin.sheppard@economics.ox.ac.uk
% Revision: 3    Date: 9/1/2005


%Initialize variables
LLs=[];
output_parameters=[];

%No starting values provided

nu=[];
lambda=[];

%Procedure is to find best starting values, using a grid search find values for normal, then
covar=cov(data);
if ~(arch==0 & garch==0)
    %Possible starting values based on commonly estimated values
    a=[.05 .1 .2];
    la=length(a);
    g=[.01 .05 .2];
    lg=length(g)+1;
    agb=[.5 .8 .9 .95 .99];
    lb=length(agb);
    
    %Many output_parameters and LLs
    output_parameters=zeros(la*lb*lg,1+arch+garch);
    LLs=zeros(la*lb*lg,1);
    
    %Adjustment is needed to the intercept.  Assumes normality
    
    adj_factor=1;
    back_cast=cov(data);
    
    
    
    %Use an index to count
    index=1;
    
    for i=1:la
        %Loop over a
        alpha=a(i);
        for j=1:lg
            %Loop over g
            if j==lg
                gamma=-alpha/2;
            else
                gamma=g(j);
            end
            
            for k=1:lb
                %Loop over beta
                temp_gamma=[];
                temp_alpha=alpha*ones(arch,1)/arch;
                %Make sure gamma satisfies necessary constraints
                %if o>0
                %    temp_gamma=gamma*ones(o,1)/o;
                %    for n=1:o
                %        if n<=arch
                %            temp_gamma(n)=max(temp_gamma(n),-alpha/(2*arch));
                %        else
                temp_gamma=0;
                %        end
                %    end
                %end
                %Beta must also satisfy the same constraints
                beta=agb(k)-sum(temp_alpha)-0.5*sum(temp_gamma);
                %Pick omega to match the unconditional
                omega=covar*(1-sum(temp_alpha)*adj_factor-0.5*sum(temp_gamma)-sum(beta));
                
                %Build the parameter vector
                parameters=omega;
                parameters=[parameters; temp_alpha];
                %parameters=[parameters; temp_gamma];
                if garch>0
                    parameters=[parameters; beta*ones(garch,1)/garch];
                end
                %Set the output parameters
                output_parameters(index,:)=parameters';
                %Set the log likelihoods
                
                %             LLF(index) = garch_n_like(parameters , data , arch , garch);
                
                %LLs(index)=tarch_likelihood(parameters, data, fdata, fIdata, arch, o, garch, 1, tarch_type, back_cast, T);
                %Increment
                index=index+1;
            end
        end
    end
    %Sort the LLs so the best (lowest, since we minimize the -1*LL)
    % [LLs,index]=sort(LLs);
    %Order the starting values
    % startingvals=output_parameters(index(1),:)';
    %Order the ouput_parameters
    % output_parameters=output_parameters(index,:);
    %Use generic values for nu and lambda if needed
    startingvals=output_parameters';
    K=cols(startingvals);
    
    % shuffle starting values
    if numvals<=K
        index=randsample(K,numvals); % same seed
    else
        index=randsample(K,numvals,1); % same seed
    end
    startingvals=startingvals(:,index);
else
    startingvals=covar*ones(1,numvals);
end



m=1;
% stdEstimate =  std(data,1);  
% datain        =  [stdEstimate(ones(m,1)) ; data];  

switch distr_model
    
    

    case {2,'t'}
        
         startingvals=[startingvals;nan(nX+1,numvals)];
        
        for k=1:numvals
            LLF=1e6;
            maxiter=500;
            j=0;
            while (LLF>1e6-1e-06) & j<=maxiter
                j=j+1;
                exogp=(6/nX*covar./ve).*unifrnd(-1,1,nX,1);
                nu=unifrnd(2,20,1,1);
                LLF=garch_t_exog_like([startingvals(1:end-nX-1,k); nu;exogp] , datain , arch , garch,exogin)                ;
            end
                        
            startingvals(end-nX:end,k)=[nu;exogp];
        end
        
    case {3,'sk'}
        
     
        startingvals=[startingvals;nan(nX+2,numvals)];
        
        for k=1:numvals
            LLF=1e6;
            maxiter=500;
            j=0;
            while (LLF>1e6-1e-6) & j<=maxiter
                j=j+1;
                exogp=(6/nX*covar./ve).*unifrnd(-1,1,nX,1);
                nu=unifrnd(4,20,1,1);
                lambda= unifrnd(-0.5,0.5,1,1);
                LLF=garch_sk_exog_like([startingvals(1:end-nX-2,k); nu;lambda;exogp] , datain , arch , garch,exogin)                ;
            end
                        
            startingvals(end-nX-1:end,k)=[nu;lambda;exogp];
        end
end




% 
% if distr_model==2
%     nu=unifrnd(4,20,1,numvals);
%     startingvals=[startingvals;nu];
% elseif distr_model==3
%     nu=unifrnd(4,20,1,numvals);
%     lambda= unifrnd(-0.5,0.5,1,numvals);
%     startingvals=[startingvals;nu;lambda];
% end








