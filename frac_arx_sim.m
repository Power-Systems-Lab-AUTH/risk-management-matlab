function y_sim = frac_arx_sim(Chat,Ahat,Bhat,theta_hat,y,d_sim,e_sim)

[sim_hor numscenarios]=size(e_sim);

nlags=length(Ahat);
% d_sim=d_sim';

% e_sim=e_sim';
% y=y';

sim_period=1:sim_hor;

numobs=length(y);
y_sim=[zeros(1,numscenarios);repmat(fracdiff(diff(y),theta_hat-1), [1 numscenarios]); nan(sim_hor, numscenarios)];
d_sim1=[zeros(1,cols(d_sim)); fracdiff(diff(d_sim),theta_hat-1)];
% d_sim1=[fracdiff(d_sim(1:end,:),theta_hat-1)];
for b=1:numscenarios
    for i=sim_period
        y1=0;
        for j=1:nlags
            y2=y_sim(numobs+i-j,b);
            if ~isnan(y2) & ~isnan(Ahat(j)) 
                y1=y1+Ahat(j)*y2;
            end
        end

        if ~isempty(Bhat)
        y_sim(numobs+i,b)=Chat+y1+Bhat*d_sim1(numobs+i,:)'+e_sim(i,b);
        else
            y_sim(numobs+i,b)=Chat+y1+e_sim(i,b);
        end

    end
    % y_sim(:,b)=fracdiff(y_sim(:,b),1-theta_hat);
end
% y_sim=permute(y_sim,[2 1 3]);

% subfolder = 'Simulation_Workspaces';
% file_name = strcat('Varpx_Sim.mat');
% file = fullfile(subfolder, file_name);
% save(file);
