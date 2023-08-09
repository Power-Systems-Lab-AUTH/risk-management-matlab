function make_plot_density_for(dates,y,dates_for,y_scen,sig,x_range)


plot(dates,y,'.-')

hold on

if cols(y_scen)>rows(y_scen);
    y_scen=y_scen';
end

pd=fitdist(y_scen,'kernel','kernel','epanechnikov');

if nargin>5
    x_range=(x_range(1):0.001:x_range(end))';
else
x_range=(nanmin(y):0.001:nanmax(y))';
end

pdf_range = pdf(pd,x_range);


tol=100;

% plot(dates_for, zeros(rows(x_range),1)),'-';
% line([dates_for dates_for],[min(x_range) max(x_range)],'Color','r')
plot(dates_for+pdf_range*tol,x_range,'g');


patch(dates_for+pdf_range*tol,x_range,'green');

% VaR positioning
cdf_range = cdf(pd,x_range);
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

