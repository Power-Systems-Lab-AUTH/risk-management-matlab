function [final_value_portfolio final_value F0]= PnL_portfolio(risk_factor_sim,deal_new)


numdeals=length(deal_new);

F0=nan(numdeals,1);

for i=1:numdeals

    i
    risk_factor_index=deal_new(i).risk_factor_index;
    mat=deal_new(i).mat;
    close_date=deal_new(i).close_date;

    switch mat
        case 'spot'

            [final_value(:,i), mark_to_market1{i}] = PnL_spot_sim(risk_factor_sim(risk_factor_index),deal_new(i));

        otherwise

            % Case the contract is held until expiration
            F0(i)=get_future_price(deal_new(i));

            [final_value(:,i), mark_to_market1{i}] = PnL_forward_expiration_sim(risk_factor_sim(risk_factor_index),deal_new(i),F0(i));



    end

end

final_value_portfolio=sum(final_value,2);

% str=[];
% figure
% for i=1:numdeals
%     h(i)=plot(deal_new(i).del_period,mark_to_market1{i}(:,3))
% %     str=[str {num2str(i)}]
%  str=[str {deal_new(i).mat}]
%     hold on
% end

% legend(h,str)
% datetick('x','mmm yyyy')


% keyboard