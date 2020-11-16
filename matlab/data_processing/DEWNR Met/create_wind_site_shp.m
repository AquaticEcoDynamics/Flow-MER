clear all; close all;

load dwlbc.mat;

sites = {'A4260603',...
  'A4261110',...
  'A4261123',...
  'A4261124'};


for i = 1:length(sites)
    S(i).X = dwlbc.(sites{i}).Wind.X;
    S(i).Y = dwlbc.(sites{i}).Wind.Y;
    S(i).Name = sites{i};
    S(i).Geometry = 'Point';
end

shapewrite(S,'DWLBC_Wind.shp');