function create_routing_table_v2
addpath(genpath('Functions'))

% cell_faces refers to the node ID that makes up each cell.
[node_X,node_Y,node_Z,node_ID,cell_faces,cell_X,cell_Y,cell_Z,cell_ID] = tfv_get_node_from_2dm_RT('Albert.2dm');


r_cell(1:length(cell_ID)) = 0;

for i = 1:length(cell_ID)
    
   tic
    D = fastintersect_2(cell_faces,cell_faces(:,i),i);
   toc 
    [~,ind] = min(cell_Z(D));
    r_cell(i) = D(ind);
    
    clear D ind
    
end


 fid = fopen('Routing_Tbl_Albert.csv','wt');
 
 fprintf(fid,'Cell ID,Routing Cell ID\n');
 
 for i = 1:length(cell_ID)
     fprintf(fid,'%i,%i\n',cell_ID(i),r_cell(i));
 end
 fclose(fid);


lake_height = -0.5;
test_routing_tbl_v2(cell_ID,r_cell,cell_Z,lake_height);


end

function [XX,YY,ZZ,nodeID,faces,X,Y,Z,ID] = tfv_get_node_from_2dm(filename)


fid = fopen(filename,'rt');

fline = fgetl(fid);
fline = fgetl(fid);
fline = fgetl(fid);
fline = fgetl(fid);


str = strsplit(fline);

inc = 1;

switch str{1}
    case 'E4Q'
        for ii = 1:4
            faces(ii,inc) = str2double(str{ii + 2});
        end
    case 'E3T'
        for ii = 1:3
            faces(ii,inc) = str2double(str{ii + 2});
        end
        faces(4,inc) = str2double(str{3});
    otherwise
end

inc = inc + 1;
fline = fgetl(fid);
str = strsplit(fline);
while strcmpi(str{1},'ND') == 0
    switch str{1}
        case 'E4Q'
            for ii = 1:4
                faces(ii,inc) = str2double(str{ii + 2});
            end
        case 'E3T'
            for ii = 1:3
                faces(ii,inc) = str2double(str{ii + 2});
            end
            faces(4,inc) = str2double(str{3});
        otherwise
    end
    inc = inc + 1;
    fline = fgetl(fid);
    str = strsplit(fline);
    
end

inc = 1;

nodeID(inc,1) = str2double(str{2});
XX(inc,1) = str2double(str{3});
YY(inc,1) = str2double(str{4});

inc = 2;
fline = fgetl(fid);
str = strsplit(fline);

while strcmpi(str{1},'ND') == 1
    nodeID(inc,1) = str2double(str{2});
    XX(inc,1) = str2double(str{3});
    YY(inc,1) = str2double(str{4});
    ZZ(inc,1) = str2double(str{5});
    inc = inc + 1;
    fline = fgetl(fid);
    str = strsplit(fline);
    
end

fclose(fid);

X(1:length(faces),1) = NaN;
Y(1:length(faces),1) = NaN;
ID(1:length(faces),1) = NaN;

for ii = 1:length(faces)
    gg = polygeom(XX(faces(:,ii)),YY(faces(:,ii)));
    X(ii) = gg(2);
    Y(ii) = gg(3);
    Z(ii) = mean(ZZ(faces(:,ii)));
    ID(ii) = ii;
end
end