function output=findcell(cellarray,element)



cond=0;
output=zeros(length(cellarray),1);
for i=1:length(cellarray) 
    if findstr(cellarray{i},element);
        output(i)=1;
        
    end
end
        