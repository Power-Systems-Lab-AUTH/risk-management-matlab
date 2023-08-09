function delivery_dates = get_del_year(cur_date,offset)

cur_year=year(cur_date);


delivery_year=cur_year+offset; 

delivery_dates=datenum(delivery_year,1,1):datenum(delivery_year,12,31);



