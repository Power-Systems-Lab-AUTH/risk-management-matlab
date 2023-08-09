function [data_new, dates_new, maturities_new vnames_new val_row_index val_col_index] = data_preprocessing2(data,maturities,dates,vnames)

% Remove outliers
[numobs numvars]=size(data);


% Q05 has very thin data towards the end of the period
v_ci1=find_vertices(vnames,{'WKD','DA00','W00','M00','Q00','Y00','Q05'});
v_ci1=~any(v_ci1,2)';

v_ci2=logical(ones(1,numvars));
for i=1:numvars
    [d pos] = find_length_inactive_period(data(:,i));
    if any(d>28)
        v_ci2(i)=0;
    end
end




val_col_index=v_ci1 & v_ci2;

data_new=data(:,val_col_index);
maturities_new=maturities(:,val_col_index);
vnames_new=vnames(val_col_index);

val_row_index=all(~isnan(log(data_new)) & isfinite((log(data_new))),2);
data_new=data_new(val_row_index,:);
dates_new=dates(val_row_index,:);
maturities_new=maturities_new(val_row_index,:);

[numobs numvars]=size(data_new);









