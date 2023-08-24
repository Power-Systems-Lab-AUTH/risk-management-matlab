function MD = calc_monthly_determ(dates)

% months=unique(month(dates));
months=1:12;
years=unique(year(dates));

lm=length(months);
ly=length(years);

for i=1:lm
    MD(:,i)=zeros(length(dates),1);
    for j=1:ly

        f1 = calc_values_determ(dates,months(i),years(j));

        MD(:,i)=MD(:,i)+f1;
    end
end