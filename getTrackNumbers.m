%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name: getTrackNumbers.m
%
%  Description: given BA files in txt and a number N, returns largest N
%  tracks from the file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [large_20_tracks, unique_tracks]=getTrackNumbers(fileNameExt, no)

% %-- Load matching result txt file
matches = load(fileNameExt);

%% find longest tracks
tracks=matches(:,4);
[ count, unique_tracks]=hist(tracks, unique(tracks));
sorted_tracks=sortrows([count;unique_tracks']', 1);
no_unique=size(sorted_tracks, 1);
large_20_tracks=sorted_tracks(no_unique-no:no_unique, 2);
Total_tracks=count;
Longest_track=mode(tracks(:));
Longest_track_length=sum(tracks(:)== Longest_track);


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

end

