close all; clc; clear;

%% --variables
shot = 1;
rootDir='/Volumes/E/Oxford_dataset/bark_output/Files/';

%% --get point correspondances
file = sprintf('%s/BA/shot%d/%d_Points.txt', rootDir, shot, shot);
% 
% %--get shot boundary information
% shotBoundaryList=dlmread([rootDir,'SB/shot_boundary.txt']); 
% 
% %--get image directory
% imgDir='/Volumes/F/Data/VIRAT_Tape/09152008flight2tape1_6/';
% files = dir(fullfile(imgDir,sprintf('%s*.%s','Fr','png')));
% %--output location
fileDir1=sprintf('%sBA/shot%d/shot%d_Features/', rootDir, shot, shot); mkdir(fileDir1);
fileDir2=sprintf('%sBA/shot%d/shot%d_Matching/', rootDir, shot, shot); mkdir(fileDir2);

data=load(file);
frames=unique(data(:, 1))

for fr=1:size(frames,1)
    fr
    curFrIdx=find(data(:,1)==fr);
    curData=data(curFrIdx, :);
    curXY=data(curFrIdx, [1 2]);
    dlmwrite(sprintf('%simg%d_features.txt',fileDir1, fr), curXY);
    x=1;
end

refFrIdx=find(data(:,1)==1);
refData=data(refFrIdx, :);
for fr=2:size(frames,1)
    fr
    curFrIdx=find(data(:,1)==fr);
    curData=data(curFrIdx, :);
    
    comRefDataID=ismember(refData(:,4)',curData(:,4)');
    comRefDataID=find(comRefDataID);

    comCurDataID=ismember(curData(:,4)', refData(:,4)');
    comCurDataID=find(comCurDataID);

    
    refDataCommon=refData(comRefDataID', :);
    refDataCommon= sortrows(refDataCommon, 4);
    
    curDataCommon=curData(comCurDataID', :);
    curDataCommon= sortrows(curDataCommon, 4);
    
    curXYXY=[refDataCommon(:,2)'; refDataCommon(:,3)'; curDataCommon(:,2)'; curDataCommon(:,3)']';
    %curXYXY=[refDataCommon(:,2)'; refDataCommon(:,3)'; curDataCommon(:,2)'; curDataCommon(:,3)'; refDataCommon(:,4)'; curDataCommon(:,4)';]';

    
    dlmwrite(sprintf('%simg%d_features.txt',fileDir2, fr), curXYXY);
    x=1;
end

