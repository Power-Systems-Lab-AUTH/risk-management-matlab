function vnames = get_future_vertix_label(labels)

i1=strfind(labels,'+');
i2=strfind(labels,'Baseload');

vnames=extractBetween(labels,'+','_Baseload');
