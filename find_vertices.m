function index = find_vertices(vnames,str)


vnames1=[];
if isstring(vnames)
    for i=1:length(vnames)

        vnames1{i}=vnames{i};
    end
    vnames=vnames1;
end

for i=1:length(str)
    index(:,i)=cellfun(@(x) any(x),strfind(vnames,str{i}));
end