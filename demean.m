function [x m] = demean(x)

m=nanmean(x);
x=x-m;