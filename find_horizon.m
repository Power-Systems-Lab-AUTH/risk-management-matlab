function hor = find_horizon(vnames)

hor=cellfun(@(x) str2double(x(end-1:end)),vnames);