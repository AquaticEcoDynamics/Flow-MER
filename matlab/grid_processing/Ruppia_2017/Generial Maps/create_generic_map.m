function create_generic_map
% A function which takes a csv information file and a 2dm file and creates
% a cell based IC for AED2 variables.

[snum,~] = xlsread('Exported_ARCMAP.xls','A2:G50000');
cell_ID_veg = snum(:,1);
perc_veg = snum(:,end);


info_file = 'Map_info.xlsx';

geo_file = '../001_CLLMM_RW_MZ.2dm';

output_file = 'Benthic_Map.csv';
% Get var names
[~,headers] = xlsread(info_file,'Data','B1:Z1');

% get_mat_zones
[mat_zones,~] = xlsread(info_file,'Data','A2:A100');

[data,~] = xlsread(info_file,'Data','B2:Z100');


fidout = fopen(output_file,'wt');

% Write the headers out
fprintf(fidout,'ID,');
for i = 1:length(headers)
    if i == length(headers)
        fprintf(fidout,'%s\n',headers{i});
    else
        fprintf(fidout,'%s,',headers{i});
    end
end

fid = fopen(geo_file,'rt');
% There are three header lines in the file
fline = fgetl(fid);
fline = fgetl(fid);
fline = fgetl(fid);

% First Actual Line
fline = fgetl(fid);

line_spt = strsplit(fline,' ');

while strcmpi(line_spt{1},'ND') == 0
    mz = str2num(line_spt{end});
    
    ss = find(mat_zones == mz);
    
    cell_ID = str2num(line_spt{2});
    
    gg = find(cell_ID_veg == cell_ID);
    
    fprintf(fidout,'%d,',cell_ID);
    
    for i = 1:length(headers)
        
        pval = data(ss,i);
        
        if strcmpi(headers{i},'VEG_grasses_cover') & cell_ID < 9235
            pval = (100 - perc_veg(gg))/100;
        end
        if strcmpi(headers{i},'VEG_eucalypt_cover') & cell_ID < 9235
            pval = (perc_veg(gg))/100;
        end

        
        if i == length(headers)
            fprintf(fidout,'%5.5f\n',pval);
        else
            fprintf(fidout,'%5.5f,',pval);
        end
    end
    
    fline = fgetl(fid);

    line_spt = strsplit(fline,' ');   
end
fclose(fid);
fclose(fidout);
