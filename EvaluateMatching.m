%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name: Evaluate_FT_Tracks2.m
%
%  Description: Load the feature matching result generated by Wamifeatures
%               or by other programs but in the same format. Find each
%               track and crop a bounding box around the specific feature
%               points in each frame.
%
%
%  Created by
%  Ke Gao
%  Department of Electrical Engineering and Computer Science,
%  University of Missouri-Columbia
%  Columbia, MO 65211
%  kegao@mail.missouri.edu
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear;

shot=1;
txtPath = sprintf('/Volumes/E/VIRAT1_6_Output_BA/Files/BA/shot%d/',shot);
addpath(txtPath)

fileName = sprintf('%d_Points', shot);
fileNameExt = strcat(fileName, '.txt');
matches = load(fileNameExt);

%% -- Load image sequence
imgPath = sprintf('/Volumes/E/VIRAT1_6_Output_BA/Files/BA/shot%d/frames/', shot);
addpath(imgPath);
imgFile = fullfile(imgPath, '*.png');
imgDir = dir(imgFile);

%% -- Set save path
outPath = sprintf('/Volumes/E/VIRAT1_6_Output_BA/Files/BA/shot%d/tracks/', shot);


%% -- sort accoridng to trackID
sortedTrackID=sortrows(matches, 4);

%% -- statistics
tracks=sortedTrackID(:,4);
Total_tracks=max(tracks(:))
Longest_track=mode(tracks(:))
Longest_track_length=sum(tracks(:)== Longest_track)

bBoxRadius=195;

for trk=400
    %% make track folder
    folderName = sprintf('Track_%4d', trk);
    mkdir(outPath, folderName);
    
    %% get the track length
    track_length=sum(tracks(:)== trk);
    
    %% get frames for this trackID
    frames_pos=find(sortedTrackID(:,4)==trk);
    frame_ids=sortedTrackID(frames_pos, 1);
    
    %% -- incorrect!!
    if track_length~=length(frame_ids)
        disp('Something is wrong');
        return;
    end
    
    %% loop over in order to save output
    for i=frame_ids'
        imgDir(i).name
        image = imread(imgDir(i).name); 
        
        [rows, cols, chs] = size(image);
        img = zeros(rows, cols, 3);
        if (chs == 1); img(:,:,1) = image;img(:,:,2) = image;img(:,:,3) = image;else img = image; end
        img = uint8(img);
        
        rowIdx = round(sortedTrackID(i,3)) + 1;
        colIdx = round(sortedTrackID(i,2)) + 1;
        if (rowIdx > bBoxRadius && rowIdx < (rows-bBoxRadius) && colIdx > bBoxRadius && colIdx < (cols-bBoxRadius))
            imgROI = img(rowIdx-bBoxRadius:rowIdx+bBoxRadius, colIdx-bBoxRadius:colIdx+bBoxRadius, :);
        else % if the ft point within the boundary area
            img_pad = padarray(img, [bBoxRadius bBoxRadius], 0, 'both'); % add padding to the grayscale image
            rowIdx = rowIdx + bBoxRadius;
            colIdx = colIdx + bBoxRadius;
            imgROI = img_pad(rowIdx-bBoxRadius:rowIdx+bBoxRadius, colIdx-bBoxRadius:colIdx+bBoxRadius, :);
        end
        
        imgROI(bBoxRadius-2:bBoxRadius+2, bBoxRadius-2:bBoxRadius+2, 1) = 0;
        imgROI(bBoxRadius-2:bBoxRadius+2, bBoxRadius-2:bBoxRadius+2, 2) = 0;
        imgROI(bBoxRadius-2:bBoxRadius+2, bBoxRadius-2:bBoxRadius+2, 3) = 255;
        
        saveName = strcat(outPath, folderName, '/', 'Track_', num2str(trk), '_', imgDir(i).name);
        imwrite(imgROI, saveName);
        
    end
    
    xx=1;
    
end

