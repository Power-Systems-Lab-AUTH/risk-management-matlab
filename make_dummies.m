function D= make_dummies(dates, HD)


MD=dummyvar(month(dates));

WD=dummyvar(weekday(dates));


D=[MD(:,2:end) WD(:,2:end)  HD  ];