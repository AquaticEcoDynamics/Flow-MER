clear all;close all;

[snum,sstr]= xlsread('ACTUAL Hourly_barrage releases_01072013_17032017.xlsx','DailyData_01072013-31122014','A2:G1374');

mdate = floor(datenum(sstr(:,1),'dd/mm/yyyy'));

barrage.Goolwa.Data = snum(:,1);
barrage.Goolwa.Date = mdate;

barrage.Mundoo.Data = snum(:,2);
barrage.Mundoo.Date = mdate;

barrage.Boundary.Data = snum(:,3);
barrage.Boundary.Date = mdate;

barrage.Ewe.Data = snum(:,4);
barrage.Ewe.Date = mdate;

barrage.Tauwitchere.Data = snum(:,5);
barrage.Tauwitchere.Date = mdate;

barrage.Total.Data = snum(:,6);
barrage.Total.Date = mdate;

figure('position',[643.666666666667          697.666666666667                      1688                       420]);
plot(barrage.Tauwitchere.Date,barrage.Tauwitchere.Data,'r');hold on

[snum,sstr]= xlsread('DailyBarrageFlows_2019.csv','DailyBarrageFlows_2019','A2:H1374');
mdate = floor(datenum(sstr(:,1),'dd/mm/yyyy'));

barrage.Goolwa.Data = [barrage.Goolwa.Data;snum(:,2)];
barrage.Goolwa.Date = [barrage.Goolwa.Date;mdate];

barrage.Mundoo.Data = [barrage.Mundoo.Data;snum(:,3)];
barrage.Mundoo.Date = [barrage.Mundoo.Date;mdate];

barrage.Boundary.Data = [barrage.Boundary.Data;snum(:,4)];
barrage.Boundary.Date = [barrage.Boundary.Date;mdate];

barrage.Ewe.Data = [barrage.Ewe.Data;snum(:,5)];
barrage.Ewe.Date = [barrage.Ewe.Date;mdate];

barrage.Tauwitchere.Data = [barrage.Tauwitchere.Data;snum(:,6)];
barrage.Tauwitchere.Date = [barrage.Tauwitchere.Date;mdate];

barrage.Total.Data = [barrage.Total.Data;snum(:,7)];
barrage.Total.Date = [barrage.Total.Date;mdate];


% Cross Check
[snum1,sstr1] = xlsread('DailyBarrageReleases_Calculator_Jan16-Jun17.xlsx','A2:G10000');
mdate1 = datenum(sstr1,'dd/mm/yyyy');
tau  = snum1(:,5);


plot(mdate,snum(:,6),'b');hold on
plot(mdate1,tau,'--g');

xlim([datenum(2016,10,01) datenum(2017,07,01)]);

xarray = datenum(2016,10:01:18,01);

set(gca,'xtick',xarray,'xticklabel',datestr(xarray,'mm-yyyy'));

legend({'2013 - 2017';'2016 - 2019';'2016 - 2017'});

grid on

title('Tauwitchere Daily Barrage Flow');

ylabel('Tauwitchere Daily Flow');

saveas(gca,'Tauwitchere Comparison.png');

