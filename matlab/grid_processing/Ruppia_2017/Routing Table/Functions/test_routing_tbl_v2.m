function test_routing_tbl_v2(cell_ID,rcell,cell_Z,lake_height)

% [node_X,node_Y,node_Z,node_ID,cell_faces,cell_X,cell_Y,cell_Z,cell_ID] = tfv_get_node_from_2dm('Lakes_Only_ASS_v3_Substrate.2dm');
% 
% [snum,~] = xlsread('Routing_Tbl_2.csv','A2:B100000');

% lake_height = -0.5;

%_________________________________________________________________________
o_cell = cell_ID;
r_cell = rcell;

dry_cells = find(cell_Z > lake_height);


% fid = fopen('test_route.csv','wt');
% 
% 
% fprintf(fid,'Cell_ID,Z Height,Route\n');

for i = 1:length(dry_cells)
    
    %fprintf(fid,'%i,%4.4f,',cell_ID(dry_cells(i)),cell_Z(dry_cells(i)));
    
    iswet = 0;
    
    cur_cell_ID = cell_ID(dry_cells(i));
    count = 1;
    while ~iswet
        
        ss = find(o_cell == cur_cell_ID);
        
        if r_cell(ss) == cur_cell_ID
        
            %fprintf(fid,'%i,Pooled\n',cur_cell_ID);
            iswet = 1;
        else
            
            cur_cell_ID = r_cell(ss);
            
            tt = find(cell_ID == cur_cell_ID);
            
            if cell_Z(tt) <= lake_height
                %fprintf(fid,'%i,Wet\n',cur_cell_ID);
                iswet = 1;
            else
                %fprintf(fid,'%i,',cur_cell_ID);
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

fclose all
                
            
            
        
        
    
    
    





