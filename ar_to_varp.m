function [const_mv A] = ar_to_var1(const,AR_params, lag_structure)

nlags=length(lag_structure);

maxl=max(lag_structure);


A=zeros(maxl,maxl);
A(1,lag_structure)=AR_params;
A(2:end,1:maxl-1)=eye(maxl-1,maxl-1);


const_mv=[const; zeros(maxl-1,1)];