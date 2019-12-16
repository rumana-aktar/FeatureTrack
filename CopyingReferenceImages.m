%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program takes a bA file as input and shows largest 1000 tracks on
% frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clc; clear;

%% --variables

rootDir='/Volumes/E/Output_1.28/VIRAT2_8_RefIntv_200/Files/';
imgDir='/Volumes/F/Data/VIRAT_Tape/09152008flight2tape2_8/';
files = dir(fullfile(imgDir,sprintf('%s*.%s','Fr','png')));
shotBoundaryList=dlmread([rootDir,'SB/shot_boundary.txt']); 
outdir=sprintf('%s/ReferenceImagesAnnotated/',rootDir); mkdir(outdir);
img_no=0;
allRefs=[];
    
for shot=1:size(shotBoundaryList, 1)
    shot
    ReferenceList=dlmread(sprintf('%sHomographies/shot%d/%d_ReferenceList.txt',rootDir, shot, shot));
    allRefs=[allRefs ReferenceList(:,1)'];
    for i=ReferenceList(:,1)'
        i
        I = imread( fullfile(imgDir, files(i).name) );
        I = insertText(uint8(I), [720, 1], sprintf('%04d', i), 'AnchorPoint', 'RightTop','BoxColor', 'red', 'TextColor', 'white', 'fontSize', 20);
        %saveName = strcat(outdir, files(i).name);
        saveName=sprintf('%sFrame_%06d.png',outdir, img_no);        
        imwrite(uint8(I), saveName); 
        img_no=img_no+1;
    end
end

numbers=zeros(size(files,1),1);
numbers(allRefs)=1;

close all
figure('Color',[1 1 1],'Position', [100, 100, 1049, 200]);     
ax=bar(numbers);
xlabel('Frame No.')
xlim([1 size(files,1)])
set(gca,'Ytick',0:1:1);
print(sprintf('%sTrace/ReferencesB', rootDir), '-dpng')
   
close all
figure('Color',[1 1 1],'Position', [100, 100, 1049, 200]);     
ax=bar(numbers, 'EdgeColor', 'magenta','FaceColor', 'magenta');
xlabel('Frame No.')
xlim([1 size(files,1)])
set(gca,'Ytick',0:1:1);
print(sprintf('%sTrace/ReferencesM', rootDir), '-dpng')
   


