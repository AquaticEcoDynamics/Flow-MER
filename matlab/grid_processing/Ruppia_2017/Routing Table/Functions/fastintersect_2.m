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