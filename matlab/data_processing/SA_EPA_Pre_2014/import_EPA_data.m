clear all; close all;

addpath(genpath('Functions'));

if ~exist('Matfiles/rawEPA.mat','file')
    
    datadir = 'Raw/';
    
    dirlist = dir(datadir);
    
    for i = 3:9%length(dirlist)
        
        fid = fopen([datadir,dirlist(i).name],'rt');
        
        
        headers = strsplit(fgetl(fid),',');
        
        headers = regexprep(headers,'"','');
        
        sYear = ['s',regexprep(dirlist(i).name,'.csv','')];
        disp(sYear);
        
        
        
        inc = 1;
        while ~feof(fid)
            line = fgetl(fid);
            % Damn line formatting....
            line = regexprep(line,'DS,','DS ');
            line = regexprep(line,'BH,','BH ');
            line = regexprep(line,'1% HNO3,','1% HNO3 ');
            line = regexprep(line,'sample,','sample ');
            line = regexprep(line,'filter,','filter ');
            line = regexprep(line,'Yule Street,','Yule Street ');
            line = regexprep(line,'(0,45 um)','(0 45 um)');
            line = regexprep(line,'Bailed Dry,','Bailed Dry');
            line = regexprep(line,'turbid,','turbid');
            line = regexprep(line,'pelican,','pelican');
            line = regexprep(line,'present,','present');
            line = regexprep(line,'that,','that');
            
            sptLine = strsplit(line,',');
            
            if length(sptLine) == length(headers)
                for j = 1:length(headers)
                    rawEPA.(sYear).(headers{j}){inc} = regexprep(sptLine{j},'"','');
                end
                inc = inc + 1;
            else
                disp(line);
                disp(sptLine);
                stop;
            end
        end
        
        %end
        %
        
    end
    
    disp('Finished');
    
    save Matfiles\rawEPA.mat rawEPA -mat;
    
else
    load Matfiles\rawEPA.mat;
end


years = fieldnames(rawEPA);

sites = [];
vars = [];
units = [];
sdates = [];
sval = [];


