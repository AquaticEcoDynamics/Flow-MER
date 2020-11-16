clear all; close all;

addpath(genpath('functions'));

existing = dir('existing\*.csv');

[~,~,~,~,oldX,oldY,oldID] = tfv_get_node_from_2dm('LL_Full_Domain.2dm');

[~,~,~,~,newX,newY,newID] = tfv_get_node_from_2dm('RM_Wetlands_v1.2dm');

for i = 1:length(existing)
    filename = ['existing\',existing(i).name];
    
    [headers,data] = load_IC_file(filename);
    
    newfile = regexprep(filename,'.csv','_v6.csv');
    
    newfile = regexprep(newfile,'existing','new_files');
    
    data2 = interp_data(data,oldX,oldY,newX,newY,newID);
    
    write_IC(headers,data2,newfile);
end