%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program takes a bA file (frameIDs X Y trackID) as input  shows
% tracks on each frame in different colors
% track_color_red_redBorder: consistent track points (alive in more than 5 frames)
% track_color_green_redBorder: new track points (just started in less than or equal to 5 frames)
% track_color_offwhite_redBorder: track points soon to be removed (in next 5 or less frames)
% if a frame does not have any such frames, we still save the frame
% also shows percent_inliers on each frame
% also shows whether it is a Reference frame or not
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clc; clear;

%% --variables
shot = 2;
all_ST=1;
N=100; %--no of tracks we want to visualize in video
rootDir='/Volumes/E/ABQ_all/ABQ_215_vmz/Files//';

%/Volumes/E/Output_1.31_CPU/VIRAT1_6_prev/Files/BA

%% --get point correspondances
file = sprintf('%s/BA/shot%d/%d_Points.txt', rootDir, shot, shot);
%--get shot boundary information
shotBoundaryList=dlmread([rootDir,'SB/shot_boundary.txt']); 
%--get image directory
imgDir='/Volumes/E/ABQ_all/ABQ_215_DS_4/';
files = dir(fullfile(imgDir,sprintf('%s*.%s','Da','jpg')));
%--output location
outDir=strcat(rootDir, 'Shot', num2str(shot), '_Points_all/');mkdir(outDir);

%--percent inliers for this shot
traceData=dlmread(strcat(rootDir, 'Homographies/shot', num2str(shot), '/', num2str(shot), '_traceData.txt'));%[dirname, sprintf('%d_traceData.txt', shot)]);
RefList=dlmread(strcat(rootDir, 'Homographies/shot', num2str(shot), '/', num2str(shot), '_ReferenceList.txt'));
RefList=RefList(:,1)';

%--Features_List and Inliers_List is necessary for calculating
%percent_inliers
Features_List=traceData(1, :);
Inliers_List=traceData(2, :);
perInliers=Inliers_List*100./Features_List;

%% --load matching data
data = load(file);

%% --save grphas of trackLength-vs-frquency
%getGraph(data, rootDir, shot, all_ST);

close all;

% %% --get largest N trackes with start and end number
[largest, start_frs, end_frs] = track_all_start_end(file, N-1); %98, 6016


%% --iterate over current-shot-frames
shot_start=shotBoundaryList(shot,1);
shot_end=shotBoundaryList(shot,2);
i=shot_start;


%% --iterate over all frames of current shot
while(i<=shot_end)
    i
    %--get image and corresponding track rows from tmpData
    I = imread( fullfile(imgDir, files(i).name) ); [M N d]=size(I);
    %--get orinal image id (like image name or serial number in the sequence)
    img_id=i-shot_start+1;
    %--get all data for this perticuler image
    row_id=find(data(:,1)==img_id)
    
    %--fontSize and other for showing text on image
    fontSize=40; vGap=60;
    str{1} = strcat('Frame_', sprintf('%04d', i-1)); str{2}=sprintf('in=%3.1f%%', perInliers(1,img_id)); 
    pos=[N 1; N 1+vGap];

    %--show frame no and percent_inliers on frame   
    I = insertText(uint8(I), pos, str, 'AnchorPoint', 'RightTop', 'fontSize', fontSize); %1800
    %--show if it is a Reference frame 
    if ismember(i, RefList)
        I = insertText(uint8(I), [N 1+2*vGap ], 'REF', 'AnchorPoint', 'RightTop', 'fontSize', fontSize, 'BoxColor', 'red', 'TextColor', 'white'); %1800      
    end

    close all; imshow(uint8(I)); hold on;    
    for xx=row_id' % row_id contains row_ids of matches of desired track no. for example, if frame1 has 10 tracks, then it tells which 10 rows of 'file' is of interest
        j=xx;
        rowIdx=round(data(j, 3))+1; %this will be Y coord
        colIdx=round(data(j, 2))+1; %this will be X coord
        trckdx=round(data(j, 4));   %this will be trackID
        
        %--from selcted tracks, we need serial number, so we can assign a perticuler color to it
        trck_no=find(largest==trckdx); %'largest' holds track index which we can use for 'start_frs' and 'ends_frs'
        
        %--check if current frame is the start_frame of this track
        start_frame=start_frs(trck_no)+shot_start-1; % start frame for this track
        end_frame=end_frs(trck_no)+shot_start-1;     % ending frame for this track
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
        
        %--plot the points
        scatter(colIdx, rowIdx, 'o', 'MarkerFaceColor', color,'MarkerEdgeColor', edgeColor);
        
        
    end  
    
    %--save current image iff there is atleast on gtrack on this frame
    saveName=strcat(outDir, files(i).name);
    print(saveName, '-dpng')
    
    
    %--go for the next frame
    i=i+1;
    
    
end
        

