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

shot=3;

% %-- Load matching result txt file
% txtPath = '/home/kegao/Files/Research/Feature_Matching/ABQ_Result/';
txtPath = sprintf('/Volumes/D/BA/Output/Files/BA/shot%d/',shot);
addpath(txtPath);
% fileName = 'matches';
fileName = sprintf('%d_Points', shot);
fileNameExt = strcat(fileName, '.txt');
matches = load(fileNameExt);

% %-- Load image sequence
% imgPath = '/home/kegao/Files/Research/Dataset/TS_Albq_oneOrbit_smapled_originalImageSize/';
% imgPath = '/home/kegao/Files/Research/Dataset/TS_ABQ_215_Render_Shell_r1_s0_5/';
imgPath = sprintf('/Volumes/D/BA/RIT3Ddata_RGB/');
addpath(imgPath);
imgFile = fullfile(imgPath, '*.jpg');
imgDir = dir(imgFile);

% % %-- Load down-sampled image sequence
% imgPath = '/home/kegao/Desktop/Research/Dataset/TS_ABQ215_pgm_DownSampled';
% addpath(imgPath);
% imgFile = fullfile(imgPath, '*.pgm');
% imgDir = dir(imgFile);

% %-- Set save path
% outPath = '/home/kegao/Files/Research/Feature_Matching/Track_Visualize/TS_ABQ_215_matches_RenderR1S05_cudasift/';
outPath = sprintf('/Volumes/D/BA/Output/Files/BA/shot%d/Tracks/',shot);

% %-- Sort according to the last column (track ID)
[~, order1] = sort(matches(:,4));
matchSortID = matches(order1,:);

% %-- Compute the length of each track
tracksID = unique(matchSortID(:,4));
tracksCnt = hist(matchSortID(:,4), tracksID);
tracksCnt = tracksCnt';

% %-- Find the longest tracks
tracks = zeros(length(tracksID), 2);
tracks(:,1) = tracksID;
tracks(:,2) = tracksCnt;
[~, order2] = sort(tracks(:,2), 'descend');
tracksSortLength = tracks(order2,:);

% %-- Compute max, mean, and stddev of tracks' length
trackMax = max(tracksSortLength(:,2));
trackAvg = mean(tracksSortLength(:,2));
trackStd = std(tracksSortLength(:,2));

% %-- Visualize each track
bBoxRadius = 195;
% for i0 = 1:length(tracksSortLength)
for i0 = 1
    X1 = ['Track: ', num2str(i0)];
    disp(X1);
    folderName = 'Track';
    if (i0 < 10)
        folderName = strcat(folderName, '00', num2str(i0));
    elseif (i0 >= 10 && i0 < 100)
        folderName = strcat(folderName, '0', num2str(i0));
    end
    mkdir(outPath, folderName);
    track = find( matchSortID(:,4)==tracksSortLength(i0,1) );
    for i1 = 1:length(track)
        %         if (i1 == 26)
        %             iii = 0;
        %         end
        X3 = ['Frame: ', num2str(i1), '/', num2str(length(track))];
        disp(X3);
        imgIdx = matchSortID(track(i1),1) + 1;
        image = imread(imgDir(imgIdx).name);
        [rows, cols, chs] = size(image);
        img = zeros(rows, cols, 3);
        if (chs == 1)
            img(:,:,1) = image;
            img(:,:,2) = image;
            img(:,:,3) = image;
        else
            img = image;
        end
        img = uint8(img);
        rowIdx = round(matchSortID(track(i1),3)) + 1;
        colIdx = round(matchSortID(track(i1),2)) + 1;
        if (rowIdx > bBoxRadius && rowIdx < (rows-bBoxRadius) && colIdx > bBoxRadius && colIdx < (cols-bBoxRadius))
            imgROI = img(rowIdx-bBoxRadius:rowIdx+bBoxRadius, colIdx-bBoxRadius:colIdx+bBoxRadius, :);
        else % if the ft point within the boundary area
            img_pad = padarray(img, [bBoxRadius bBoxRadius], 0, 'both'); % add padding to the grayscale image
            rowIdx = rowIdx + bBoxRadius;
            colIdx = colIdx + bBoxRadius;
            imgROI = img_pad(rowIdx-bBoxRadius:rowIdx+bBoxRadius, colIdx-bBoxRadius:colIdx+bBoxRadius, :);
        end
        imgROI(bBoxRadius-2:bBoxRadius+2, bBoxRadius-2:bBoxRadius+2, 1) = 255;
        imgROI(bBoxRadius-2:bBoxRadius+2, bBoxRadius-2:bBoxRadius+2, 2) = 0;
        imgROI(bBoxRadius-2:bBoxRadius+2, bBoxRadius-2:bBoxRadius+2, 3) = 0;
        if (i0 < 10)
            saveName = strcat(outPath, folderName, '/', 'Track_00', num2str(i0), '_', imgDir(imgIdx-1).name, '.png');
        elseif (i0 >= 10 && i0 < 100)
            saveName = strcat(outPath, folderName, '/', 'Track_0', num2str(i0), '_', imgDir(imgIdx-1).name, '.png');
        elseif (i0 >= 100 && i0 < 1000)
            saveName = strcat(outPath, folderName, '/', 'Track_', num2str(i0), '_', imgDir(imgIdx-1).name, '.png');
        end
        imwrite(imgROI, saveName);
    end
end











