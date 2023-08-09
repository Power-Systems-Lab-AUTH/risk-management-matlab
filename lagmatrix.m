function X_new = lagmatrix(X,lags)

[T N]=size(X);
nlags=length(lags);

X_new=nan(T, N*nlags);


for i=1:nlags
    col_index=(i-1)*N+1:i*N;
    X_new(lags(i)+1:end,col_index)=X(1:end-lags(i),:);
end

