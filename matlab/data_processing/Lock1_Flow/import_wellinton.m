clear all; close all;

filename = 'Wellington Filled.xlsx';

[snum,sstr] = xlsread(filename,'A2:B10000');

well.Well.FLOW.Date = datenum(sstr(:,1),'dd/mm/yyyy');
well.Well.FLOW.Data = snum(:,1) * 1000 / 86400;
well.Well.FLOW.Depth(1:length(snum(:,1)),1) = 0;
well.Well.FLOW.X = 352265.2;
well.Well.FLOW.Y = 6085784.0;

save well.mat well -mat;