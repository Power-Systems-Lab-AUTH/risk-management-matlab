%% Data Configuration

% 'GR_DAM' / 'IT_PUN' / 'TTF'
file_srt={'IT_PUN'; 'GR_DAM'};

% '1-month' / '3-month' / '6-month' / '12-month' / 'all'
period_srt={'1-month'; '3-month'; '6-month'; '12-month'; 'all'};

% vol=1 / non-vol=0
vol=0:1;

% Vol loop
for vol_model=vol
    
    % Input data loop
    for file_idx=1:rows(file_srt)
        
        % Analysis Period loop 
        for period_idx=1:rows(period_srt)

            file = file_srt(file_idx, 1);
            file = file{1};
            period = period_srt(period_idx, 1);
            period = period{1};

            ref_day='01-feb-23';
            ref_date = datetime(ref_day, 'InputFormat', 'dd-MMM-yy');
            end_day='28-feb-23';
            if strcmp(period, '1-month')
                start_day = ref_date - calmonths(1);
            elseif strcmp(period, '3-month')
                start_day = ref_date - calmonths(3);
            elseif strcmp(period, '6-month')
                start_day = ref_date - calmonths(6);
            elseif strcmp(period, '12-month')
                start_day = ref_date - calmonths(12);
            elseif strcmp(period, 'all')
                start_day = 0;
            else
                return;
            end

            % Number of scenarios loop
            for num_of_scenarios=1000:100:1000
                log_file=0;
                file_prefix='';
                holding_period = datenum(end_day) - datenum(ref_day);

                w = [100, 150, 200];

                % Subfolder Creation
                subfolder = 'Simulation_Workspaces';  
                folderPath = fullfile(pwd, subfolder);  
                if ~isfolder(folderPath)  
                    mkdir(folderPath);  
                end

                subfolder = strcat('Simulation_Workspaces/', file, '_', period, '_', ref_day, '_', end_day, '_numScen=', num2str(num_of_scenarios), '_vol=', num2str(vol_model));
                folderPath = fullfile(pwd, subfolder);  
                if ~isfolder(folderPath)  
                    mkdir(folderPath);  
                end

                % Main Loop
                average_rf = zeros(1,length(w));
                for i = 1:length(w)

                    subsubfolder = strcat(subfolder, ['/W=', num2str(w(i))]);
                    folderPath = fullfile(pwd, subsubfolder);  
                    if ~isfolder(folderPath)  
                        mkdir(folderPath);  
                    end

                    % Run simulation
                    average_rf(i) = demo_risk_factors_boot(file, start_day, ref_day, end_day, holding_period, 0.05, vol_model, num_of_scenarios, w(i), log_file, file_prefix, subsubfolder);
                end
            end

            figure
            plot(w, average_rf)

            filename = fullfile(subfolder, 'average.png');
            saveas(gcf, filename);
        end
    end
end

%% Example 2
% for num_of_scenarios=500:100:700
%     start_day='01-mar-19';
%     ref_day='01-jul-19';
%     end_day='01-aug-19';
%     log_file=0;
%     file_prefix='stable';
%     holding_period = datenum(end_day) - datenum(ref_day);
%     %for w=1:floor(holding_period/5):holding_period
%     for w=10:10:30
%         % non_vol
%         demo_risk_factors_boot({'IT','IT'},{'electricity','electricity'},{'',''}, start_day, ref_day, end_day, holding_period, 0.05, 0, num_of_scenarios, w, log_file, file_prefix);
% 
%         % vol
%         %demo_risk_factors_boot({'IT','IT'},{'electricity','electricity'},{'',''}, start_day, ref_day, end_day, holding_period, 0.05, 1, num_of_scenarios, w, log_file, file_prefix);
%     end
% end
