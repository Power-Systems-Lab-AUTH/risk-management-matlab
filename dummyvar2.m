function D = dummyvar2(x,values)

nobs=length(x);
numvalues=length(values);
D=zeros(nobs,numvalues);

for i=1:numvalues

    index=x==values(i);
    D(index,i)=1;
end