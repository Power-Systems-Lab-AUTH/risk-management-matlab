function [outputArg1,outputArg2] = make_exper(data_file, sample_size, vol_model, numscenarios, for_hor,sampling_window_length,trend_term,dummy_term,frac,lag_structure)
%% Extract data on risk factors
numfactors=24;

%data_file = '7323_Jun';
data = dlmread([data_file, '_price.csv'], ',');
data=data(:,1:24);
data(data<1e-1)=1e-1;
dates = dlmread([data_file, '_dates.csv'], ',');
dates_daily = dates(:,1);

som_index=find(day(dates_daily)==1);
eom_index=som_index-1;

index=eom_index<sample_size | eom_index<=0;
som_index(index)=[];
eom_index(index)=[];

ref_dates=dates_daily(eom_index);
start_dates=ref_dates-sample_size+1;
end_dates=dates_daily(eom_index(for_hor+1:end));

save('setup')

numrep=length(end_dates);
cov_model=[];

% [risk_factor_sim, risk_factor,mean_model, cov_model] = scen_gen_frac_boot(data, dates_daily,start_dates(1),ref_dates(1), end_dates(1), vol_model, numscenarios, sampling_window_length);

% risk_factor_sim=risk_factor_sim1;
% risk_factor=risk_factor1;

% mean_model=mean_model1;
% if vol_model
% cov_model=cov_model1;
% end

% risk_factor_sim=repmat(risk_factor_sim,[1 numrep]);
% risk_factor=repmat(risk_factor,[numrep 1]);
% mean_model=repmat(mean_model,[numrep 1]);
% cov_model=repmat(cov_model,[numrep 1]);

tic
for i=1:numrep
% for i=1:numrep
    i
    % try
    tic
    [risk_factor_sim, risk_factor,mean_model, cov_model] = scen_gen_frac_boot(data, dates_daily,start_dates(i),ref_dates(i), end_dates(i), vol_model, numscenarios, sampling_window_length,trend_term,dummy_term,frac,lag_structure);

    % risk_factor_sim(:,i)=risk_factor_sim1;
    % risk_factor(i,:)=risk_factor1;

    % mean_model(i,:)=mean_model1;
    % if vol_model
    % cov_model(i,:)=cov_model1;

    % ;
    % end

    % catch
    % keyboard
    % end
    toc
    mm=month(ref_dates(i)+1);

    yy=year(ref_dates(i));
    if mm<10
        str=['exper_' num2str(yy) '_0' num2str(mm) '.mat'] ;
        
    else
        str=['exper_' num2str(yy) '_' num2str(mm)  '.mat'];
    end
    m=matfile(str,'Writable',true);
    
    m.risk_factor_sim=risk_factor_sim; 
    m.risk_factor=risk_factor;
    m.mean_model=mean_model 
    m.cov_model=cov_model;
end
toc
% keyboard