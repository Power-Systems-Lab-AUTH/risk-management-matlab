function envelope=calc_envelope(y_scen,sig,x_range)



if nargin>2
    x_range=(x_range(1):0.05:x_range(end))';
else
    x_range=(min(y_scen(:)):0.05:max(y_scen(:)))';
end

for i=1:rows(y_scen)
    i
    %     pd=fitdist(y_scen(i,:)','kernel','kernel','epanechnikov');
    %     pdf_range(:,i) = pdf(pd,x_range);
    %     cdf_range(:,i) = cdf(pd,x_range);

    %     i1=find(cdf_range(:,i)>=sig,1,'first');
    %     i2=find(cdf_range(:,i)>=1-sig,1,'first');
    %     envelope(i,1)=x_range(i1);
    %     envelope(i,2)=x_range(i2);
    q=quantile(y_scen(i,:)',[sig 1-sig])';
    envelope(i,1)=q(1);
    envelope(i,2)=q(2);

end

