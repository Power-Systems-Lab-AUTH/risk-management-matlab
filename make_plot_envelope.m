function envelope=make_plot_envelope(dates,y,dates_for,y_scen,sig,x_range)



if nargin>5
    x_range=(x_range(1):0.5:x_range(end))';
else
    x_range=(min(y):0.5:max(y))';
end

for i=1:cols(y_scen)
    pd=fitdist(y_scen(:,i),'kernel','kernel','epanechnikov');
    pdf_range(:,i) = pdf(pd,x_range);
    cdf_range(:,i) = cdf(pd,x_range);
    envelope(i,1)=find(cdf_range>=sig,1,'first');
    envelope(i,2)=find(cdf_range>=1-sig,1,'first');
end

