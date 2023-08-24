function [outputArg1,outputArg2] = get_exper_setup

A=dir;

index=find_files2(A,{'exper'});

A=A(index);

A(~isfolder({A.name}))=[];

curdir='C:\Users\Pandelis\risk-management-matlab';
cd(curdir);
N=length(A);
for i=1:N
    cd([curdir '\' A(i).name]);

    load setup.mat

    Name{i,:}=A(i).name;
    For_hor{i,:}=num2str(for_hor);
    Sample_size{i,:}=num2str(sample_size);
    Sampling_window_length{i,:}=num2str(sampling_window_length);
    Vol_model{i,:}=num2str(vol_model);
    Trend_term{i,:}=num2str(trend_term);
    Exog_term{i,:}=num2str(exog_term);
    Lag_structure{i,:}=num2str(lag_structure);
    Data_file{i,:}=data_file;
end

cd(curdir);
% fid=fopen('exper_list')

T = table(Name,Data_file,For_hor,Sample_size,Sampling_window_length,Vol_model,Trend_term,Exog_term,Lag_structure);


filename = 'exper_list.xlsx';
writetable(T,filename)


% keyboard

