function mat = find_maturity(vnames)


mat=cellfun(@(x) str2double(x(end-1:end)),vnames);
