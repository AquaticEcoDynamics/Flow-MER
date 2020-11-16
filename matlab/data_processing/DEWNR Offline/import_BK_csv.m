clear all; close all;
addpath(genpath('Functions'));


filename = '2019-2020\A4261039-data.csv';

fid = fopen(filename,'rt');

textformat = [repmat('%s ',1,7)];

datacell = textscan(fid,textformat,'Headerlines',3,'Delimiter',',');

sdate = datacell{1};

for i = 1:length(sdate)
mDate(i,1) = datenum(sdate{i},'dd/mm/yyyy HH:MM');
end
Level(:,1) = str2double(datacell{2});
Temp(:,1) = str2double(datacell{4});
Cond(:,1) = str2double(datacell{6});

Sal(:,1) = conductivity2salinity(Cond);


% filename = '2017-2018 data\A4261039-level-ec-temp-data.csv';
% 
% fid = fopen(filename,'rt');
% 
% textformat = [repmat('%s ',1,7)];
% 
% datacell = textscan(fid,textformat,'Headerlines',3,'Delimiter',',');
% 
% 
% mDate_1(:,1) = datenum(datacell{1},'dd/mm/yyyy HH:MM');
% 
% Level_1(:,1) = str2double(datacell{2});
% Temp_1(:,1) = str2double(datacell{6});
% Cond_1(:,1) = str2double(datacell{4});
% 
% Sal_1(:,1) = conductivity2salinity(Cond_1);
% 
% 
% ss = find(mDate_1 > max(mDate));
% 
% mDate = [mDate;mDate_1(ss)];
% Level = [Level;Level_1(ss)];
% Temp = [Temp;Temp_1(ss)];
% Cond = [Cond;Cond_1(ss)];
% Sal = [Sal;Sal_1(ss)];







figure


subplot(3,1,1)

plot(mDate,Level);
ylabel('Level (mAHD)');
datetick('x','dd-mm-yy');

subplot(3,1,2)

plot(mDate,Sal);
ylabel('Salinity (psu)');
datetick('x','dd-mm-yy');

subplot(3,1,3)

plot(mDate,Temp);
ylabel('Temperature (C)');
datetick('x','dd-mm-yy');

save BK_2020.mat mDate Temp Sal Level -mat;

%load A4261039.mat;
load BK_All.mat;
%sss = find(data.mDate < min(mDate));

% Tide(:,1) = data.Tide(sss);
% nDate(:,1) = data.mDate(sss);

Tide = [Tide;Level];
nDate = [nDate;mDate];

[nDate,ind] = unique(nDate);
Tide = Tide(ind);
save BK_All.mat nDate Tide -mat;
