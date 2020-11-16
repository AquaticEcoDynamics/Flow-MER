clear all; close all;

addpath(genpath('Functions'));

sim_name = 'DEWNR_Wind_Nearest_Interp_compass.mp4';

hvid = VideoWriter(sim_name,'MPEG-4');
set(hvid,'Quality',100);
set(hvid,'FrameRate',6);
framepar.resolution = [1024,768];

open(hvid);

load dwlbc.mat;

sites = {'A4261123'};

for i = 1:length(sites)
    if isfield(dwlbc.(sites{i}),'SAL')
        XXX(i) = dwlbc.(sites{i}).SAL.X;
        YYY(i) = dwlbc.(sites{i}).SAL.Y;
        Names(i) = sites(i);
    else
        XXX(i) = dwlbc.(sites{i}).Wind.X;
        YYY(i) = dwlbc.(sites{i}).Wind.Y;
        Names(i) = sites(i);
    end
end




data = tfv_readnetcdf('DEWNR_Wx_Wy_2010_2020.nc');

% Time is hours since 01/01/1990

mtime = datenum(1990,01,01,00,00,00) + (data.time/24);

U = data.u;
V = data.v;

X = data.lon;
Y = data.lat;

inc = 1;
for i = 1:length(X)
    for j = 1:length(Y)
        XX(inc,1) = X(i);
        YY(inc,1) = Y(j);
        inc = inc + 1;
    end
end


pnt(1,1) = XXX;
pnt(1,2) = YYY;

geo_x = double(XX);
geo_y = double(YY);
dtri = DelaunayTri(geo_x,geo_y);


pt_id = nearestNeighbor(dtri,pnt);

[Xg,Yg] = meshgrid(X,Y);


[ii,jj] = find(Xg == XX(pt_id) & Yg == YY(pt_id));

    UU = squeeze(U(ii,jj,:));
    VV = squeeze(V(ii,jj,:));

WS = sqrt(power(UU,2) + power(VV,2));
WD = (180 / pi) * atan2(-1*UU,-1*VV);

WindRose(WD,WS)








