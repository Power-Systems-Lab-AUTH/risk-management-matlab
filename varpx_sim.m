function y_sim = varpx_sim(Chat,Ahat,Bhat,y,d_sim,e_sim)

[sim_hor numvars numscenarios]=size(e_sim);

nlags=length(Ahat);
d_sim=d_sim';

e_sim=permute(e_sim,[2 1 3]);
y=y';

sim_period=1:sim_hor;

[numvars,numobs]=size(y);
y_sim=cat(2,repmat(y, [1 1 numscenarios]), nan(numvars,sim_hor, numscenarios));

for b=1:numscenarios
    for i=sim_period
        y1=zeros(numvars,1);
        for j=1:nlags
            y2=y_sim(:,numobs+i-j,b);
            if ~isnan(y2) & ~isnan(Ahat{j}) 
                y1=y1+Ahat{j}*y2;
            end
        end
        y_sim(:,numobs+i,b)=Chat+y1+Bhat*d_sim(:,i)+e_sim(:,i,b);
    end
end
y_sim=permute(y_sim,[2 1 3]);

% subfolder = 'Simulation_Workspaces';
% file_name = strcat('Varpx_Sim.mat');
% file = fullfile(subfolder, file_name);
% save(file);
