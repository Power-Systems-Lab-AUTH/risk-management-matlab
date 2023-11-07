function e1 = filter_errors(e,threshold)

e1=e;
T=size(e,1);



[i j]=find(abs(e1)>threshold);

while ~isempty(i)

    i1=i+1;
    p=i1>T;

    i1(p)=i(p)-1;

    p=i1<1;
    i1(p)=i(p)+1;

    e1(i,:)=e1(i1,:);
    [i j]=find(abs(e1)>threshold);

end



