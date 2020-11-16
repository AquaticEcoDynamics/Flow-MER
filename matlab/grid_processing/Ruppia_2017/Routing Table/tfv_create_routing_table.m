function tfv_create_routing_table(filename)
% A Function to create a routing table as required for the land module for AED2.
% 
% The function requires a functional 2dm file created by SMS (post v10).
%
% A file called Routing_Tbl.csv is produced.
%
% The function runs a final test after the table has been calculated based
% on a lake height of -0.5
%
% Inputs: filename (the filename of the 2dm file)

% cell_faces refers to the node ID that makes up each cell.

disp('Importing 2dm file');
disp('----------------------------');
[~,~,~,~,cell_faces,~,~,cell_Z,cell_ID] = tfv_get_node_from_2dm_RT(filename);


r_cell(1:length(cell_ID)) = 0;
disp('Calculatng cell routes');
disp('----------------------------');
for i = 1:length(cell_ID)
    
   %tic
   disp([num2str(i),' of ',num2str(length(cell_ID))]);
    D = fastintersect_2(cell_faces,cell_faces(:,i),i);
   %toc 
    [~,ind] = min(cell_Z(D));
    r_cell(i) = D(ind);
    
    clear D ind
    
end


 fid = fopen('Routing_Tbl.csv','wt');
 
 fprintf(fid,'Cell ID,Routing Cell ID\n');
 
 for i = 1:length(cell_ID)
     fprintf(fid,'%i,%i\n',cell_ID(i),r_cell(i));
 end
 fclose(fid);

disp('Testing Table');
disp('----------------------------');
lake_height = -0.5;
test_routing_tbl_v2(cell_ID,r_cell,cell_Z,lake_height);


end
function test_routing_tbl_v2(cell_ID,rcell,cell_Z,lake_height)



%_________________________________________________________________________
o_cell = cell_ID;
r_cell = rcell;

dry_cells = find(cell_Z > lake_height);


fid = fopen('Routing_Test.csv','wt');

fprintf(fid,'Wet == Lowest cell routed to is BELOW the -0.5 mark\n');
fprintf(fid,'Pooled == Lowest cell routed to is ABOVE the -0.5 mark\n');


fprintf(fid,'Cell_ID,Z Height,Route\n');

for i = 1:length(dry_cells)
    
    fprintf(fid,'%i,%4.4f,',cell_ID(dry_cells(i)),cell_Z(dry_cells(i)));
    
    iswet = 0;
    
    cur_cell_ID = cell_ID(dry_cells(i));
    count = 1;
    while ~iswet
        
        ss = find(o_cell == cur_cell_ID);
        
        if r_cell(ss) == cur_cell_ID
        
            fprintf(fid,'%i,Pooled\n',cur_cell_ID);
            iswet = 1;
        else
            
            cur_cell_ID = r_cell(ss);
            
            tt = find(cell_ID == cur_cell_ID);
            
            if cell_Z(tt) <= lake_height
                fprintf(fid,'%i,Wet\n',cur_cell_ID);
                iswet = 1;
            else
                fprintf(fid,'%i,',cur_cell_ID);
                iswet = 0;
            end
        end
        count = count + 1;
        
        if count > 50
            disp(num2str(cur_cell_ID));
            %clear all; close all; fclose all;
            stop
        end
    end
end
fclose all;
end

function D = fastintersect(A,B,start)
count = 1;
cell_Count = length(unique(B));
max_cell = cell_Count + 1;
if start > 500
    start_i = start - 500;
else
    start_i = 1;
end

if (start+500) > size(A,2)
    iend = size(A,2);
else
    iend = start + 500;
end
    
for i = start_i:iend
    P = zeros(1, max(max(A(:,i)),max(B)) ) ;
    P(A(:,i)) = 1;
    C = B(logical(P(B)));

    if numel(unique(C)) > 1
        D(count) = i;
        count = count + 1;
    end   
    clear P C
    
end
end
function [XX,YY,ZZ,nodeID,faces,X,Y,Z,ID] = tfv_get_node_from_2dm_RT(filename)


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

function D = fastintersect_2(A,B,start)
count = 1;
cell_Count = length(unique(B));
max_cell = cell_Count + 1;
if start > 500
    start_i = start - 500;
else
    start_i = 1;
end

if (start+500) > size(A,2)
    iend = size(A,2);
else
    iend = start + 500;
end
    
for i = start_i:iend
    P = zeros(1, max(max(A(:,i)),max(B)) ) ;
    P(A(:,i)) = 1;
    C = B(logical(P(B)));

    if numel(unique(C)) > 1
        D(count) = i;
        count = count + 1;
    end   
    clear P C
    
end
end