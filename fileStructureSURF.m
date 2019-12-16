clc; clear;warning off;

%%--features from vmz Reference_to_Base.m is produced and rewritten in
%%appropritae forms here
%%---rewrite in appropriate form, from frame6 to frame1(xi, yi, x1, y1)


for fr=2:6

    dataset='boat';
    if fr~=2
        dataDir=sprintf('/Volumes/E/Oxford_dataset/%s_output/Files/Homographies/SURF/Points%d_1.txt', dataset, fr);
    else
        dataDir=sprintf('/Volumes/E/Oxford_dataset/%s_output/Files/Homographies/SURF/Points1_%d.txt', dataset, fr);    
    end
    data=load(dataDir);
    
    outDir1=sprintf('/Volumes/E/Oxford_dataset/%s_output/Files/BA/shot1/SURF/shot1_Features/',dataset); mkdir(outDir1);
    outDir2=sprintf('/Volumes/E/Oxford_dataset/%s_output/Files/BA/shot1/SURF/shot1_Matching/',dataset); mkdir(outDir2);
    file1=sprintf('%simg%d_features.txt',outDir1, fr);
    file2=sprintf('%simg%d_img1_matches.txt',outDir2, fr);

    %%--readData
    features=data(:, 1:2);
    matches=data;
    
    dlmwrite(file1, features);
    dlmwrite(file2, matches);

    if fr==2
        file1=sprintf('%simg%d_features.txt',1);
        features=data(:, 3:4);
    end

end



% fr=2;
% imgDir='/Volumes/E/Oxford_dataset/boat/';
% files = dir(fullfile(imgDir,sprintf('img*.%s', 'pgm')));
% data=sprintf('/Volumes/E/Oxford_dataset/boat_output/Files/Homographies/SURF/Points1_%d.txt', fr);
% matches=load(data);
% 
% I1 = imread( fullfile(imgDir, files(fr).name) ); 
% I2 = imread( fullfile(imgDir, files(1).name) );
% 
% xy1=matches(:, 1:2); %%--corresponds to fr
% xy2=matches(:, 3:4); %%--corresponds to 1
% 
% figure, imshow(uint8(I1));hold on;
% plot(xy1(:, 1), xy1(:, 2), 'r*');
% 
% 
% figure, imshow(uint8(I2));hold on;
% plot(xy2(:, 1), xy2(:, 2), 'r*');
% 
% 
% 
% %% --variables
% for fr=2:6
%     fr
% shot = 1; %fr=6;
% dataset='trees';
% rootDir=sprintf('/Volumes/E/Oxford_dataset/%s_output/Files/Homographies/Frame1_%d/',dataset, fr);
% keys1=load(sprintf('%skeys1.txt', rootDir));
% keys2=load(sprintf('%skeys2.txt', rootDir));
% matching=load(sprintf('%smatchings.txt', rootDir));
% 
% outDir=sprintf('/Volumes/E/Oxford_dataset/%s_output/Files/BA/shot%d/ASIFT/',dataset, shot);
% fileDir1=sprintf('%sshot%d_Features/', outDir, shot); mkdir(fileDir1);
% fileDir2=sprintf('%sshot%d_Matching/', outDir, shot); mkdir(fileDir2);
% 
% match=matching(:, 1:4);
% 
% curXY=[match(:,1)'; match(:,2)';]';
% dlmwrite(sprintf('%simg%d_features.txt',fileDir1, fr), curXY);
% 
% curXYXY=[match(:,3)'; match(:,4)'; match(:,1)'; match(:,2)';]';
% dlmwrite(sprintf('%simg%d_features.txt',fileDir2, fr), curXYXY);
% 
% if fr==2
%     curXY=[match(:,3)'; match(:,4)';]';
%     dlmwrite(sprintf('%simg%d_features.txt',fileDir1, 1), curXY);
% end
% 
% 
% end
% 


