clear all; close all;

all_sites

sdata = [];

for ii = 1:length(sites)
    
    disp(lower(sites{ii}));
    
    site_txt = 'https://apps.waterconnect.sa.gov.au/SiteInfo/Data/Site_Data/';
    
    address = [site_txt,lower(sites{ii}),'/w01.htm'];
    
    
    
    
    tt = urlwrite(address,'test.txt');
    
    fid = fopen('test.txt','rt');
    
    for i = 1:15
        line = fgetl(fid);
    end
    line = fgetl(fid);
    sdata.(sites{ii}).disc = line(27:end);
    
    for i = 1:3
        line = fgetl(fid);
    end
    line = fgetl(fid);
    line_spt = strsplit(line,' ');
    sdata.(sites{ii}).X = str2num(line_spt{6});
    sdata.(sites{ii}).Y = str2num(line_spt{8});
    
    fclose(fid);
    
end

save sdata.mat sdata -mat;