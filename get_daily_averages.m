function [x_daily dates_daily] = get_daily_averages(x,TimeStart,TimeEnd)

% This is used for Italian electricity spot 
yyy=year(TimeStart);

mmm=month(TimeStart);

ddd=day(TimeStart);

dates=datenum(yyy,mmm,ddd);

start_d=dates(1);
end_d=dates(end);

dates_daily=(start_d:end_d)';
x_daily=nan(rows(dates_daily),cols(x));

for t=1:length(dates_daily)
    index=find(dates==dates_daily(t));
    x_daily(t,:)=nansum(x(index,:),1);
end
% keyboard