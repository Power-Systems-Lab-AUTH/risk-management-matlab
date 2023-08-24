function boxplot2(varargin)

varargin=[varargin 'whisker'];
varargin=[varargin 0];

% varargin=[varargin 'notch' 'on'];
boxplot(varargin{:});
delete(findobj('Tag' ,'Outliers'));
delete(findobj('Tag' ,'Whisker'));
% findobj('medianstyle','target')




xdata=get(findobj('Tag' ,'Median'),'Xdata');
ydata=get(findobj('Tag' ,'Median'),'Ydata');

L=length(xdata);
X=zeros(L,1);
Y=X;
for i=1:L
    X(i)=mean(xdata{i});
    Y(i)=ydata{i}(1);
end

v=axis;
axis tight;
v=axis;

v1=v;
for j=[1 3]
    v1(j)=v1(j)-0.05*mean(v([j j+1]));
    v1(j+1)=v1(j+1)+0.05*mean(v([j j+1]));
end

axis(v1)
hold on
plot(X,Y,'r.-')
hold off