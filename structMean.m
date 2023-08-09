function res = structMean(risk_factor_sim)

res = zeros(size(risk_factor_sim(1).time_series));
for i=1:numel(risk_factor_sim)
    res = res + risk_factor_sim(i).time_series;
end
res = res/24;
