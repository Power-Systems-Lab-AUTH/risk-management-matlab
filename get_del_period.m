function delivery_dates = get_del_period(cur_date,vname)



index = find_vertices({vname},{'M','Q','Y'});
index=find(index);

offset = find_maturity({vname});



switch index
    case 1 % Monthly contracts

        
        delivery_dates = get_del_month(cur_date,offset);

    case 2 % Quarterly contracts

        
        delivery_dates = get_del_quarter(cur_date,offset);


    case 3 % Yearly contracts 
        delivery_dates = get_del_year(cur_date,offset);
end
