function [C_full, A_full, B_full]=varp_to_var1(C,A,B)

maxl=length(A);
numvars=size(A{1},1);

% Estimate VAR(1) counterpart of VAR(p)

m=(maxl-1)*numvars;
D=kron(eye(numvars),eye(maxl-1));
D=[D zeros(m,numvars)];
A_full=[[A{:}] ; D];


C_full=[C; zeros(m,1)];

ne=size(B,2);
B_full=[B; zeros(m,ne)];