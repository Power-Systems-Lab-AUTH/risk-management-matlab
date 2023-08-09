function deal = deal_declaration_file_hedge_example2;

index=1;




deal(index).market='IT';
deal(index).security='electricity';
deal(index).mat='spot';
deal(index).open_date=datestr(datenum(2023,1,1));
deal(index).del_period=[];
deal(index).close_date=datestr(datenum(2023,12,31));
deal(index).sign='sell';
deal(index).size=24;

str={'M01','M02','M03','Q02','Q03','Q04'};

for i=1:length(str)
    deal(index+i).market='IT';
    deal(index+i).security='electricity';
    deal(index+i).mat=str{i};
    deal(index+i).open_date='15-dec-2022';
    deal(index+i).del_period = get_del_period(deal(index+i).open_date,str{i});
    deal(index+i).close_date='expiration';
    deal(index+i).sign='short';
    deal(index+i).size=1*24;
end
