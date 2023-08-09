function CV = CVaR(x,p)

%p is the significance level 
q=VaR(x,p);

N=cols(x);
for i=1:N
    CV(i)=nanmean(x(x(:,i)<q(i),i));
end

CV=CV/p;