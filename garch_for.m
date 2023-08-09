function h = garch_for(data,arch,garch,constp,archp,garchp)


startp  =  max([arch,garch]);

T=rows(data);
h=data;


parameters=[constp,archp,garchp];

for t = (startp + 1):T    
    h1 = parameters * [1 ; data(t-(1:arch)).^2;  h(t-(1:garch))];    
    h1(h1<0)=1e-6;
    h(t)=h1;
end

h=h(startp+1:end);