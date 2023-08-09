function deal = deal_declaration_file_spec_example3;

index=1;



% This is a short position on the M01 italian electricity futures 
deal(index).market='IT';
deal(index).security='electricity';
deal(index).mat='M01';
deal(index).open_date='15-dec-2022';
deal(index).del_period = get_del_period('15-dec-2022','M01');
deal(index).close_date='expiration';
deal(index).sign='short';
% deal(index).size=1;
deal(index).size=length(deal(index).del_period);

index=index+1;
% This is a short position on the M02 italian electricity futures
deal(index).market='IT';
deal(index).security='electricity';
deal(index).mat='M02';
deal(index).open_date='15-dec-2022';
deal(index).del_period = get_del_period('15-dec-2022','M02');
deal(index).close_date='expiration';
deal(index).sign='short';
% deal(index).size=1;
deal(index).size=length(deal(index).del_period);

% 
index=index+1;
% 

% This is a short position on the M03 italian electricity futures
deal(index).market='IT';
deal(index).security='electricity';
deal(index).mat='M03';
deal(index).open_date='15-dec-2022';
deal(index).del_period = get_del_period('15-dec-2022','M03');
deal(index).close_date='expiration';
deal(index).sign='short';
% deal(index).size=1;
deal(index).size=length(deal(index).del_period);
% 
index=index+1;

% This is a long position on the Q01 italian electricity futures
deal(index).market='IT';
deal(index).security='electricity';
deal(index).mat='Q01';
deal(index).open_date='13-nov-2022';
deal(index).del_period = get_del_period('13-nov-2022','Q01');
deal(index).close_date='expiration';
deal(index).sign='long';
% deal(index).size=1;
deal(index).size=length(deal(index).del_period);