clear all; close all;

pump = [];

filename = 'ExtractionRiverMurray_2015-2016.xlsx';

snum = xlsread(filename,'I5:N16');

datearray = datenum(2015,07:01:18,01);


pump.MAPL.FLOW.Date(:,1) = datearray;
pump.MAPL.FLOW.Data(:,1) = calc_monthly_offtake(snum(:,1),datearray).* -1;
pump.MAPL.FLOW.X = 345925.70;
pump.MAPL.FLOW.Y = 6135137.64;

pump.MBO.FLOW.Date(:,1) = datearray;
pump.MBO.FLOW.Data(:,1) = calc_monthly_offtake(snum(:,2),datearray).* -1;
pump.MBO.FLOW.X = 343220.92;
pump.MBO.FLOW.Y = 6112719.63;

pump.SRS.FLOW.Date(:,1) = datearray;
pump.SRS.FLOW.Data(:,1) = calc_monthly_offtake(snum(:,3),datearray).* -1;
pump.SRS.FLOW.X = 371170.12;
pump.SRS.FLOW.Y = 6174209.94;

pump.TB.FLOW.Date(:,1) = datearray;
pump.TB.FLOW.Data(:,1) = calc_monthly_offtake(snum(:,4),datearray).* -1;
pump.TB.FLOW.X = 359254.30;
pump.TB.FLOW.Y = 6097452.90;

pump.SR.FLOW.Date(:,1) = datearray;
pump.SR.FLOW.Data(:,1) = calc_monthly_offtake(snum(:,6),datearray) .* -1;
pump.SR.FLOW.X = 350782.77;
pump.SR.FLOW.Y = 6120567.39;

all_datearray = datenum(2008,01:01:126,01);


pump = extend_pump(pump,all_datearray);


[snum,sstr] = xlsread('2018.19.SAW_BelowLock1_QAd.csv','A2:F20000');

mDate = datenum(sstr,'dd/mm/yyyy');

conv = (1000 /86400) * -1;

pump.MAPL.FLOW.Date = [pump.MAPL.FLOW.Date;mDate];
pump.MAPL.FLOW.Data = [pump.MAPL.FLOW.Data;(snum(:,1) * conv)];


pump.MBO.FLOW.Date = [pump.MBO.FLOW.Date;mDate];
pump.MBO.FLOW.Data = [pump.MBO.FLOW.Data;(snum(:,2) * conv)];


pump.SRS.FLOW.Date = [pump.SRS.FLOW.Date;mDate];
pump.SRS.FLOW.Data = [pump.SRS.FLOW.Data;(snum(:,3) * conv)];


pump.TB.FLOW.Date = [pump.TB.FLOW.Date;mDate];
pump.TB.FLOW.Data = [pump.TB.FLOW.Data;(snum(:,5) * conv)];


pump.SR.FLOW.Date = [pump.SR.FLOW.Date;mDate];
pump.SR.FLOW.Data = [pump.SR.FLOW.Data;(snum(:,4) * conv)];

all_datearray = datenum(2019,10:01:19,01);


pump_extra = extend_pump(pump,all_datearray);



sites = fieldnames(pump);

for i = 1:length(sites)
    
    pump.(sites{i}).FLOW.Date = [pump.(sites{i}).FLOW.Date;pump_extra.(sites{i}).FLOW.Date];
    pump.(sites{i}).FLOW.Data = [pump.(sites{i}).FLOW.Data;pump_extra.(sites{i}).FLOW.Data];
    
    
    figure;plot(pump.(sites{i}).FLOW.Date,pump.(sites{i}).FLOW.Data);
    title(sites{i});
end




save pump.mat pump -mat;
%save ../Matlab' v2'/Matfiles/pump.mat pump -mat;