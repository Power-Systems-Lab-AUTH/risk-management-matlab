function h1 = garch_step(e0,h0,marginal_params)


% parameters=[constp,archp,garchp];

h1 = [1  e0.^2  h0]*marginal_params;


