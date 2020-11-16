clear all; close all;

filename = 'Raw/Phytoplankton_(Busch).xls';

[snum,sstr] = xlsread(filename,'A2:X10000');

sites = sstr(:,7);
vars = sstr(:,11);
mdate = x2mdate(snum(:,14));
val_str = sstr(:,15);

for i = 1:length(val_str)
    t = str2num(val_str{i});
    if isnumeric(t)
        if ~isempty(t)
            val(i) = t;
        else
            val(i) = NaN;
        end
    else
        % This may change to be more complicated....
        val(i) = NaN;
    end
end

[snum,sstr] = xlsread('Conversions/Phyto_sites.csv','A2:D1000');

old_name = sstr(:,1);
new_name = sstr(:,2);
XX = snum(:,1);
YY = snum(:,2);

[snum,sstr] = xlsread('Conversions/Phyto_vars.csv','A2:B1000');

old_var = sstr(:,1);
new_var = sstr(:,2);

u_sites = unique(sites);
u_vars = unique(vars);

epa_phyto = [];

for i = 1:length(u_sites)
    
    ss = find(strcmpi(sites,u_sites{i}) == 1);
    
    t_date = mdate(ss);
    t_val = val(ss);
    t_var = vars(ss);
    
    tt = find(strcmpi(old_name,u_sites{i}) == 1);
    
    t_name = new_name{tt};
    X = XX(tt);
    Y = YY(tt);
    
    for j = 1:length(u_vars)
        
        
        
        ww = find(strcmpi(t_var,u_vars{j}) == 1);
        
        if ~isempty(ww)
            
            gg = find(strcmpi(old_var,u_vars{j}) == 1);
            
            p_var = new_var{gg};
            
            if strcmpi(p_var,'Ignore') == 0
                if X > 0
                    
                    if isfield(epa_phyto,t_name)
                        
                        if ~isfield(epa_phyto.(t_name),p_var)
                            epa_phyto.(t_name).(p_var).Date(:,1) = t_date(ww);
                            epa_phyto.(t_name).(p_var).Data(:,1) = t_val(ww);
                            epa_phyto.(t_name).(p_var).X = X;
                            epa_phyto.(t_name).(p_var).Y = Y;
                            epa_phyto.(t_name).(p_var).Depth(1:length(ww),1) = 0;
                            epa_phyto.(t_name).(p_var).Title = t_name;
                        else
                            disp('Duplicated site');
                            epa_phyto.(t_name).(p_var).Date = [epa_phyto.(t_name).(p_var).Date;t_date(ww)];
                            epa_phyto.(t_name).(p_var).Data = [epa_phyto.(t_name).(p_var).Data;t_val(ww)'];
                            t_depth(1:length(ww),1) = 0;
                            epa_phyto.(t_name).(p_var).Depth = [epa_phyto.(t_name).(p_var).Depth;t_depth];
                        end
                        
                    else
                        
                        epa_phyto.(t_name).(p_var).Date(:,1) = t_date(ww);
                        epa_phyto.(t_name).(p_var).Data(:,1) = t_val(ww);
                        epa_phyto.(t_name).(p_var).X = X;
                        epa_phyto.(t_name).(p_var).Y = Y;
                        epa_phyto.(t_name).(p_var).Depth(1:length(ww),1) = 0;
                        epa_phyto.(t_name).(p_var).Title = t_name;
                    end
                    
                    
                    
                end
            end
            
        end
    end
end

save Matfiles\epa_phyto.mat epa_phyto -mat;











