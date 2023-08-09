function vnames = get_future_vertix_label_gas(labels)

i1=strfind(labels,'+');
i2=strfind(labels,'NaturalGasPrices');

for i=1:length(labels)
    str=extractBetween(labels{i},'+','_NaturalGasPrices');
    if ~isempty(str)
    vnames{i}=str{1};
    end
end
