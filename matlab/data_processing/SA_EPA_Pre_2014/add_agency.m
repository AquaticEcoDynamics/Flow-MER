function data = add_agency(data,agency)

sites = fieldnames(data);
for i = 1:length(sites)
    vars = fieldnames(data.(sites{i}));
    for j = 1:length(vars)
        data.(sites{i}).(vars{j}).Agency = agency;
    end
end
