function delivery_dates = get_del_quarter(cur_date,offset)

cur_quarter=quarter(cur_date);

cur_year=year(cur_date);


qqq=repmat((1:4)',[10 1]);
yyy=repmat(cur_year+(0:9), [4 1]);
yyy=yyy(:);

delivery_quarter=find(cur_quarter==qqq & cur_year==yyy);
delivery_quarter=delivery_quarter+offset;

yyy=yyy(delivery_quarter);
qqq=qqq(delivery_quarter);

switch qqq

    case 1
        start_month=1;
        end_month=3;

    case 2


        start_month=4;
        end_month=6;

    case 3


        start_month=7;
        end_month=9;

    case 4

        start_month=10;
        end_month=12;

end



delivery_dates=datenum(yyy,start_month,1):datenum(yyy,end_month,eomday(yyy,end_month));



