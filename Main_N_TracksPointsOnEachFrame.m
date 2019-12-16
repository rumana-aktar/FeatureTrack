%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program takes a bA file as input and shows largest 1000 tracks on
% frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clc; clear;

%% --variables
shot = 3;
all_ST=1;
N=1000; %--no of tracks we want to visualize in video
rootDir='/Volumes/D/BA/Output/Files/';

%--get image directory
imgDir='/Volumes/D/BA/RIT3Ddata_RGB/';
files = dir(fullfile(imgDir,sprintf('%s*.%s','AA','jpg')));


%/Volumes/E/Output_1.31_CPU/VIRAT1_6_prev/Files/BA

%% --get point correspondances
file = sprintf('%s/BA/shot%d/%d_Points.txt', rootDir, shot, shot);
%--get shot boundary information
shotBoundaryList=dlmread([rootDir,'SB/shot_boundary.txt']); 
%--output location
outDir=strcat(rootDir, 'Shot', num2str(shot), '_Points_1000/');mkdir(outDir);

%--need to know reference and within group reference information for
%shwoing on every frame
traceData=dlmread(strcat(rootDir, 'Homographies/shot', num2str(shot), '/', num2str(shot), '_traceData.txt'));%[dirname, sprintf('%d_traceData.txt', shot)]);
RefList=dlmread(strcat(rootDir, 'Homographies/shot', num2str(shot), '/', num2str(shot), '_ReferenceList.txt'));
RefList=RefList(:,1)';
WRefList=dlmread(strcat(rootDir, 'Homographies/shot', num2str(shot), '/', num2str(shot), '_WRefList.txt'));

%--percent inliers for this shot
Features_List=traceData(1, :);
Inliers_List=traceData(2, :);
perInliers=Inliers_List*100./Features_List;

%% --load matching data
data = load(file);

%% --save grphas of trackLength-vs-frquency
%getGraph(data, rootDir, shot, all_ST);

close all;

%% --get largest N trackes with start and end number
[largest, start_frs, end_frs] = track_N_start_end(file, N-1); %98, 6016



%% --get only those data which has these tracks
rowIDS=[];
for i=largest'
    row_id=find(data(:,4)==i);
    rowIDS=[rowIDS; row_id];
end
tmpData=data(rowIDS, :);
tmpData = sortrows(tmpData, 1);


%% --iterate over current-shot-frames
shot_start=shotBoundaryList(shot,1);
shot_end=shotBoundaryList(shot,2);
i=shot_start;


%% --iterate over all frames of current shot
while(i<=shot_end)
    i
    %--get image and corresponding track rows from tmpData
    I = imread( fullfile(imgDir, files(i).name) ); [MM, NN, ~]=size(I);
    %--get orinal image id (like image name or serial number in the sequence)
    img_id=i-shot_start+1;
    %--get all data for this perticuler image
    row_id=find(tmpData(:,1)==img_id);
    
    %--fontSize and other for showing text on image
    fontSize=15; vGap=28;
    str{1} = strcat('Frame_', sprintf('%04d', i)); str{2}=sprintf('in=%3.1f%%', perInliers(1,img_id)); 
    pos=[NN 1; NN 1+vGap];

    %--show frame no and percent_inliers on frame   
    I = insertText(uint8(I), pos, str, 'AnchorPoint', 'RightTop', 'fontSize', fontSize); %1800
    %--show if it is a Reference frame 
    if ismember(i, RefList)
      I = insertText(uint8(I), [NN 1+2*vGap ], 'REF', 'AnchorPoint', 'RightTop', 'fontSize', fontSize, 'BoxColor', 'red', 'TextColor', 'white'); %1800      
    elseif ismember(i, WRefList)  %--show if it is a WGReference frame    
      I = insertText(uint8(I), [NN 1+2*vGap ], 'WREF', 'AnchorPoint', 'RightTop', 'fontSize', fontSize); %1800      
    end

    close all; imshow(uint8(I)); hold on;

    for xx=row_id' % row_id contains row_ids of matches of desired track no. for example, if frame1 has 10 tracks, then it tells which 10 rows of 'file' is of interest
        j=xx;
        rowIdx=round(tmpData(j, 3))+1; %this will be Y coord
        colIdx=round(tmpData(j, 2))+1; %this will be X coord
        trckdx=round(tmpData(j, 4));   %this will be trackID
        st_ncc=round(data(j, 6));      %this will be ncc score
        
        
        %--from selcted tracks, we need serial number, so we can assign a perticuler color to it
        trck_no=find(largest==trckdx);
        
        %--check if current frame is the start_frame of this track
        start_frame=start_frs(trck_no)+shot_start-1; % start frame for this track
        end_frame=end_frs(trck_no)+shot_start-1;     % end frame for this track
        if start_frame==i || start_frame==i-1 || start_frame==i-2 || start_frame==i-3 || start_frame==i-4
            color=[0 1 0];
            %--go green, this is a new frame, started in less than 5 frames
       elseif end_frame==i || end_frame==i+1 || end_frame==i+2 || end_frame==i+3 || end_frame==i+4
            color=[.8 .8 .8];
            %--go gray. this is a soon to be removed frame, will be removed in less than 5 frames        
        else
            color=[1 0 0];
            %--go red, consistent feature point, alive longer than 5 frames
        end
        edgeColor=[1 0 0];%--go red
        boxColor=[1 1 1];%--go white
        
        %--show a square around point if it comes from NCC (homogeneous region)
        if st_ncc==2
            plot(colIdx,rowIdx,'--gs',  'LineWidth',2, 'MarkerSize',12, 'MarkerEdgeColor','k', 'MarkerFaceColor','w')
        end
        scatter(colIdx, rowIdx, 'o', 'MarkerFaceColor', color,'MarkerEdgeColor', edgeColor);
              
    end  
    
    %--save current image iff there is atleast on gtrack on this frame
    saveName=strcat(outDir, files(i).name);
    print(saveName, '-dpng')
        
    %--go for the next frame
    i=i+1;
    
    
end
        

