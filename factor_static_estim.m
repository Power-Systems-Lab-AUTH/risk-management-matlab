function [F, L, lambdas, W,reorder_index, nvi] = factor_static_estim(data,numfactors)

% This function estimates a factor model using principal components, under
% certain normalising assumptions

% INPUTS
% ------
% DATA is the TxN data matrix
% NUMFACTORS is the numFber of common factors to be estimated


% OUTPUTS
% --------
% F is the TxK matrix of estimated factor values (scores)
% L is the NxK matrix of estimated factor loadings
% LAMBDAS is the Nx1 array of eigenvalues of the covariance matrix of DATA
% (DATA'*DATA/T)
% REORDER_INDEX is an index of LAMBDAS 

[numobs, numvars]=size(data);

L=nan(numvars, numfactors);
data1=data;
nvi=isnan(data1);
data1(nvi)=0;
if numobs<numvars
    
    S=data1*data1';
    [W,D,~] = svd(S);
    % [W,D,~] = svdecon(S);
    lambdas=diag(D);
    [~, reorder_index]=sort(lambdas,'descend');
    W=W(:,reorder_index(1:numfactors));
    
    F=sqrt(numobs)*W;
    L=data'*F/numobs;
    
else
    
    S=(data1'*data1);
    [W,D,V] = svd(S);
    lambdas=diag(D);
    [~, reorder_index]=sort(lambdas,'descend');
    W=W(:,reorder_index(1:numfactors));
    %constraints type B
    L=sqrt(numvars)*W;
    F=data1*L/numvars;
    
    D=diag(lambdas(1:numfactors)/(numvars*numobs));
    D=D^(-0.5);
    F=F*D;
    L=L*D^(-1);
end

F(all(nvi,2),:)=nan;

L(all(nvi,1),:)=nan;
