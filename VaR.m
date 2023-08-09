function y = VaR(x,p)

% p is the significance level
y=quantile(x,p);