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

close all; clc; clear;



shot=2;p='NCC';

if shot==1
    st_fr=1;
elseif shot==2
    st_fr=123;
end
% %-- Load matching result txt file
% txtPath = '/home/kegao/Files/Research/Feature_Matching/ABQ_Result/';
txtPath = sprintf('/Volumes/E/vmz_new/VIRAT1_6/Files/BA/%s/shot%d/',p,shot);
addpath(txtPath);
% fileName = 'matches';
fileName = sprintf('%d_Points', shot);
fileNameExt = strcat(fileName, '.txt');
matches = load(fileNameExt);

%% find longest tracks
tracks=matches(:,4);
[ count, unique_tracks]=hist(tracks, unique(tracks));
sorted_tracks=sortrows([count;unique_tracks']', 1);
no_unique=size(sorted_tracks, 1);
large_20_tracks=sorted_tracks(no_unique-20:no_unique, 2);
Total_tracks=count
Longest_track=mode(tracks(:))
Longest_track_length=sum(tracks(:)== Longest_track)


%% calculate track lengths
unique_tracks=unique_tracks';
for i=1:length(unique_tracks)
    row_id=find(matches(:,4)==unique_tracks(i));
    trackL(i)=length(row_id);    
end


%% calculate track frequency
freq=zeros(size(trackL));
for i=1:length(trackL)
    freq(trackL(i))=freq(trackL(i))+1;
end

%% remove later freqs with all zero
lastNonzeroFreq=length(freq);
for i=length(freq):-1:1
    if freq(i)==0 || freq(i)==1        
    else
        lastNonzeroFreq=i;
        break;
    end
end




% %-- Load image sequence
% imgPath = '/home/kegao/Files/Research/Dataset/TS_Albq_oneOrbit_smapled_originalImageSize/';
% imgPath = '/home/kegao/Files/Research/Dataset/TS_ABQ_215_Render_Shell_r1_s0_5/';
imgPath = sprintf('/Volumes/E/VIRAT1_6_Output_BA/Files/frame/shot%d/', shot);
addpath(imgPath);
imgFile = fullfile(imgPath, '*.png');
imgDir = dir(imgFile);

% % %-- Load down-sampled image sequence
% imgPath = '/home/kegao/Desktop/Research/Dataset/TS_ABQ215_pgm_DownSampled';
% addpath(imgPath);
% imgFile = fullfile(imgPath, '*.pgm');
% imgDir = dir(imgFile);

% %-- Set save path
% outPath = '/home/kegao/Files/Research/Feature_Matching/Track_Visualize/TS_ABQ_215_matches_RenderR1S05_cudasift/';
%outPath = sprintf('/Volumes/E/BA/VIRAT1_6/Files/BA/shot%d/tracks_%s/', shot,p);
outPath = sprintf('/Volumes/E/vmz_new/VIRAT1_6/Files/BA/%s/shot%d/Tracks/',p,shot);

outPath2=sprintf('/Volumes/E/vmz_new/VIRAT1_6/Files/BA/%s/Plots/',p);
mkdir(outPath2);

bar(freq(1:lastNonzeroFreq))
print(sprintf('%sTrackLen_shot%d_%s', outPath2, shot,p), '-dpng')


minTrack=min(trackL(:));
medRef=median(trackL(:));
firstQ=quantile(trackL,0.25);
thirdQ=quantile(trackL,0.75) ; 
maxTrack=max(trackL(:));


figure
plot(trackL)

figure
boxplot(trackL, 'Whisker', 9999, 'orientation', 'horizontal');
ylabel('Track Length'); title(strcat('shot: ', num2str(shot), '  (', p, ')'));
set(gca, 'YScale', 'log');
print(sprintf('%swhiskerPlot_shot%d_%s', outPath2, shot,p), '-dpng')


text(minTrack,1.15,'\downarrow');
text(minTrack,1.25,sprintf('%d',minTrack));

text(firstQ,1.15,'\downarrow');
text(firstQ,1.25,sprintf('%d',firstQ));


text(medRef,1.15,'\downarrow');
text(medRef,1.25,sprintf('%d',medRef));


text(thirdQ,1.15,'\downarrow');
text(thirdQ,1.25,sprintf('%d',thirdQ));


text(maxTrack,1.15,'\downarrow');
text(maxTrack,1.25,sprintf('%d',maxTrack));


x=1;


% boxplot(trackL);
% ylabel('Track Length');
% set(gca, 'YScale', 'log');title(strcat('shot: ', num2str(shot), '  (', p, ')'));
% print(sprintf('%swhiskerPlot_shot%d_%s_outliers', outPath2, shot,p), '-dpng')


% %% whisker plot for track lengths
% minTrack=min(trackL(:));
% medRef=median(trackL(:));
% firstQ=quantile(trackL,0.25);
% thirdQ=quantile(trackL,0.75) ; 
% maxTrack=max(trackL(:));
% y=[minTrack firstQ medRef thirdQ maxTrack];
% bar(y);
% set(gca, 'XTickLabel', {'Min (Q0)', '25% (Q1)', 'Median (Q2)', '75% (Q3)', 'Max (Q4)'});
% for i1=1:numel(y)
%     text(i1,y(1,i1)+1,num2str(y(i1),'%0.0f'),...
%                'HorizontalAlignment','center',...
%                'VerticalAlignment','bottom')
% end
% print(sprintf('%swhiskerPlot_shot%d_%s', outPath2, shot,p), '-dpng')
% %%----------------------------------------------------

% %-- Sort according to the last column (track ID)1
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
[~, order2] = sort(tracks(:,2));
tracksSortLength = tracks(order2,:);

% %-- Compute max, mean, and stddev of tracks' length
trackMax = max(tracksSortLength(:,2));
trackAvg = mean(tracksSortLength(:,2));
trackStd = std(tracksSortLength(:,2));

% %-- Visualize each track
bBoxRadius = 195;
% for i0 = 1:length(tracksSortLength)
large_20_tracks=sort(large_20_tracks);
for t=large_20_tracks'
    i0=t;
    
    X1 = ['Track: ', num2str(i0)];
    disp(X1);
    folderName = 'Track';
    if (i0 < 10)
        folderName = strcat(folderName, '00', num2str(i0));
    elseif (i0 >= 10 && i0 < 100)
        folderName = strcat(folderName, '0', num2str(i0));
    else
        folderName = strcat(folderName, num2str(i0));
    end
    %track = find( matchSortID(:,4)==tracksSortLength(i0,1) );
    row_id=find(matches(:,4)==i0)
    if length(row_id)<2
        continue;
    end
    frame_id=matches(row_id, 1)
    mkdir(outPath, folderName);
    
    for i1 = row_id' %rumana%%1:length(track)
        
        X3 = ['Frame: ', num2str(i1), '/', num2str(length(row_id))];
        disp(X3);
        imgIdx=matches(i1, 1);%rumana%%imgIdx = matchSortID(track(i1),1) + 1; %%
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
        rowIdx=round(matches(i1, 3))+1;%rumana%rowIdx = round(matchSortID(track(i1),3)) + 1; 
        colIdx=round(matches(i1, 2))+1;%rumana%colIdx = round(matchSortID(track(i1),2)) + 1;
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
        
        imgROI = insertText(imgROI, [bBoxRadius+10 bBoxRadius], num2str(matches(i1, 5)));
        imgROI = insertText(imgROI, [10 10], num2str(imgIdx+st_fr));
        
        if (i0 < 10)
            saveName = strcat(outPath, folderName, '/', 'Track_00', num2str(i0), '_', imgDir(imgIdx).name, '.png');
        elseif (i0 >= 10 && i0 < 100)
            saveName = strcat(outPath, folderName, '/', 'Track_0', num2str(i0), '_', imgDir(imgIdx).name, '.png');
        elseif (i0 >= 100 )
            saveName = strcat(outPath, folderName, '/', 'Track_', num2str(i0), '_', imgDir(imgIdx).name, '.png');
        end
        imwrite(imgROI, saveName);
    end
end












