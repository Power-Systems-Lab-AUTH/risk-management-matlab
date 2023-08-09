function [deals_new, risk_factor] = get_risk_factors(deals, ref_date)

warning off
numdeals=length(deals);

ref_date=datenum(ref_date);
deals_new=deals;
risk_factor_index=0;
for i=1:numdeals
    security=deals(i).security;
    mat=deals(i).mat;
    market=deals(i).market;
    close_date=deals(i).close_date;

    disp('------------------')

    str=['Deal #  ' num2str(i)];
    disp(str)


    str=['Extracting risk factors for ' market ' ' security ' ' mat];
    disp(str)


    if ~strcmp(mat,'spot') % Case the deal is on a futures contract
        if strcmp(close_date,'expiration') % Case the contract is held until expiration
            disp('The futures contract is held until expiration. ')
            disp(['The risk factor is the  '  market ' ' security ' spot index'])


%             output=findcell({deals(1:i-1).security},security) & findcell({deals(1:i-1).mat},'spot');
output=findcell({deals(1:i-1).security},security);
%             if ~any(output)
%                 output=findcell({deals(1:i-1).security},security) & findcell({deals(1:i-1).mat},mat);
%             end
            if any(output) & ~isempty(output)
                output=deals_new(output).risk_factor_index;
                % If a parallel position on the spot market is taken
                % this as a risk factor
                disp('A parallel position on the spot/futures market is taken')
                disp(['Mapping to risk factor ' num2str(output)])
                deals_new(i).risk_factor_index=output;

                extract_risk_factor=0;
            else
                % Otherwise extract a new risk factor (spot index)
                extract_risk_factor=1;
                [time_series, dates_daily, vnames] = get_data_file(market,security,'spot',close_date);

            end
        else
            extract_risk_factor=1;
            [time_series, dates_daily, vnames] = get_data_file(market,security,mat,close_date);

        end
    else
        extract_risk_factor=1;
        [time_series, dates_daily, vnames] = get_data_file(market,security,mat,close_date);
    end




    if extract_risk_factor==1;


        risk_factor_index=risk_factor_index+1;




        dates_daily=datenum(datestr(dates_daily));
        j=find(dates_daily==ref_date);
        dates_daily=dates_daily(1:j);

        risk_factor(risk_factor_index).time_series=time_series(1:j);
        risk_factor(risk_factor_index).dates=dates_daily;
        deals_new(i).risk_factor_index=risk_factor_index;

    end

end






