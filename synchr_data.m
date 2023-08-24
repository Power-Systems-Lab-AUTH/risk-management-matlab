function [ehat,dates] = synchr_data(mean_model,risk_factor)

numfactors=length(mean_model);
numobs=cellfun(@(x) rows(x),{risk_factor.dates});
[m i]=min(numobs);

dates=risk_factor(i).dates;
ehat=nan(length(dates),numfactors);
for i=1:numfactors
    [~, loc]=ismember(dates,risk_factor(i).dates);
    ehat(:,i)=mean_model(i).ehat(loc,:);
end

v_index=all(~isnan(ehat),2);
ehat=ehat(v_index,:);
dates=dates(v_index);
 
% folderPath = fullfile(pwd, subfolder);  
% if ~isfolder(folderPath)  
%     mkdir(folderPath);  
% end
% 
% file_name = strcat('Synchr_Data.mat');
% file = fullfile(subfolder, file_name);
% save(file);
