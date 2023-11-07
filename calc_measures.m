function [outputArg1,outputArg2] = calc_measures(quantiles,data_name)


% curdir='C:\Users\Pandelis\risk-management-matlab';


curdir=['D:\RiskProject\' data_name];

cd(curdir);

A=dir;

index=find_files2(A,{'exper'});

A=A(index);

A(~isfolder({A.name}))=[];



N=length(A);

for i=1:length(A)
    i
    cd([curdir '\' A(i).name]);

    load setup.mat

    Name{i,:}=A(i).name;
    For_hor(i,:)=for_hor;
    Sample_size{i,:}=num2str(sample_size);
    Sampling_window_length{i,:}=num2str(sampling_window_length);
    Vol_model{i,:}=num2str(vol_model);
    Trend_term{i,:}=num2str(trend_term);
    Dummy_term{i,:}=num2str(dummy_term);
    Lag_structure{i,:}=num2str(lag_structure);
    Data_file{i,:}=data_file;


    try
    [dates_daily rel_data q risk_factor_sim] = get_forecasts(quantiles);
    index=find(quantiles==0.5);

    p1=(abs(q(:,index)-rel_data)./rel_data);
    MAE{i,:}=num2str(mean(p1)*100,'%3.2f');
    hit_rate(i,:)=100*sum(rel_data< q)/length(q);
    i

    catch
    MAE{i,:}='-1';
    hit_rate(i,:)=-1*ones(1,length(quantiles));
    end

end

cd(curdir);
% fid=fopen('exper_list')
% [~,I]=sort(MAE);
[~,I]=sort(For_hor);

T = table(Name,Data_file,For_hor,Sample_size,Sampling_window_length,...
    Vol_model,Trend_term,Dummy_term,Lag_structure,MAE,hit_rate);
T=sortrows(T,'MAE');

filename = ['exper_list_' data_name '.xlsx'];
writetable(T,filename)


% keyboard

