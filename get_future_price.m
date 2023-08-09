function F0 = get_future_price(deal)


security=deal.security;
mat=deal.mat;
open_date=datenum(deal.open_date);



switch security

    case 'gas'

        file_name='TTF_fut_data.mat';


    case 'electricity'



        file_name='IT_power_fut_data.mat';


end

s=load(file_name,'data_daily','dates_daily','vnames');

data_daily=s.data_daily;
dates_daily=datenum(s.dates_daily);
vnames=s.vnames;
col_index = find_vertices(vnames,{mat});

date_index=find(dates_daily==open_date);

F0=data_daily(1:date_index,col_index);

F0=F0(find(~isnan(F0),1,'last'));


