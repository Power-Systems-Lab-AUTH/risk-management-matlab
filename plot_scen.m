function [outputArg1,outputArg2] = plot_scen(y,dates,date0, holding_period,y_sim)

if iscolumn(y_sim); y_sim=y_sim';end

numobs=size(y,1);


dates_sim=date0+holding_period;


dates_ext=[dates ;dates(end)+(1:60)'];

y_ext=[y; zeros(60,1)];
plot(dates_ext,y_ext);

hold on
plot(dates_sim,y_sim,'g.');
hold off