function all_pump = extend_pump(pump,alldate)

sites = fieldnames(pump);

[yyyy,mmmm] = datevec(alldate);

for i = 1:length(sites)
    [yy1,mm1] = datevec(pump.(sites{i}).FLOW.Date);
    all_pump.(sites{i}) = pump.(sites{i});
    all_pump.(sites{i}).FLOW.Date = [];
    all_pump.(sites{i}).FLOW.Data = [];
    for j = 1:length(yyyy)
        ss = find(mm1 == mmmm(j));
        
        monthly_rate = mean(pump.(sites{i}).FLOW.Data(ss));
        
        all_pump.(sites{i}).FLOW.Date(j,1) = datenum(yyyy(j),mmmm(j),01);
        all_pump.(sites{i}).FLOW.Data(j,1) = monthly_rate;
    end
    
    [all_pump.(sites{i}).FLOW.Date,ind] = unique(all_pump.(sites{i}).FLOW.Date);
    all_pump.(sites{i}).FLOW.Data = all_pump.(sites{i}).FLOW.Data(ind);
    
end


        
        
        
