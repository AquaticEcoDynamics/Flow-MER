clear all; close all;

addpath(genpath('functions'));

existing = dir('CEWH_E\*.csv');

[~,~,~,~,oldX,oldY,oldID] = tfv_get_node_from_2dm('001_RM_Wetlands_LL_Coorong_MZ.2dm');

[~,~,~,~,newX,newY,newID] = tfv_get_node_from_2dm('RM_Wetlands_v2_Wetland_MZ.2dm');

for i = 1:length(existing)
    filename = ['CEWH_E\',existing(i).name];
    
    [headers,data] = load_IC_file(filename);
    
    newfile = regexprep(filename,'.csv','_RM.csv');
    
    newfile = regexprep(newfile,'CEWH_E','CEWH_N');
    
    data2 = interp_data(data,oldX,oldY,newX,newY,newID);
    
    write_IC(headers,data2,newfile);
end