function [d pos] = find_length_inactive_period(data)

y=isnan(data);



numobs=rows(data);


i2=0;
index=0;
while i2<numobs
    i1=i2+find(isnan(data(i2+1:end)),1,'first');

    if ~isempty(i1)
        i2=i1+find(~isnan(data(i1+1:end)),1,'first')-1;

        if isempty(i2)

            i2=numobs;

        end
        index=index+1;
        pos(index,:)=[i1 i2];
        d(index)=i2-i1+1;

    end

end
