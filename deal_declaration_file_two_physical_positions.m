function deal = deal_declaration_file_two_physical_positions;

index=1;



% This is a deal of selling electricity between Jan 01 and Jan 31, 2023. The contract is for deliverying 24 MWh per day at the
% PUN spot price 

deal(index).market='IT';
deal(index).security='electricity';
deal(index).mat='spot';
deal(index).open_date=datestr(datenum(2023,1,1));
deal(index).del_period=[];
deal(index).close_date=datestr(datenum(2023,1,31));
deal(index).sign='sell';
deal(index).size=24;

index=index+1;

% This is a deal of buying gas between Jan 01 and Jan 31, 2023. The contract is for bying 24*2=28 MWh per day at the
% IT gas spot price 
deal(index).market='IT';
deal(index).security='gas';
deal(index).mat='spot';
deal(index).open_date=deal(index-1).open_date;
deal(index).del_period=[];
deal(index).close_date=deal(index-1).close_date;
deal(index).sign='buy';
deal(index).size=deal(index-1).size/0.5;
