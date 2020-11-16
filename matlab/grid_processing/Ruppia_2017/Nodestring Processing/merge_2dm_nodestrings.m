function merge_2dm_nodestrings

oldfile = '../012_Coorong_Salt_Crk_Mouth_Channel_MZ2_Culverts.2dm';

newgrid = '../012_Coorong_Salt_Crk_Mouth_Channel_MZ3_Culverts1.2dm';

newfile = '../012_Coorong_Salt_Crk_Mouth_Channel_MZ3_Culverts.2dm';

[nodes,nodestrings] = tfv_get_nodes_nodestrings(oldfile);

[new_nodes,~] = tfv_get_nodes_nodestrings(newgrid);

%_____________________________________________________________________
fid = fopen(newgrid,'rt');
fid1 = fopen(newfile,'wt');

fline = fgetl(fid);
str = strsplit(fline);
fprintf(fid1,'%s\n',fline);


while strcmpi(str{1},'ND') == 0
    
    fline = fgetl(fid);
    str = strsplit(fline);
    fprintf(fid1,'%s\n',fline);
    
end


while strcmpi(str{1},'ND') == 1
    
    fline = fgetl(fid);
    str = strsplit(fline);
    if strcmpi(str{1},'ND') == 1
        fprintf(fid1,'%s\n',fline);
    end
end

