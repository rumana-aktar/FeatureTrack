%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% track_all_start_end: this program takes a BA file as input and find out
% starting and ending frame for every track
% ending frame no
% input: one BA file for all frames with 4 columns (FrameIDs X Y trackID)
%        no is not important here     
% output: unique_tracks: all unique tracks sorted  
%         starts: returns starting frame number for  unique_tracks
%         ends: returns ending frame number for unique_tracks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [unique_tracks, starts, ends]=track_all_start_end(file, no)
    [largest_tracks, unique_tracks]=getTrackNumbers(file, no);
    starts=[];
    ends=[];
    unique_tracks=unique_tracks';
    
    matches = load(file);
    tracks=matches(:,4);
    for i=1:size(unique_tracks,1)
        i
        rows=find(tracks==unique_tracks(i,1));
        frames=matches(rows, 1);
        starts=[starts; min(frames)];
        ends=[ends; max(frames)];
    end
end