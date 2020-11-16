clear all; close all;

addpath(genpath('Functions'));

sim_name = 'DEWNR_Wx_Wy_2010_2020.mp4';

hvid = VideoWriter(sim_name,'MPEG-4');
set(hvid,'Quality',100);
set(hvid,'FrameRate',6);
framepar.resolution = [1024,768];

open(hvid);

load dwlbc.mat;

sites = {'A4260603',...
    'A4261110',...
    'A4261123',...
    'A4261124',...
    'A4261165'};

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

[XX,YY] = meshgrid(X,Y);

shp = shaperead('GIS/Boundary.shp');



for i = 1:size(U,3)
    
    WS = sqrt(power(U(:,:,i),2) + power(V(:,:,i),2));
    
    if i == 1
        fig = figure('position',[1931          32         786         964]);
        
        pc = pcolor(XX',YY',WS);shading flat;hold on
        
        mapshow(shp,'facecolor','none');
        caxis([0 15]);
        
        tx = text(0.05,0.05,datestr(mtime(i),'dd-mmm-yyyy'),'fontsize',10,'fontweight','bold','units','normalized');
        tx1 = text(0.75,0.05,'Wind Speed (m/s)','fontsize',10,'fontweight','bold','units','normalized');
        
        tx2 = text(XXX,YYY,Names,'fontsize',6,'fontweight','bold');
        
        axis off; axis equal;
        
        cb = colorbar('southoutside','position',[0.1299 0.075 0.7752 0.01]);
        
        set(gca,'xlim',[292426.301169785          387055.404363106]);
        set(gca,'ylim',[5981942.35346973          6103683.30693101]);
        
    else
        set(pc,'CData',WS);
        set(tx,'string',datestr(mtime(i),'dd-mmm-yyyy'));
        caxis([0 15]);
    end
    writeVideo(hvid,getframe(fig));
    
    
end

close(hvid);
