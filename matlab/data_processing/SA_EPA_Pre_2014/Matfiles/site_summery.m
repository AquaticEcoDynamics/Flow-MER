clear all; close all;

load EPA.mat;

fid = fopen('epa.csv','wt');

fprintf(fid,'Site,X,Y\n');

sites = fieldnames(epa);



for i = 1:length(sites)
    
    X = [];
    Y = [];
    
    vars = fieldnames(epa.(sites{i}));
    
    for j = 1:length(vars)
        X(j) = epa.(sites{i}).(vars{j}).X;
        Y(j) = epa.(sites{i}).(vars{j}).Y;
    end
    
    fprintf(fid,'%s,%10.4f,%10.4f\n',sites{i},max(X),max(Y));
    
    clear X Y;
end

fclose(fid);
    
        