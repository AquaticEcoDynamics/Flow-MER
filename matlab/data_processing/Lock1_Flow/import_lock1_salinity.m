clear all; close all;

addpath(genpath('../DEWNR Offline/Functions'));

[snum,sstr] = xlsread('CEWO 201617 Salinity by Source Summary.xlsx','Lock 1','C5:E10000');

mdate = datenum(sstr,'dd/mm/yyyy');

Flow  =snum(:,1) * (1000 /86400);
Sal = conductivity2salinity(snum(:,2));

load('../DEWNR Web/dwlbc.mat');

site = 'A4260903';

ss = find(dwlbc.(site).Flow_m3.Date > mdate(1));

tt = find(dwlbc.(site).Flow_m3_Calc.Date > mdate(1));


% flowt = [dwlbc.(site).Flow_m3.Data(ss);Flow];
% datet = [dwlbc.(site).Flow_m3.Date(ss);mdate];
% 
% dwlbc.(site).Flow_m3.Date = datet;
% dwlbc.(site).Flow_m3.Data = flowt;
% dwlbc.(site).Flow_m3.Depth(1:length(flowt),1) = 0;
% 
% flowt = [dwlbc.(site).Flow_m3_Calc.Data(tt);Flow];
% datet = [dwlbc.(site).Flow_m3_Calc.Date(tt);mdate];
% 
% dwlbc.(site).Flow_m3_Calc.Date = datet;
% dwlbc.(site).Flow_m3_Calc.Data = flowt;
% dwlbc.(site).Flow_m3_Calc.Depth(1:length(flowt),1) = 0;

dwlbc.(site).SAL = dwlbc.(site).Flow_m3_Calc;
dwlbc.(site).SAL.Date = mdate;
dwlbc.(site).SAL.Data = Sal;
dwlbc.(site).SAL.Depth(1:length(mdate),1) = 0;

save('../DEWNR Web/dwlbc.mat','dwlbc','-mat');