clear all; close all;

infile = 'Goolwa.2dm';
outfile = 'Goolwa_clipped.2dm';

clip_depth = -0.5;

fid = fopen(infile,'rt');
fid1 = fopen(outfile,'wt');

while ~feof(fid)
    line = fgetl(fid);
    
    spt_line = strsplit(line,' ');
    
    if strcmpi(spt_line{1},'ND') == 1
        
        ID = str2num(spt_line{2});
        X = str2num(spt_line{3});
        Y = str2num(spt_line{4});
        Z = str2num(spt_line{5});
        
        if Z > clip_depth
            Z = clip_depth;
        end
        
        fprintf(fid1,'%s %d %8.4f %8.4f %4.4f\n',spt_line{1},ID,X,Y,Z);
    else
        fprintf(fid1,'%s\n',line);
    end
end