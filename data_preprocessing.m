function [data_new, dates_new, vnames excluded_vertices] = data_preprocessing2(data,dates,vnames)

% Remove outliers
[numobs numvars]=size(data);
data_new=data;
dates_new=dates;







[demeaned_data m]=demean(data_new);

[F, L, lambdas, W,reorder_index] = factor_static_estim(demeaned_data,numvars);

data_new=F*L'+m;

nv_ri=all(isnan(data),2);
data_new(nv_ri,:)=[];
dates_new(nv_ri,:)=[];

[numobs numvars]=size(data_new);

excluded_vertices=all(isnan(L),2);







 
 data1=nan(numobs,numvars);

for t=1:numobs
    
    
                data1(t,:) = interp1(find(~excluded_vertices),data_new(t,~excluded_vertices),1:numvars,"spline",'extrap');
%         data1(t,:) = interp1(find(index),data_new(t,index),1:numvars,"linear",'extrap');
%         nv_vert=data1(t,:)<0;
%         if any(nv_vert)
%             data1(t,nv_vert) = interp1(find(index),data_new(t,index),find(nv_vert),"nearest",'extrap');
%         end
    
end

data_new=data1;

excluded_vertices=find(excluded_vertices);



% vnames_new(nv_ci)=[];



% keyboard

