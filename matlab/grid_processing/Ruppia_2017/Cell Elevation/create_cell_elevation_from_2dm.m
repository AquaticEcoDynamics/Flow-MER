clear all; close all;

addpath(genpath('Functions'));

gridfile = 'RM_Wetlands_v1.2dm';
outfile = 'RM_Wetlands_v1.csv';
[XX,YY,nodeID,faces,Cell_X,Cell_Y,Cell_ID,Cell_Z] = tfv_get_node_from_2dm(gridfile);

fid = fopen(outfile,'wt');

fprintf(fid,'x,y,id,z\n');

for i = 1:length(Cell_X)
    fprintf(fid,'%8.4f,%8.4f,%d,%4.4f\n',...
        Cell_X(i),Cell_Y(i),Cell_ID(i),Cell_Z(i));
end
fclose(fid);

