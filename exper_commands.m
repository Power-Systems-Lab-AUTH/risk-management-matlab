function exper_commands


% % data_file='IT_PUN';
% curdir='C:\Users\Pandelis\risk-management-matlab\IT_PUN';

curdir='C:\Users\Pandelis\risk-management-matlab\GR_DAM_no_frac';

data_file='GR_DAM';
% curdir='C:\Users\Pandelis\risk-management-matlab\IT_PUN_no_frac';


cd(curdir)

vol_model=[0 1];
for_hor=[1:6];
trend_term=[0 1];

dummy_term=[1 0 -1];

sample_size=[250 500];

lag_structure={[],[1]};

sampling_size_window=[10 50 100];
frac=[0 1];

% frac=[0];
index=0;

for j=1:length(vol_model)
    for i=1:length(for_hor)




        for k=1:length(sample_size)

            for l=1:length(dummy_term)
                for m=1:length(trend_term)

                    for n=1:length(lag_structure)

                        for p=1:length(sampling_size_window)
                            for q=1:length(frac);

                            index=index+1;

                            str=['exper_' num2str(index)];
                            mkdir(str);

                            cd([curdir '\' str])
                            make_exper(data_file, sample_size(k), vol_model(j), 5000, for_hor(i),sampling_size_window(p),trend_term(m),dummy_term(l),frac(q),lag_structure{n});
                            cd(curdir);
                            end
                        end
                    end
                end
            end
        end
    end
end