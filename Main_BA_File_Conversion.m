%% Author Rumana Aktar, 12/04/19
%% Reads a BA file produced by VMZ and reformate it for Ke's algorithm


clear all; clc;

dirname='/Volumes/D/BA/Output/Files/BA/shot3/';
shot=3;
start_frame_no=0;

dirnameOut=sprintf('%sFormat/', dirname); mkdir(dirnameOut);
xy=dlmread(sprintf('%s%d_Points.txt', dirname, shot));

%% 
frameIDs=xy(:,1);
uniqueFrameIDs=unique(frameIDs);

for i=1:size(uniqueFrameIDs,1)
    
    frameIDs=xy(:,1);
    rowIDs=find(frameIDs==i);
    frameData=xy(rowIDs, [2 3 4]);
    
    fid = fopen(sprintf('%sFrame_%06d.txt', dirnameOut, i-1),'wt');
    fprintf(fid, '%d\n',size(frameData,1));    
    for j=1:size(frameData,1)
        fprintf(fid,'%d %d %d\n',frameData(j, :));
    end    
    fclose(fid);
    
    [i size(frameData)]
    
end
