function [MD WD]= make_dummies(dates)


% MD=dummyvar(month(dates));

MD = calc_monthly_determ(dates);

WD=dummyvar2(weekday(dates),1:7);


% D=[MD(:,2:end) WD(:,2:end)  HD  ];