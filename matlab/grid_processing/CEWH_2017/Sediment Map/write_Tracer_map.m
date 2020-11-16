clear all; close all;

addpath(genpath('Functions'));

[XX,YY,nodeID,faces,X,Y,ID,materials] = tfv_get_node_from_2dm('001_RM_Wetlands_LL_Coorong_MZ.2dm');

[snum,sstr] = xlsread('defaults.xlsx','tau','C2:F3');


fid = fopen('resuspension_map.csv','wt');

fprintf(fid,'ID,trc_tau_0,trc_epsilon,trc_fs1,trc_fs2\n');

for i = 1:length(ID)
    if materials(i) == 9 | materials(i) == 8
        % Lakes
        fprintf(fid,'%d,%4.4f,%4.4f,%4.4f,%4.4f\n',ID(i),snum(2,1),snum(2,2),snum(2,3),snum(2,4));
    else
        % Everything else
        fprintf(fid,'%d,%4.4f,%4.4f,%4.4f,%4.4f\n',ID(i),snum(1,1),snum(1,2),snum(1,3),snum(1,4));
    end
end
fclose(fid);

% sss = find(materials == 1);
% scatter(X(sss),Y(sss),'.');hold on
