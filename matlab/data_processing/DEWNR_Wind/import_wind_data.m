clear all; close all;

load ../'DEWNR Web'/dwlbc.mat;

sites = {...
    'A4260603',...
    'A4261110',...
    'A4261123',...
    'A4261124',...
    'A4261167',...
    };

for i = 1:length(sites)
    
    filename = [sites{i},'-REPORT.CSV'];
    
    fid = fopen(filename,'rt');
    
    textformat = [repmat('%s ',1,5)];
        % read single line: number of x-values
    datacell = textscan(fid,textformat,'Headerlines',3,'Delimiter',',');
    
    mdate(:,1) = datenum(datacell{1},'HH:MM:SS dd/mm/yyyy');
    wind_speed = str2doubleq(datacell{4});
    wind_dir = str2doubleq(datacell{2});
    
    sss = find(~isnan(wind_speed) == 1);
    
    dwlbc.(sites{i}).Wind.Date = mdate(sss);
    dwlbc.(sites{i}).Wind.Data = wind_speed(sss);

    dwlbc.(sites{i}).Wind_Dir.Date = mdate(sss);
    dwlbc.(sites{i}).Wind_Dir.Data = wind_dir(sss);
    
    clear mdate wind_speed wind_dir;
   
end

save('../DEWNR Web/dwlbc.mat','dwlbc','-mat');
