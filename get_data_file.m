function [risk_factor, dates_daily, vnames] = get_data_file(market,security,mat, close_date)

if strcmp(close_date,'expiration')

    switch security

        case 'gas'
            file_name='TTF_spot_data.mat';
        case 'electricity'
            file_name='IT_power_spot_data.mat';
    end
else

    switch security

        case 'gas'

            switch mat
                case 'spot'
                    file_name='TTF_spot_data.mat';
                otherwise
                    file_name='TTF_fut_data.mat';

            end

        case 'electricity'



            switch mat
                case 'spot'
                    file_name='IT_power_spot_data.mat';
                otherwise
                    file_name='IT_power_fut_data.mat';

            end

    end
end

s=load(file_name,'data_daily','dates_daily','vnames');

risk_factor=s.data_daily;
dates_daily=s.dates_daily;
vnames=[];
if isfield(s,'vnames')
    vnames=s.vnames;
    index = find_vertices(vnames,mat);
    risk_factor=risk_factor(:,index);
    hor = find_horizon(vnames);
end

