function delivery_dates = get_del_month(cur_date,offset)

cur_month=month(cur_date);
cur_year=year(cur_date);


mmm=repmat((1:12)',[10 1]);
yyy=repmat(cur_year+(0:9), [12 1]);
yyy=yyy(:);

delivery_month=find(cur_month==mmm & cur_year==yyy);
delivery_month=delivery_month+offset;

yyy=yyy(delivery_month);
mmm=mmm(delivery_month);
delivery_dates=datenum(yyy,mmm,1):datenum(yyy,mmm,eomday(yyy,mmm));



