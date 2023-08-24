function index=find_files2(A,str)

i=0;
index=[];
L=length(str);
% while cond==0 && i<length(A);


while i<length(A);
    i=i+1;
    %     if strmatch(A(i).name,str)
    for l=1:L
        if findstr(A(i).name,str{l})>0
            index=[index i];
        end
    end
end