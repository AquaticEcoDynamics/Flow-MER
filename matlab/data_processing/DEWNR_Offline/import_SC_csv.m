clear all; close all;
addpath(genpath('Functions'));


load('../DEWNR Web/dwlbc.mat');

filename = '2019-2020\A2390568-data.csv';

fid = fopen(filename,'rt');

textformat = [repmat('%s ',1,9)];

datacell = textscan(fid,textformat,'Headerlines',3,'Delimiter',',');


mDate(:,1) = datenum(datacell{1},'dd/mm/yyyy HH:MM');

Flow(:,1) = str2double(datacell{4}) * (1000 /86400);
Cond(:,1) = str2double(datacell{8});
Temp(:,1) = str2double(datacell{6});

Sal(:,1) = conductivity2salinity(Cond);

figure


subplot(3,1,1)

plot(mDate,Flow);
ylabel('Flow (m3/s)');
datetick('x','dd-mm-yy');

subplot(3,1,2)

plot(mDate,Sal);
ylabel('Salinity (psu)');
datetick('x','dd-mm-yy');

subplot(3,1,3)

plot(mDate,Temp);
ylabel('Temperature (C)');
datetick('x','dd-mm-yy');

save SC_2017.mat mDate Sal Flow Temp -mat;


% 
sss = find(dwlbc.A2390568.Flow_m3.Date < min(mDate));

Flow_o(:,1) = dwlbc.A2390568.Flow_m3.Data(sss);
Date_o(:,1) = dwlbc.A2390568.Flow_m3.Date(sss);

Flow_o = [Flow_o;Flow];
Date_o = [Date_o;mDate];


sss = find(dwlbc.A2390568.SAL.Date < min(mDate));
Sal_o(:,1) = dwlbc.A2390568.SAL.Data(sss);
Date_2(:,1) = dwlbc.A2390568.SAL.Date(sss);

Sal_o = [Sal_o;Sal];
Date_2 = [Date_2;mDate];

dwlbc.A2390568.SAL.Data = Sal_o;
dwlbc.A2390568.SAL.Date = Date_2;

dwlbc.A2390568.FLOW = dwlbc.A2390568.Flow_m3;
dwlbc.A2390568.FLOW.Data = [];
dwlbc.A2390568.FLOW.Date = [];

dwlbc.A2390568.FLOW.Data = Flow_o;
dwlbc.A2390568.FLOW.Date = Date_o;

plot(dwlbc.A2390568.FLOW.Date,dwlbc.A2390568.FLOW.Data);datetick('x')

%save BK_All.mat nDate Tide -mat;

save ('../DEWNR Web/dwlbc.mat','dwlbc','-mat');
