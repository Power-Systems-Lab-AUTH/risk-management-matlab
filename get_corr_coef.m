function c =get_corr_coef(mcorr,pairs)

for i=1:rows(pairs)
    c(:,i)=mcorr(pairs(i,1),pairs(i,2),:);
end