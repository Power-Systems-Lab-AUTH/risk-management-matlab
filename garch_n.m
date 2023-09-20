function [results] = garch_n(data , startingvals, arch , garch)
% PURPOSE:
%     Function designed to estimate a univariate Garch model for the variance equation.
%
%
% USAGE:
%     [results] = [results]   = uni_garch(data,arch, garch)
%
%
% INPUTS:
%     data     - A matrix m x n of data input (m: # of observations, n: # of time series
%     arch     - # of arch coefficients in uni variance equations
%     garch    - # of garch coefficients in uni variance equation
%
%
%
%
%
%
%
%
% COMMENTS:
%
%
%
%
% Authors:
%
% Date: 03/2009

T=size(data,1);

if size(data,2) > 1
    error('Data series must be a column vector.')
elseif isempty(data)
    error('Data Series is Empty.')
end


if (length(garch) > 1) | any(garch < 0)
    error('garch must ba a single positive scalar or 0 for ARCH.')
end

if (length(arch) > 1) | any(arch <  0)
    error('arch must be a single positive number.')
elseif isempty(arch)
    error('arch is empty.')
end

if isempty(garch) | garch==0;
    garch=0;
    m=arch;
else
    m  =  max(arch,garch);
end


%nr=size(exog,2);

LB  =  [1e-6*ones(1,1+arch+garch)];
UB  =  0.9999*ones(1,1+arch+garch);
sumA =  [-eye(1+arch+garch); ...
    0  ones(1,arch)  ones(1,garch)];

sumB =  [1e-04; zeros(arch+garch,1);...
    0.999];


warning off
% options = optimset('UseParallelss','always');
% options  =  optimset('fmincon');
options.TolFun=1e-006;
options.TolX=1e-006;
options.Display='off';
options.Diagnostics='off';
% options  =  optimset(options , 'LargeScale'  , 'off');
options.MaxFunEvals=400*(2+arch+garch);





%startingvals = [omega ; alpha ; beta];

% Estimate the parameters.
T=size(data,1);

[numparams,numrepetitions]=size(startingvals);


parameters=nan(numparams,numrepetitions);

LLF=nan(numrepetitions,1);


for k=1:numrepetitions
    
    warning off
    [parameters(:,k), LLF(k), EXITFLAG(k), OUTPUT, LAMBDA, GRAD] =  fmincon('garch_n_like', startingvals(:,k) ...
        ,sumA  , sumB ,[] , [] , LB , UB,[],options, data, arch , garch);
    % Unconstrained minimization alternative 
    % [parameters(:,k), LLF(k), EXITFLAG(k), OUTPUT, LAMBDA, GRAD] =  fminunc('garch_n_like_uncon', startingvals(:,k),options, data, arch , garch);

end

% sect=find(EXITFLAG>1);
% jsect = [sect' LLF(sect,1)];
% [opt m]=min(jsect(:,2));
% LLF=LLF(jsect(m,1),1);
% parameters=parameters(:,jsect(m,1));
% ExitFlag = EXITFLAG(jsect(m,1));

[opt m]=min(LLF);
LLF=LLF(m);
parameters=parameters(:,m);
ExitFlag = EXITFLAG(m);

if ExitFlag<=0
    ExitFlag
    fprintf(1,'Not Sucessful! \n')
end

%parameters(find(parameters    <  0)) = 0;
%parameters(find(parameters(1) <= 0)) = realmin;

%hess = hessian_2sided('garch_n_like',parameters,datain,arch,garch);
[LLF, LLF_contr, ht]=garch_n_like(parameters,data,arch,garch);
%stderrors=hess^(-1);
%stderrors = sqrt(diag(stderrors));
% nw=0;
% [VCVrobustm,A,B,scores,hess]=robusterrors('garch_n_like',parameters,nw,datain,arch,garch);
% VCVm=hess^(-1)/T; % this is the parameters varcov matrix
% VCVrobust=sqrt(diag(VCVrobustm));
% VCV = sqrt(diag(VCVm));


sResid = data./sqrt(ht);
% the transformation of iid residuals to U(0,1)

results.Resid=data;
results.sResid=sResid;
results.param=parameters;
results.arch=arch;
results.garch=garch;
results.tarch=0;
results.LLF=-LLF;
results.ht=ht;
results.LLF_contr=LLF_contr;
% results.VCV=VCVm;
% results.VCVrobust=VCVrobustm;
results.distr_type = 'n';
results.vol_model= 'GARCH';
results.GoFdistr = [];
results.ExitFlag =ExitFlag;
results.exog=[];