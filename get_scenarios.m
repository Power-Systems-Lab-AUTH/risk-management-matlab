function risk_factor_sim = get_scenarios

% load setup

A=dir;
index=find_files2(A,{'exper_'});

A=A(index);
s=load(A(1).name,'risk_factor_sim');
risk_factor_sim(1)=s.risk_factor_sim;

risk_factor_sim=repmat(risk_factor_sim,[1 length(A)]);


parfor i=2:length(A)
    s=load(A(i).name,'risk_factor_sim');
    risk_factor_sim(i)=s.risk_factor_sim;

end

