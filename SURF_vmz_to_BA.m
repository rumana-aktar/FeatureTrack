%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program takes a bA file (frameID X Y trackID) from vmz with SURF features as input and
% produces BA files (X Y trackID) for tracking as output
% input: one BA file for all frames with 4 columns (FrameIDs X Y trackID)
% output: many BA files one for each frame with 1. no of features in line 1 and 
%           2. 3 columns (X Y trackID)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all;

shot=2;
%--input directory with 1 file
inDir='/Volumes/E/ABQ_all/ABQ_215_vmz_copy/Files/';
%--read the bA data
%data=load(sprintf('%sBA/shot%d/%d_Points.txt', inDir, shot, shot));
data1=struct2cell(load('BA.mat'));
data=data1{1};

%--output directory for each new file
outDir=sprintf('%sBA/shot%d/PointsEachFrame/',inDir, shot); mkdir(outDir);

%--read the frameIDs
frameIds=data(:, 1);
%--read unique frameIDs
uniFrameIds=unique(frameIds);

outData=[];
filenameAllInOne=sprintf('%sOutData.txt', outDir);
if isequal(exist(filenameAllInOne, 'file'), 2);delete(filenameAllInOne);end
    
%--for each unique frame, write its features locations and trackID
for fr=uniFrameIds'
    fr
    
    %--file for saving current frame's features
    filename=sprintf('%sFrame_%04d.txt', outDir, fr);
    if isequal(exist(filename, 'file'), 2);delete(filename);end
    
    %--find which rows belong to current frame
    rows=find(data(:,1)==fr);
    frameIDs=zeros(size(rows,1),1);
    frameIDs(:)=fr;
    
    %--save number of features in line 1 and then (X Y trackID) touple from
    %line 2 and on
    %dlmwrite(filename, size(rows,1), '-append', 'delimiter','\t','newline','pc');
    %dlmwrite(filename, data(rows, 2:4), '-append', 'delimiter','\t','newline','pc');
    
    outData=[outData;[frameIDs'; data(rows, 2:4)']'];
end

dlmwrite(filenameAllInOne, outData, '-append', 'delimiter','\t','newline','pc');

rows=find(data(:,4)==109340);

tempData=(data(rows, :));


