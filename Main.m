%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name: Main.m
%  picks largest n tracks and makes a video of them with rectangular box,
%  color, track id, ncc score
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clc; clear;

%% --variables
shot = 2;

for shot=4


all_ST=1;
N=10; %--no of tracks we want to visualize in video
rootDir='/Volumes/E/Output_1.31_CPU/VIRAT1_6_prev/Files/';

%% --get point correspondances
file = sprintf('%s/BA/shot%d/%d_Points.txt', rootDir, shot, shot);
%--get shot boundary information
shotBoundaryList=dlmread([rootDir,'SB/shot_boundary.txt']); 
%--get image directory
imgDir='/Volumes/F/Data/VIRAT_Tape/09152008flight2tape1_6/';
files = dir(fullfile(imgDir,sprintf('%s*.%s','Fr','png')));
%--output location
outDir=strcat(rootDir, 'Shot', num2str(shot), '_Tracks_Largest/');mkdir(outDir);

%% --load matching data
data = load(file);

%% --save grphas of trackLength-vs-frquency
%getGraph(data, rootDir, shot, all_ST);

close all;

%% --get largest 10 trackes
largest = getTrackNumbers(file, N-1); %98, 6016


%% --get only those data which has these tracks
rowIDS=[];
for i=largest'
    row_id=find(data(:,4)==i);
    rowIDS=[rowIDS; row_id];
end
tmpData=data(rowIDS, :);
tmpData = sortrows(tmpData, 1);

% frames=tmpData(:,1);
% smallest_fr=min(frames);
% lsargest_fr=max(frames);

%% --iterate over current-shot-frames
shot_start=shotBoundaryList(shot,1);
shot_end=shotBoundaryList(shot,2);
i=shot_start;

%% --color selection
bBoxRadius=4;
clist=colormap(jet(N));
clist=clist*255;

%% --iterate over all frames of current shot
while(i<=shot_end)
    i
    %--get image and corresponding track rows from tmpData
    I = imread( fullfile(imgDir, files(i).name) );
    img_id=i-shot_start+1;
    row_id=find(tmpData(:,1)==img_id)
    
    %--put the track markers with track ids
    I=putTrackIdMarker(I, clist, largest, bBoxRadius, i) ;    
    imshow(uint8(I));
    
    for xx=row_id'
        j=xx;
        rowIdx=round(tmpData(j, 3))+1;
        colIdx=round(tmpData(j, 2))+1;
        trckdx=round(tmpData(j, 4));
        
        %--from selcted tracks, we need serial number, so we can assign a perticuler color to it
        trck_no=find(largest==trckdx);
        
        %--make the box
        I(rowIdx-bBoxRadius:rowIdx+bBoxRadius, colIdx-bBoxRadius:colIdx+bBoxRadius, 1) = clist(trck_no, 1);
        I(rowIdx-bBoxRadius:rowIdx+bBoxRadius, colIdx-bBoxRadius:colIdx+bBoxRadius, 2) = clist(trck_no, 2);
        I(rowIdx-bBoxRadius:rowIdx+bBoxRadius, colIdx-bBoxRadius:colIdx+bBoxRadius, 3) = clist(trck_no, 3);
        
        
        %--insert text, though it seems just inserting ncc number is fine
        %I = insertText(uint8(I), [colIdx+10 rowIdx+10 ], strcat(num2str(trckdx), ', ',sprintf('%.2f', tmpData(j, 5))), 'AnchorPoint', 'Center',...
         %   'BoxColor', 'yellow','BoxOpacity',0.4,'TextColor','black');%,': ', num2str(tmpData(j, 5))));
        
        I = insertText(uint8(I), [colIdx+5 rowIdx+5 ], sprintf('%.2f', tmpData(j, 5)), 'AnchorPoint', 'LeftTop',...
            'BoxColor', 'yellow','BoxOpacity',0.4,'TextColor','black');%,': ', num2str(tmpData(j, 5))));
        
    end  
    
    if size(row_id,1)>=1
        %--save current image iff there is atleast on gtrack on this frame
        saveName=strcat(outDir, files(i).name);
        imwrite(uint8(I), saveName);
    end
    
    %--go for the next frame
    i=i+1;
    
    
end
        

end