for i = 1:length(years)
    
    sites = [rawEPA.(years{i}).SAMPLE_POINT';sites];
    vars = [rawEPA.(years{i}).TEST';vars];
    units = [rawEPA.(years{i}).RESULT_UNITS';units];
    sdates = [rawEPA.(years{i}).SAMPLE_DATE';sdates];
    sval = [rawEPA.(years{i}).RESULT';sval];
end
sites = regexprep(sites,'Rainwater - Yule Street  Meningie','Rainwater - Yule Street Meningie');

usites = unique(sites);


% [uvars,ind] = unique(vars);
%
% uUnits = units(ind);

% fid1 = fopen('EPA Sites.csv','wt');
% for ii = 1:length(usites)
%     fprintf(fid1,'%s\n',usites{ii});
% end
% fclose(fid1);
% fid1 = fopen('EPA Vars.csv','wt');
% for ii = 1:length(uvars)
%     fprintf(fid1,'%s,%s\n',uvars{ii},uUnits{ii});
% end
% fclose(fid1);

[~,sstr] = xlsread('Conversions/EPA Sites Conversion.xlsx','A2:B1000');

old_sites = sstr(:,1);
ID = sstr(:,2);

[snum,sstr] = xlsread('Conversions/EPA Vars Conversion.xlsx','A2:E1000');

old_var = sstr(:,1);
old_units = sstr(:,2);
newvar = sstr(:,3);
new_units = sstr(:,4);
conv = snum(:,1);

EPA_2015 = [];

for i = 1:length(usites)
    sss = find(strcmpi(sites,usites{i}) == 1);
    
    site_vars = vars(sss);
    site_dates = sdates(sss);
    site_data = sval(sss);
    
    tt = find(strcmpi(old_sites,usites{i}) == 1);
    
    if ~isempty(tt) % It's a valid site
        
        gg = find(strcmpi(site_vars,'Latitude') == 1);
        
        if ~isempty(gg)
            %             lat = str2double(site_data{gg(end)});
            %             gg = find(strcmpi(site_vars,'Longitude') == 1);
            %             lon = str2double(site_data{gg(end)});
            %
            %             if lat > lon
            %                 tw = lon;
            %                 lon = lat;
            %                 lat = tw;
            %             end
            %
            %             [x,y] = ll2utm(lat,lon);
            x = 0;
            y = 0;
        else
            x = 0;
            y = 0;
        end
        
        u_sitevars = unique(site_vars);
        
        site_ID = ID{tt};
        
        
        for j = 1:length(u_sitevars)
            
            hh = find(strcmpi(site_vars,u_sitevars{j}) == 1);
            
            var_dates = [];
            var_data = [];
            
            var_dates = datenum(site_dates(hh),'dd/mm/yyyy HH:MM');
            for ll = 1:length(hh)
                temp = str2double(site_data{hh(ll)});
                if isnumeric(temp)
                    var_data(ll,1) = temp;
                else
                    var_data(ll,1) = NaN;
                end
            end
            kk = find(strcmpi(old_var,u_sitevars{j}) == 1);
            
            if find(strcmpi(newvar{kk(1)},'Ignore') == 0)
                
                if isfield(EPA_2015,site_ID)
                    
                    if ~isfield(EPA_2015.(site_ID),newvar{kk(1)})
                        
                        EPA_2015.(site_ID).(newvar{kk(1)}).Date = var_dates;
                        EPA_2015.(site_ID).(newvar{kk(1)}).Data = var_data .* conv(kk(1));
                        EPA_2015.(site_ID).(newvar{kk(1)}).Depth(1:length(var_dates),1) = 0;
                        EPA_2015.(site_ID).(newvar{kk(1)}).X = x;
                        EPA_2015.(site_ID).(newvar{kk(1)}).Y = y;
                        
                    else
                        EPA_2015.(site_ID).(newvar{kk(1)}).Date = [EPA_2015.(site_ID).(newvar{kk(1)}).Date;var_dates];
                        EPA_2015.(site_ID).(newvar{kk(1)}).Data = [EPA_2015.(site_ID).(newvar{kk(1)}).Data;var_data .* conv(kk(1))];
                        
                        [EPA_2015.(site_ID).(newvar{kk(1)}).Date,ind] = sort(EPA_2015.(site_ID).(newvar{kk(1)}).Date);
                        EPA_2015.(site_ID).(newvar{kk(1)}).Data = EPA_2015.(site_ID).(newvar{kk(1)}).Data(ind);
                    end
                else
                    EPA_2015.(site_ID).(newvar{kk(1)}).Date = var_dates;
                    EPA_2015.(site_ID).(newvar{kk(1)}).Data = var_data .* conv(kk(1));
                    EPA_2015.(site_ID).(newvar{kk(1)}).Depth(1:length(var_dates),1) = 0;
                    EPA_2015.(site_ID).(newvar{kk(1)}).X = x;
                    EPA_2015.(site_ID).(newvar{kk(1)}).Y = y;
                end
                
            end
            
        end
        
        
        
    else
        
        stop;
    end
end

save Matfiles\EPA_2015.mat EPA_2015 -mat;




[snum,sstr] = xlsread('Conversions/EPA_GIS_Full_v2.xlsx','A2:C10000');

oldnames = sstr(:,1);
%newnames = sstr(:,2);
XX = snum(:,1);
YY = snum(:,2);

sites = fieldnames(EPA_2015);

epa = [];


for i = 1:length(sites)
    
    ss = find(strcmpi(oldnames,sites{i}) == 1);
    
    vars = fieldnames(EPA_2015.(sites{i}));
    
    nX = XX(ss);
    nY = YY(ss);
    
    if nX > 0
        
        for j = 1:length(vars)
            epa.(sites{i}).(vars{j}) = EPA_2015.(sites{i}).(vars{j});
            
            epa.(sites{i}).(vars{j}).X = nX;
            epa.(sites{i}).(vars{j}).Y = nY;
        end
        
    end
end

epa_2014 = epa;

save epa_2014.mat epa_2014 -mat 

%
% % Add the 2015 data
%
%
% load Matfiles\EPA_Short.mat;
% 
% epa_short_sites = fieldnames(epa_short);
% 
% for i = 1:length(epa_short_sites)
%     if isfield(epa,epa_short_sites{i})
%         vars_s = fieldnames(epa_short.(epa_short_sites{i}));
%         for j = 1:length(vars_s)
%             if isfield(epa.(epa_short_sites{i}),vars_s{j})
%                 epa.(epa_short_sites{i}).(vars_s{j}).Data = [epa.(epa_short_sites{i}).(vars_s{j}).Data;epa_short.(epa_short_sites{i}).(vars_s{j}).Data];
%                 epa.(epa_short_sites{i}).(vars_s{j}).Date = [epa.(epa_short_sites{i}).(vars_s{j}).Date;epa_short.(epa_short_sites{i}).(vars_s{j}).Date];
%                 epa.(epa_short_sites{i}).(vars_s{j}).Depth = [epa.(epa_short_sites{i}).(vars_s{j}).Depth;epa_short.(epa_short_sites{i}).(vars_s{j}).Depth];
%                 
%             else
%                 epa.(epa_short_sites{i}).(vars_s{j}) = epa_short.(epa_short_sites{i}).(vars_s{j});
%                 
%             end
%         end
%     end
% end
% 
% % % Add the phyto data
% %
% %
% load Matfiles\epa_phyto.mat;
% 
% epa_phyto_sites = fieldnames(epa_phyto);
% 
% for i = 1:length(epa_phyto_sites)
%     if isfield(epa,epa_phyto_sites{i})
%         vars_s = fieldnames(epa_phyto.(epa_phyto_sites{i}));
%         for j = 1:length(vars_s)
%             if isfield(epa,epa_phyto_sites{i})
%                 if isfield(epa.(epa_phyto_sites{i}),vars_s{j})
%                     epa.(epa_phyto_sites{i}).(vars_s{j}).Data = [epa.(epa_phyto_sites{i}).(vars_s{j}).Data;epa_phyto.(epa_phyto_sites{i}).(vars_s{j}).Data];
%                     epa.(epa_phyto_sites{i}).(vars_s{j}).Date = [epa.(epa_phyto_sites{i}).(vars_s{j}).Date;epa_phyto.(epa_phyto_sites{i}).(vars_s{j}).Date];
%                     epa.(epa_phyto_sites{i}).(vars_s{j}).Depth = [epa.(epa_phyto_sites{i}).(vars_s{j}).Depth;epa_phyto.(epa_phyto_sites{i}).(vars_s{j}).Depth];
%                     
%                 else
%                     epa.(epa_phyto_sites{i}).(vars_s{j}) = epa_phyto.(epa_phyto_sites{i}).(vars_s{j});
%                     
%                 end
%             else
%                 epa.(epa_phyto_sites{i}) = epa_phyto.(epa_phyto_sites{i});
%             end
%         end
%     end
% end
% 
% 
% 
% 
% 
% 
% 
% %
% %
% %
% %
% sites = fieldnames(epa);
% 
% for i = 1:length(sites)
%     vars = fieldnames(epa.(sites{i}));
%     for j = 1:length(vars)
%         [tdate,ind] = unique(epa.(sites{i}).(vars{j}).Date);
%         tdata = epa.(sites{i}).(vars{j}).Data(ind);
%         epa.(sites{i}).(vars{j}).Date = [];
%         epa.(sites{i}).(vars{j}).Data = [];
%         epa.(sites{i}).(vars{j}).Depth = [];
%         
%         [epa.(sites{i}).(vars{j}).Date,ind] = sort(tdate);
%         epa.(sites{i}).(vars{j}).Data = tdata(ind);
%         epa.(sites{i}).(vars{j}).Depth(1:length(tdate),1) = 0;
%         
%         clear tdate tdata;
%     end
% end
% %
% %
% %
% 
% for i = 1:length(sites)
%     
%     disp('_______________________________________________________________');
%     disp('**                                                           **');
%     %%
%     %DON__________________________________________________________________
%     % DON = (TN - AMM - NIT) * 0.5
%     
%     if isfield(epa.(sites{i}),'WQ_DIAG_TOT_TN') & ...
%             isfield(epa.(sites{i}),'WQ_NIT_AMM') & ...
%             isfield(epa.(sites{i}),'WQ_NIT_NIT')
%         
%         
%         disp([sites{i},': DON']);
%         
%         % First variable
%         [Fdate,ind] = unique(epa.(sites{i}).WQ_DIAG_TOT_TN.Date);
%         Fdata = epa.(sites{i}).WQ_DIAG_TOT_TN.Data(ind);
%         % Second Variable
%         [Sdate,ind] = unique(epa.(sites{i}).WQ_NIT_AMM.Date);
%         Sdata = epa.(sites{i}).WQ_NIT_AMM.Data(ind);
%         % Third Variable
%         [Tdate,ind] = unique(epa.(sites{i}).WQ_NIT_NIT.Date);
%         Tdata = epa.(sites{i}).WQ_NIT_NIT.Data(ind);
%         
%         xdate = [min(Fdate):1:max(Fdate)]';
%         
%         if length(~isnan(Fdata)) > 3 & length(~isnan(Sdata)) > 3 & length(~isnan(Tdata)) > 3
%             
%             FIdata = interp1(Fdate(~isnan(Fdata)),Fdata(~isnan(Fdata)),xdate,'linear',mean(Fdata(~isnan(Fdata))));
%             
%             SIdata = interp1(Sdate(~isnan(Sdata)),Sdata(~isnan(Sdata)),xdate,'linear',mean(Sdata(~isnan(Sdata))));
%             
%             TIdata = interp1(Tdate(~isnan(Tdata)),Tdata(~isnan(Tdata)),xdate,'linear',mean(Tdata(~isnan(Tdata))));
%             
%             temp_val = (FIdata - SIdata - TIdata) .* 0.5;
%             
%             % Set the variable
%             epa.(sites{i}).WQ_OGM_DON = epa.(sites{i}).WQ_DIAG_TOT_TN;
%             
%             clear epa.(sites{i}).WQ_OGM_DON.Data epa.(sites{i}).WQ_OGM_DON.Depth epa.(sites{i}).WQ_OGM_DON.Date
%             
%             for ii = 1:length(Fdate)
%                 ss = find(floor(xdate) == floor(Fdate(ii)));
%                 if ~isempty(ss)
%                     epa.(sites{i}).WQ_OGM_DON.Data(ii,1) = temp_val(ss);
%                     epa.(sites{i}).WQ_OGM_DON.Date(ii,1) = xdate(ss);
%                     epa.(sites{i}).WQ_OGM_DON.Depth(ii,1) = 0;
%                 end
%             end
%             epa.(sites{i}).WQ_OGM_DON.Title = {'DON'};
%         end
%         clear Fdate Fdata Sdate Sdata Tdate Tdata TIdata SIdata FIdata temp_val;
%         % DON______________________________________________________________
%     end
%     %% PON_________________________________________________________________
%     % PON = (TN - AMM - NIT) - DON
%     
%     if isfield(epa.(sites{i}),'WQ_DIAG_TOT_TN') & ...
%             isfield(epa.(sites{i}),'WQ_NIT_AMM') & ...
%             isfield(epa.(sites{i}),'WQ_NIT_NIT') & ...
%             isfield(epa.(sites{i}),'WQ_OGM_DON')
%         
%         
%         disp([sites{i},': PON']);
%         
%         % First variable
%         [Fdate,ind] = unique(epa.(sites{i}).WQ_DIAG_TOT_TN.Date);
%         Fdata = epa.(sites{i}).WQ_DIAG_TOT_TN.Data(ind);
%         % Second Variable
%         [Sdate,ind] = unique(epa.(sites{i}).WQ_NIT_AMM.Date);
%         Sdata = epa.(sites{i}).WQ_NIT_AMM.Data(ind);
%         % Third Variable
%         [Tdate,ind] = unique(epa.(sites{i}).WQ_NIT_NIT.Date);
%         Tdata = epa.(sites{i}).WQ_NIT_NIT.Data(ind);
%         
%         % 4th Variable
%         [FFdate,ind] = unique(epa.(sites{i}).WQ_OGM_DON.Date);
%         FFdata = epa.(sites{i}).WQ_OGM_DON.Data(ind);
%         
%         
%         xdate = [min(Fdate):1:max(Fdate)]';
%         
%         if length(~isnan(Fdata)) > 3 & length(~isnan(Sdata)) > 3 & length(~isnan(Tdata)) > 3 & length(~isnan(FFdata)) > 3
%             
%             
%             FIdata = interp1(Fdate(~isnan(Fdata)),Fdata(~isnan(Fdata)),xdate,'linear',mean(Fdata(~isnan(Fdata))));
%             
%             SIdata = interp1(Sdate(~isnan(Sdata)),Sdata(~isnan(Sdata)),xdate,'linear',mean(Sdata(~isnan(Sdata))));
%             
%             TIdata = interp1(Tdate(~isnan(Tdata)),Tdata(~isnan(Tdata)),xdate,'linear',mean(Tdata(~isnan(Tdata))));
%             
%             FFIdata = interp1(FFdate(~isnan(FFdata)),FFdata(~isnan(FFdata)),xdate,'linear',mean(FFdata(~isnan(FFdata))));
%             
%             
%             temp_val = (FIdata - SIdata - TIdata) - FFIdata;
%             
%             % Set the variable
%             epa.(sites{i}).WQ_OGM_PON = epa.(sites{i}).WQ_DIAG_TOT_TN;
%             
%             clear epa.(sites{i}).WQ_OGM_PON.Data epa.(sites{i}).WQ_OGM_PON.Depth epa.(sites{i}).WQ_OGM_PON.Date
%             
%             for ii = 1:length(Fdate)
%                 ss = find(floor(xdate) == floor(Fdate(ii)));
%                 if ~isempty(ss)
%                     epa.(sites{i}).WQ_OGM_PON.Data(ii,1) = temp_val(ss);
%                     epa.(sites{i}).WQ_OGM_PON.Date(ii,1) = xdate(ss);
%                     epa.(sites{i}).WQ_OGM_PON.Depth(ii,1) = 0;
%                 end
%             end
%             epa.(sites{i}).WQ_OGM_PON.Title = {'PON'};
%             
%         end
%         
%         clear Fdate Fdata Sdate Sdata Tdate Tdata FFdate FFdata FFIdata TIdata SIdata FIdata temp_val;
%         
%         % PON__________________________________________________________________
%     end
%     
%     %% DOP_________________________________________________________________
%     % DOP = (TP-FRP) * 0.5
%     
%     if isfield(epa.(sites{i}),'WQ_PHS_FRP') & ...
%             isfield(epa.(sites{i}),'WQ_DIAG_TOT_TP')
%         
%         
%         disp([sites{i},': DOP']);
%         
%         % First variable
%         [Fdate,ind] = unique(epa.(sites{i}).WQ_DIAG_TOT_TP.Date);
%         Fdata = epa.(sites{i}).WQ_DIAG_TOT_TP.Data(ind);
%         % Second Variable
%         [Sdate,ind] = unique(epa.(sites{i}).WQ_PHS_FRP.Date);
%         Sdata = epa.(sites{i}).WQ_PHS_FRP.Data(ind);
%         
%         
%         xdate = [min(Fdate):1:max(Fdate)]';
%         
%         if length(~isnan(Fdata)) > 3 & length(~isnan(Sdata)) > 3
%             
%             
%             FIdata = interp1(Fdate(~isnan(Fdata)),Fdata(~isnan(Fdata)),xdate,'linear',mean(Fdata(~isnan(Fdata))));
%             
%             SIdata = interp1(Sdate(~isnan(Sdata)),Sdata(~isnan(Sdata)),xdate,'linear',mean(Sdata(~isnan(Sdata))));
%             
%             
%             
%             
%             temp_val = (FIdata - SIdata) .* 0.5;
%             % Set the variable
%             epa.(sites{i}).wq_ogm_dop = epa.(sites{i}).WQ_DIAG_TOT_TP;
%             
%             clear epa.(sites{i}).WQ_PHS_DOP.Data epa.(sites{i}).WQ_PHS_DOP.Depth epa.(sites{i}).WQ_PHS_DOP.Date
%             
%             for ii = 1:length(Fdate)
%                 ss = find(floor(xdate) == floor(Fdate(ii)));
%                 if ~isempty(ss)
%                     epa.(sites{i}).wq_ogm_dop.Data(ii,1) = temp_val(ss);
%                     epa.(sites{i}).wq_ogm_dop.Date(ii,1) = xdate(ss);
%                     epa.(sites{i}).wq_ogm_dop.Depth(ii,1) = 0;
%                 end
%             end
%             epa.(sites{i}).wq_ogm_dop.Title = {'DOP'};
%             
%         end
%         
%         clear Fdate Fdata Sdate Sdata SIdata FIdata temp_val;
%         
%         % DOP__________________________________________________________________
%     end
%     
%     %% POP_________________________________________________________________
%     % POP = (TP-FRP) * 0.5
%     
%     if isfield(epa.(sites{i}),'WQ_PHS_FRP') & ...
%             isfield(epa.(sites{i}),'WQ_DIAG_TOT_TP')
%         
%         
%         disp([sites{i},': POP']);
%         
%         % First variable
%         [Fdate,ind] = unique(epa.(sites{i}).WQ_DIAG_TOT_TP.Date);
%         Fdata = epa.(sites{i}).WQ_DIAG_TOT_TP.Data(ind);
%         % Second Variable
%         [Sdate,ind] = unique(epa.(sites{i}).WQ_PHS_FRP.Date);
%         Sdata = epa.(sites{i}).WQ_PHS_FRP.Data(ind);
%         
%         
%         xdate = [min(Fdate):1:max(Fdate)]';
%         
%         if length(~isnan(Fdata)) > 3 & length(~isnan(Sdata)) > 3
%             
%             
%             FIdata = interp1(Fdate(~isnan(Fdata)),Fdata(~isnan(Fdata)),xdate,'linear',mean(Fdata(~isnan(Fdata))));
%             
%             SIdata = interp1(Sdate(~isnan(Sdata)),Sdata(~isnan(Sdata)),xdate,'linear',mean(Sdata(~isnan(Sdata))));
%             
%             
%             
%             
%             temp_val = (FIdata - SIdata) .* 0.5;
%             % Set the variable
%             epa.(sites{i}).wq_ogm_pop = epa.(sites{i}).WQ_DIAG_TOT_TP;
%             
%             clear epa.(sites{i}).WQ_PHS_POP.Data epa.(sites{i}).WQ_PHS_POP.Depth epa.(sites{i}).WQ_PHS_POP.Date
%             
%             for ii = 1:length(Fdate)
%                 ss = find(floor(xdate) == floor(Fdate(ii)));
%                 if ~isempty(ss)
%                     epa.(sites{i}).wq_ogm_pop.Data(ii,1) = temp_val(ss);
%                     epa.(sites{i}).wq_ogm_pop.Date(ii,1) = xdate(ss);
%                     epa.(sites{i}).wq_ogm_pop.Depth(ii,1) = 0;
%                 end
%             end
%             epa.(sites{i}).wq_ogm_pop.Title = {'POP'};
%             
%         end
%         
%         clear Fdate Fdata Sdate Sdata SIdata FIdata temp_val;
%         
%         % POP__________________________________________________________________
%     end
%     
%     %FRP_ADS_______________________________________________________________
%     if isfield(epa.(sites{i}),'WQ_PHS_FRP')
%         disp([sites{i},': FRP_ADS']);
%         epa.(sites{i}).WQ_PHS_FRPADS = epa.(sites{i}).WQ_PHS_FRP;
%         clear epa.(sites{i}).WQ_PHS_FRPADS.Data
%         epa.(sites{i}).WQ_PHS_FRPADS.Data = epa.(sites{i}).WQ_PHS_FRP.Data .* 0.5;
%         
%     end
%     
%     disp('**                                                           **');
%     disp('_______________________________________________________________');
% end
% 
% % Final check for GIS co-ords...
% 
% sites = fieldnames(epa);
% for i = 1:length(sites)
%     vars = fieldnames(epa.(sites{i}));
%     X = [];
%     Y = [];
%     for j = 1:length(vars)
%         inc = 0;
%         if inc == 0
%             if isfield(epa.(sites{i}).(vars{j}),'X')
%                 
%                 X = epa.(sites{i}).(vars{j}).X;
%                 Y = epa.(sites{i}).(vars{j}).Y;
%                 
%                 inc = 1;
%             end
%         end
%     end
%     
%     if ~isempty(X)
%         for j = 1:length(vars)
%             epa.(sites{i}).(vars{j}).X = X;
%             epa.(sites{i}).(vars{j}).Y = Y;
%         end
%     end
% end
% 
% load Matfiles\epa_v3.mat
% 
% sites = fieldnames(epa_v3);
% 
% 
% for i = 1:length(sites)
%     if isfield(epa,sites{i})
%         vars = fieldnames(epa_v3.(sites{i}));
%         for j = 1:length(vars)
%             if isfield(epa.(sites{i}),vars{j});
%                 
%                 epa_data = epa.(sites{i}).(vars{j}).Data;
%                 epa_date = epa.(sites{i}).(vars{j}).Date;
%                 
%                 tdata = epa_v3.(sites{i}).(vars{j}).Data;
%                 tdate = epa_v3.(sites{i}).(vars{j}).Date;
%                 
%                 for k = 1:length(tdate)
%                     ss = find(epa_date == tdate(k));
%                     if isempty(ss)
%                         epa_date(end+1) = tdate(k);
%                         epa_data(end+1) = tdata(k);
%                     end
%                 end
%                 
%                 [tt_date,ind] = sort(epa_date);
%                 tt_data = epa_data(ind);
%                 epa.(sites{i}).(vars{j}).Data = [];
%                 epa.(sites{i}).(vars{j}).Date = [];
%                 epa.(sites{i}).(vars{j}).Depth = [];
%                 
%                 
%                 epa.(sites{i}).(vars{j}).Data = tt_data;
%                 epa.(sites{i}).(vars{j}).Date = tt_date;
%                 epa.(sites{i}).(vars{j}).Depth(1:length(tt_date),1) = 0;
%                 
%             else
%                 epa.(sites{i}).(vars{j}) = epa_v3.(sites{i}).(vars{j});
%             end
%             
%         end
%     end
% end
% 
% epa = add_agency(epa,'SA EPA');
% 
% 
% save Matfiles\EPA.mat epa -mat
% 
% add_secondary_vars;
%save Matfiles\rawEPA.mat rawEPA -mat -v7.3