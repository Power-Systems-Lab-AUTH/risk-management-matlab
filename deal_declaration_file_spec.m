function deal = deal_declaration_file_spec;

index=1;





deal(index).market='IT';
deal(index).security='electricity';
deal(index).mat='M01';
deal(index).open_date='15-dec-2022';
deal(index).del_period = get_del_period('15-dec-2022','M02');
deal(index).close_date='expiration';
deal(index).sign='long';
deal(index).size=1*24;

index=index+1;

deal(index).market='IT';
deal(index).security='electricity';
deal(index).mat='M01';
deal(index).open_date='15-jan-2023';
deal(index).del_period = get_del_period(deal(index).open_date,'M01');
deal(index).close_date='expiration';
deal(index).sign='short';
deal(index).size=1*24;

