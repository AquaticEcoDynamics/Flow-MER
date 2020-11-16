clear all close all;

load flow_2019.mat;

xdata = flow.Lock1.Flow.Date;
ydata = flow.Lock1.Flow.Data * (86400/1000);

NCxdata = flow.Lock1.Flow_noCEW.Date;
NCydata = flow.Lock1.Flow_noCEW.Data * (86400/1000);

NAxdata = flow.Lock1.Flow_noAll.Date;
NAydata = flow.Lock1.Flow_noAll.Data * (86400/1000);

figure

plot(xdata,ydata,'b');hold on
plot(NCxdata,NCydata,'r');hold on
plot(NAxdata,NAydata,'g');hold on

%xlim([datenum(2018,07,01) datenum(2019,07,01)]);
xlim([datenum(2013,07,01) datenum(2019,07,01)]);
%xarray = datenum(2018,07:03:20,01);
xarray = datenum(2013:01:2019,07,01);
set(gca,'xtick',xarray,'xticklabel',datestr(xarray,'mm-yyyy'),'FontName','Arial','FontSize',10);

%ylim([0 125]);

%grid on

legend({'With All Water';'No CEW';'No eWater'},'FontName','Arial','FontSize',10);

xlabel('Date','FontName','Arial','FontSize',12);
ylabel('Flow (ML/day)','FontName','Arial','FontSize',12);