function f = calc_values_determ(dates,mmonth,yyear)

d=eomday(yyear,mmonth);

% Gaussian
m=datenum(yyear,mmonth,round(d/2));
sigma=(m-datenum(yyear,mmonth,1))/1.5;

t=dates-m;
% maxf=1/(sigma*sqrt(2*pi));
% f=maxf*exp(-0.5*t.^2/sigma^2);

f=exp(-0.5*t.^2/sigma^2);



