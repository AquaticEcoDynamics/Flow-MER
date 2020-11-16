clear all; close all;

load Matfiles\lowerlakes.mat;

sdate = datenum(2011,06,01);

Alex.Date = lowerlakes.A4260575.H.Date;
Alex.Data = lowerlakes.A4260575.H.Data;

[~,ind] = min(abs(Alex.Date - sdate));

Alex.Data(ind)


AlexS.Date = lowerlakes.A4260575.SAL.Date;
AlexS.Data = lowerlakes.A4260575.SAL.Data;

[~,ind] = min(abs(AlexS.Date - sdate));

AlexS.Data(ind)

AlexT.Date = lowerlakes.A4260575.TEMP.Date;
AlexT.Data = lowerlakes.A4260575.TEMP.Data;

[~,ind] = min(abs(AlexT.Date - sdate));

AlexT.Data(ind)

%____________________________________________________
Albert.Date = lowerlakes.A4260630.H.Date;
Albert.Data = lowerlakes.A4260630.H.Data;

[~,ind] = min(abs(Albert.Date - sdate));

Albert.Data(ind)

AlbertS.Date = lowerlakes.A4260630.SAL.Date;
AlbertS.Data = lowerlakes.A4260630.SAL.Data;

[~,ind] = min(abs(AlbertS.Date - sdate));

AlbertS.Data(ind)

AlbertT.Date = lowerlakes.A4260630.TEMP.Date;
AlbertT.Data = lowerlakes.A4260630.TEMP.Data;

[~,ind] = min(abs(AlbertT.Date - sdate));

AlbertT.Data(ind)



%____________________________________
Coorong.Date = lowerlakes.A4261043.H.Date;
Coorong.Data = lowerlakes.A4261043.H.Data;

[~,ind] = min(abs(Coorong.Date - sdate));

Coorong.Data(ind)

CoorongS.Date = lowerlakes.A4261043.SAL.Date;
CoorongS.Data = lowerlakes.A4261043.SAL.Data;

[~,ind] = min(abs(CoorongS.Date - sdate));

CoorongS.Data(ind)

CoorongT.Date = lowerlakes.A4261043.TEMP.Date;
CoorongT.Data = lowerlakes.A4261043.TEMP.Data;

[~,ind] = min(abs(CoorongT.Date - sdate));

CoorongT.Data(ind)
%______________________________________