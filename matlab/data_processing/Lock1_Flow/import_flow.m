clear all; close all;

filename = 'LTIM-2015-2019-LMR_v2.xlsx';

sheetname = 'Flow';

[~,sstr] = xlsread(filename,sheetname,'A4:A10000');
[snum,~] = xlsread(filename,sheetname,'R4:T10000');

mdate = datenum(sstr(:,1),'dd/mm/yyyy');

obs = snum(:,1)  * 1000 / 86400;
noCEW = snum(:,2) * 1000 / 86400;
noAll = snum(:,3) * 1000 / 86400;

X = 372816.2;
Y = 6197980.5;

depth(1:length(obs),1) = 0;

flow.Lock1.Flow.Date = mdate;
flow.Lock1.Flow.Data = obs;
flow.Lock1.Flow.Depth = depth;
flow.Lock1.Flow.X = X;
flow.Lock1.Flow.Y = Y;

flow.Lock1.Flow_noCEW.Date = mdate;
flow.Lock1.Flow_noCEW.Data = noCEW;
flow.Lock1.Flow_noCEW.Depth = depth;
flow.Lock1.Flow_noCEW.X = X;
flow.Lock1.Flow_noCEW.Y = Y;

flow.Lock1.Flow_noAll.Date = mdate;
flow.Lock1.Flow_noAll.Data = noAll;
flow.Lock1.Flow_noAll.Depth = depth;
flow.Lock1.Flow_noAll.X = X;
flow.Lock1.Flow_noAll.Y = Y;


plot(flow.Lock1.Flow.Date,flow.Lock1.Flow.Data,'b');hold on
plot(flow.Lock1.Flow_noCEW.Date,flow.Lock1.Flow_noCEW.Data,'r');hold on
plot(flow.Lock1.Flow_noAll.Date,flow.Lock1.Flow_noAll.Data,'g');hold on

%save flow.mat flow -mat;

%save ../Matlab' v2'/Matfiles/flow.mat flow -mat;


filename = 'LTIM-2015-2019-LMR_v2.xlsx';

sheetname = 'Flow';

[~,sstr] = xlsread(filename,sheetname,'A4:A10000');
[snum,~] = xlsread(filename,sheetname,'U4:W10000');

mdate = datenum(sstr(:,1),'dd/mm/yyyy');

obs = snum(:,1)  * 1000 / 86400;
noCEW = snum(:,2) * 1000 / 86400;
noAll = snum(:,3) * 1000 / 86400;

X = 372816.2;
Y = 6197980.5;

depth(1:length(obs),1) = 0;

flow.Wellington.Flow.Date = mdate;
flow.Wellington.Flow.Data = obs;
flow.Wellington.Flow.Depth = depth;
flow.Wellington.Flow.X = X;
flow.Wellington.Flow.Y = Y;

flow.Wellington.Flow_noCEW.Date = mdate;
flow.Wellington.Flow_noCEW.Data = noCEW;
flow.Wellington.Flow_noCEW.Depth = depth;
flow.Wellington.Flow_noCEW.X = X;
flow.Wellington.Flow_noCEW.Y = Y;

flow.Wellington.Flow_noAll.Date = mdate;
flow.Wellington.Flow_noAll.Data = noAll;
flow.Wellington.Flow_noAll.Depth = depth;
flow.Wellington.Flow_noAll.X = X;
flow.Wellington.Flow_noAll.Y = Y;

save flow_2019.mat flow -mat;


