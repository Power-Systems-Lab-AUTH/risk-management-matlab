function h = garch_simulate(data,arch,garch,constantp,archp,garchp)


m  =  max(arch,garch);


stdEstimate =  std(data,1);  
data        =  [stdEstimate(ones(m,1)) ; data];  

T=rows(data);

h=zeros(T,1);


h(1:m)=data(1)^2;

parameters=[constantp,archp,garchp];
for t = (m + 1):T
    h(t) = parameters * [1 ; data(t-(1:arch)).^2;  h(t-(1:garch))];
end

h=h(m+1:end);
