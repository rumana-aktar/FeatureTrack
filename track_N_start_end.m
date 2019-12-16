%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% track_N_start_end: this program takes a BA file as input and find out
% largest tracks according to lengths and for every track, its starting and
% ending frame no
% input: one BA file for all frames with 4 columns (FrameIDs X Y trackID)
%        if no==1000, that means we are finding largest 1000 tracks        
% output: largest_tracks: top n=1000 (or any no of tracks) sorted  
%         starts: returns starting frame number for  largest_tracks
%         ends: returns ending frame number for largest_tracks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [largest_tracks, starts, ends]=track_N_start_end(file, no)
    [largest_tracks, unique_tracks]=getTrackNumbers(file, no);
    starts=[];
    ends=[];
    
    matches = load(file);
    tracks=matches(:,4);
    for i=1:size(largest_tracks,1)
        i
        rows=find(tracks==largest_tracks(i,1));
        frames=matches(rows, 1);
        starts=[starts; min(frames)];
        ends=[ends; max(frames)];
    end
end