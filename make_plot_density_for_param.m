function make_plot_density_for_param(dates,y,dates_for,mu,sigma,sig,x_range)


plot(dates,y,'.-')

hold on


if nargin>5
    x_range=(x_range(1):0.05:x_range(end))';
end

pdf_range = normpdf(log(x_range/y(end)),mu,sigma);


tol=100;

% plot(dates_for, zeros(rows(x_range),1)),'-';
% line([dates_for dates_for],[min(x_range) max(x_range)],'Color','r')
plot(dates_for+pdf_range*tol,x_range,'g');


patch(dates_for+pdf_range*tol,x_range,'green');

% VaR positioning
cdf_range = normcdf(log(x_range/y(end)),mu,sigma);
i=find(cdf_range>=sig,1,'first');

h1=line([dates_for dates_for+pdf_range(i)*tol],[x_range(i) x_range(i)],'LineWidth',2,'Color','r');

legend(h1,['Lower(' num2str(100*(sig)) '%)'])


i=find(cdf_range>=1-sig,1,'first');

h2=line([dates_for dates_for+pdf_range(i)*tol],[x_range(i) x_range(i)],'LineWidth',2,'Color','r');

legend(h2,['Upper(' num2str(100*(1-sig)) '%)'])


datetick('x','mmm yyyy')

holding_period=dates_for-dates(end);
title(['Holding period: ' num2str(holding_period) ' days'])

hold off

