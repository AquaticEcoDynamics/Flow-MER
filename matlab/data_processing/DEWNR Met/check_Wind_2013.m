clear all; close all;

load dwlbc.mat;

sites = fieldnames(dwlbc);

fid = fopen('Wind Sites.csv','wt');
fprintf(fid,'Site,Title,Start Date,End Date\n');

for i = 1:length(sites)
    
    if isfield(dwlbc.(sites{i}),'Wind')
        fprintf(fid,'%s,%s,%s,%s\n',sites{i},dwlbc.(sites{i}).Wind.Title{1},datestr(min(dwlbc.(sites{i}).Wind.Date),'dd/mm/yyyy'),datestr(max(dwlbc.(sites{i}).Wind.Date),'dd/mm/yyyy'));
        
    end
end

fclose(fid);