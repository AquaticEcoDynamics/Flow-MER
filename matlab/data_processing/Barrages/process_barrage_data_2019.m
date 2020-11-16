[snum,sstr]= xlsread('DailyBarrageFlows_2019.csv','DailyBarrageFlows_2019','A2:H1374');
mdate = floor(datenum(sstr(:,1),'dd/mm/yyyy'));

barrage.Goolwa.Data = snum(:,2);
barrage.Goolwa.Date = mdate;

barrage.Mundoo.Data = snum(:,3);
barrage.Mundoo.Date = mdate;

barrage.Boundary.Data = snum(:,4);
barrage.Boundary.Date = mdate;

barrage.Ewe.Data = snum(:,5);
barrage.Ewe.Date = mdate;

barrage.Tauwitchere.Data = snum(:,6);
barrage.Tauwitchere.Date = mdate;

barrage.Total.Data = snum(:,7);
barrage.Total.Date = mdate;



mdate = barrage.Total.Date;
flow = barrage.Total.Data;

dvec = datevec(mdate);

u_years = unique(dvec(:,1));

fid = fopen('Monthly_Barrage_total_2019.csv','wt');
fprintf(fid,'Date,Total\n');

for i = 1:length(u_years)
    for j = 1:12
        
        fprintf(fid,'%s,',datestr(datenum(u_years(i),j,01)));
        
        sss = find(dvec(:,1) == u_years(i) & ...
            dvec(:,2) == j);
        
        if ~isempty(sss)
            total = sum(flow(sss));
            fprintf(fid,'%10.4f',total);
        end
        
        fprintf(fid,'\n');
    end
end