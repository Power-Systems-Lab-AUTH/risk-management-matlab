function mat = time_to_maturity(dates,vname)



str={'DA', 'M', 'Q', 'Y'};


i=0;
v=[];
while isempty(v)
    i=i+1;
    v=strfind(vname,str{i});

end

seq=str2num(vname(end-1:end));

w=weekday(dates);
[numobs]=rows(dates);
index_busdate=any(w==repmat(1:6,[numobs 1]),2);


switch v
    case 1

        mat=nan(numobs,1);

        for t=1:numobs-seq
            p=find(cumsum(index_busdate(t+1:end))>=seq,1,'first');

            if ~isempty(p)
                mat(t)=p;
            end
        end
end