for ii = 1:length(nodestrings)
    
    num_cells = length(nodestrings(ii).Cells);
    
    for jj = 1:length(nodestrings(ii).Cells)
        
        pnt(1,1) = nodes.X(nodestrings(ii).Cells(jj));
        pnt(1,2) = nodes.Y(nodestrings(ii).Cells(jj));
        
        geo_x = double(new_nodes.X');
        geo_y = double(new_nodes.Y');
        dtri = DelaunayTri(geo_x,geo_y);


        pt_id = nearestNeighbor(dtri,pnt);
        
        
        %ss = find(new_nodes.X ==nodes.X(nodestrings(ii).Cells(jj)) &  new_nodes.Y == nodes.Y(nodestrings(ii).Cells(jj)));  
        
        new_nodestrings(ii).Cells(jj) = new_nodes.ID(pt_id);
        
    end
    new_nodestrings(ii).Cells(end) = new_nodestrings(ii).Cells(end) * -1;
    
    if num_cells < 10 % Simple write method
        fprintf(fid1,'NS ');
        
        for kk = 1:num_cells
            
                fprintf(fid1,'%i ',new_nodestrings(ii).Cells(kk));
        end
        fprintf(fid1,'%i\n',(ii));
    else
        inc = 1;
        for kk = 1:num_cells
            if inc < 10
                
                if inc == 1
                    fprintf(fid1,'NS %i ',new_nodestrings(ii).Cells(kk));
                
                else
                    fprintf(fid1,'%i ',new_nodestrings(ii).Cells(kk));
                end
                inc = inc + 1;
            else
                    fprintf(fid1,'%i\n',new_nodestrings(ii).Cells(kk));
                    inc = 1;
            end
        end
        fprintf(fid1,'%i\n',(ii));
    end
end

while ~feof(fid)
    
    if strcmpi(str{1},'NS') == 0
        fprintf(fid1,'%s\n',fline);
    end
    fline = fgetl(fid);
    str = strsplit(fline);
end
    
fclose all;

end

function tfv_export_2dm(filename)
% A simple function to export the TFV 2dm file for other uses.


[XX,YY,ZZ,nodeID,faces,X,Y,ID,nodesting] = tfv_get_node_from_2dm(filename);

outfile = regexprep(filename,'.2dm','.xyz');


% Exports Nodes to XYZ file.
export_2_xyz(outfile,XX,YY,ZZ);




end

function export_2_xyz(filename,X,Y,Z)
fid = fopen(filename,'wt');
fprintf(fid,'X,Y,Z\n');

for i = 1:length(X)
    fprintf(fid,'%10.4f,%10.4f,%4.4f\n',X(i),Y(i),Z(i));
end
fclose(fid);
end

function [XX,YY,ZZ,nodeID,faces,X,Y,ID,nodesting] = tfv_get_node_from_2dm(filename)


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

temp = [];
ID = [];
nodesting = [];

while strcmpi(str{1},'NS') == 1
    
    if str2double(str{end - 1}) < 0
        
        ID = str2double(str{end});
        
        for i = 2:length(str)-1
            
            temp(length(temp)+1,1) = str2double(str{i});
            
        end
        nodesting(ID).Cells = abs(temp);
        temp = [];
        ID = [];
    else
        for i = 2:length(str)
            
            temp(length(temp)+1,1) = str2double(str{i});
            
        end
        
    end
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
    ID(ii) = ii;
end

end



function [ geom, iner, cpmo ] = polygeom( x, y )
%POLYGEOM Geometry of a planar polygon
%
%   POLYGEOM( X, Y ) returns area, X centroid,
%   Y centroid and perimeter for the planar polygon
%   specified by vertices in vectors X and Y.
%
%   [ GEOM, INER, CPMO ] = POLYGEOM( X, Y ) returns
%   area, centroid, perimeter and area moments of
%   inertia for the polygon.
%   GEOM = [ area   X_cen  Y_cen  perimeter ]
%   INER = [ Ixx    Iyy    Ixy    Iuu    Ivv    Iuv ]
%     u,v are centroidal axes parallel to x,y axes.
%   CPMO = [ I1     ang1   I2     ang2   J ]
%     I1,I2 are centroidal principal moments about axes
%         at angles ang1,ang2.
%     ang1 and ang2 are in radians.
%     J is centroidal polar moment.  J = I1 + I2 = Iuu + Ivv

% H.J. Sommer III - 02.05.14 - tested under MATLAB v5.2
%
% sample data
% x = [ 2.000  0.500  4.830  6.330 ]';
% y = [ 4.000  6.598  9.098  6.500 ]';
% 3x5 test rectangle with long axis at 30 degrees
% area=15, x_cen=3.415, y_cen=6.549, perimeter=16
% Ixx=659.561, Iyy=201.173, Ixy=344.117
% Iuu=16.249, Ivv=26.247, Iuv=8.660
% I1=11.249, ang1=30deg, I2=31.247, ang2=120deg, J=42.496
%
% H.J. Sommer III, Ph.D., Professor of Mechanical Engineering, 337 Leonhard Bldg
% The Pennsylvania State University, University Park, PA  16802
% (814)863-8997  FAX (814)865-9693  hjs1@psu.edu  www.me.psu.edu/sommer/

% begin function POLYGEOM

% check if inputs are same size
if ~isequal( size(x), size(y) ),
    error( 'X and Y must be the same size');
end

% number of vertices
[ x, ns ] = shiftdim( x );
[ y, ns ] = shiftdim( y );
[ n, c ] = size( x );

% temporarily shift data to mean of vertices for improved accuracy
xm = mean(x);
ym = mean(y);
x = x - xm*ones(n,1);
y = y - ym*ones(n,1);

% delta x and delta y
dx = x( [ 2:n 1 ] ) - x;
dy = y( [ 2:n 1 ] ) - y;

% summations for CW boundary integrals
A = sum( y.*dx - x.*dy )/2;
Axc = sum( 6*x.*y.*dx -3*x.*x.*dy +3*y.*dx.*dx +dx.*dx.*dy )/12;
Ayc = sum( 3*y.*y.*dx -6*x.*y.*dy -3*x.*dy.*dy -dx.*dy.*dy )/12;
Ixx = sum( 2*y.*y.*y.*dx -6*x.*y.*y.*dy -6*x.*y.*dy.*dy ...
    -2*x.*dy.*dy.*dy -2*y.*dx.*dy.*dy -dx.*dy.*dy.*dy )/12;
Iyy = sum( 6*x.*x.*y.*dx -2*x.*x.*x.*dy +6*x.*y.*dx.*dx ...
    +2*y.*dx.*dx.*dx +2*x.*dx.*dx.*dy +dx.*dx.*dx.*dy )/12;
Ixy = sum( 6*x.*y.*y.*dx -6*x.*x.*y.*dy +3*y.*y.*dx.*dx ...
    -3*x.*x.*dy.*dy +2*y.*dx.*dx.*dy -2*x.*dx.*dy.*dy )/24;
P = sum( sqrt( dx.*dx +dy.*dy ) );

% check for CCW versus CW boundary
if A < 0,
    A = -A;
    Axc = -Axc;
    Ayc = -Ayc;
    Ixx = -Ixx;
    Iyy = -Iyy;
    Ixy = -Ixy;
end

% centroidal moments
xc = Axc / A;
yc = Ayc / A;
Iuu = Ixx - A*yc*yc;
Ivv = Iyy - A*xc*xc;
Iuv = Ixy - A*xc*yc;
J = Iuu + Ivv;

% replace mean of vertices
x_cen = xc + xm;
y_cen = yc + ym;
Ixx = Iuu + A*y_cen*y_cen;
Iyy = Ivv + A*x_cen*x_cen;
Ixy = Iuv + A*x_cen*y_cen;

% principal moments and orientation
I = [ Iuu  -Iuv ;
    -Iuv   Ivv ];
[ eig_vec, eig_val ] = eig(I);
I1 = eig_val(1,1);
I2 = eig_val(2,2);
ang1 = atan2( eig_vec(2,1), eig_vec(1,1) );
ang2 = atan2( eig_vec(2,2), eig_vec(1,2) );

% return values
geom = [ A  x_cen  y_cen  P ];
iner = [ Ixx  Iyy  Ixy  Iuu  Ivv  Iuv ];
cpmo = [ I1  ang1  I2  ang2  J ];

% end of function POLYGEOM

end

function [nodes,nodesting] = tfv_get_nodes_nodestrings(filename)

%filename = 'LL_Full_Domain.2dm';


fid = fopen(filename,'rt');


fline = fgetl(fid);
fline = fgetl(fid);
fline = fgetl(fid);

str = strsplit(fline);

inc = 1;

while strcmpi(str{1},'ND') == 0
    fline = fgetl(fid);
    str = strsplit(fline);
end

disp('Importing Nodes');

while strcmpi(str{1},'ND') == 1
    
    nodes.ID(inc) = str2double(str{2});
    nodes.X(inc) = str2double(str{3});
    nodes.Y(inc) = str2double(str{4});
    
    fline = fgetl(fid);
    str = strsplit(fline);
    
    
    inc = inc + 1;
    
end

% Now for the nodestrings....

disp('Importing Nodestrings');
temp = [];
ID = [];
nodesting = [];

while strcmpi(str{1},'NS') == 1
    
    if str2double(str{end - 1}) < 0
        
        ID = str2double(str{end});
        
        for i = 2:length(str)-1
            
            temp(length(temp)+1,1) = str2double(str{i});
            
        end
        nodesting(ID).Cells = abs(temp);
        temp = [];
        ID = [];
    else
        for i = 2:length(str)
            
            temp(length(temp)+1,1) = str2double(str{i});
            
        end
        
    end
    fline = fgetl(fid);
    fline
    str = strsplit(fline);
end


end


