close all; clc; clear;

%% --variables
for fr=2:6
    fr
shot = 1; %fr=6;
dataset='trees';
rootDir=sprintf('/Volumes/E/Oxford_dataset/%s_output/Files/Homographies/Frame1_%d/',dataset, fr);
keys1=load(sprintf('%skeys1.txt', rootDir));
keys2=load(sprintf('%skeys2.txt', rootDir));
matching=load(sprintf('%smatchings.txt', rootDir));

outDir=sprintf('/Volumes/E/Oxford_dataset/%s_output/Files/BA/shot%d/ASIFT/',dataset, shot);
fileDir1=sprintf('%sshot%d_Features/', outDir, shot); mkdir(fileDir1);
fileDir2=sprintf('%sshot%d_Matching/', outDir, shot); mkdir(fileDir2);

match=matching(:, 1:4);

curXY=[match(:,1)'; match(:,2)';]';
dlmwrite(sprintf('%simg%d_features.txt',fileDir1, fr), curXY);

curXYXY=[match(:,3)'; match(:,4)'; match(:,1)'; match(:,2)';]';
dlmwrite(sprintf('%simg%d_features.txt',fileDir2, fr), curXYXY);

if fr==2
    curXY=[match(:,3)'; match(:,4)';]';
    dlmwrite(sprintf('%simg%d_features.txt',fileDir1, 1), curXY);
end


end

