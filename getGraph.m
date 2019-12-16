%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name: getGraph.m
%  input: file with points correspondances: frID, X, Y, trckID and output
%  location
%  output: plot of trackLength-vs-Frequency and whisker plot with numbers
%  for trackLength
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function getGraph(matches, outDir, shot, all_ST)

    if (all_ST==1); str= 'all ST'; else; str= 'all NCC';  end;
    
    tracks=matches(:,4);
    [ count, unique_tracks]=hist(tracks, unique(tracks));
    
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
    freq(lastNonzeroFreq+1:end)=[];
    
    
    
    %--statistics
    minTrack=min(trackL(:));
    medRef=median(trackL(:));
    firstQ=quantile(trackL,0.25);
    thirdQ=quantile(trackL,0.75) ; 
    maxTrack=max(trackL(:));

    
    %--print fraquency vs track length
    subplot(2,1,1),bar(freq);
    set(gca, 'YScale', 'log');
    title(strcat('TrackLength-vs-Frequency, shot: ', num2str(shot), ', points: ', str));
   
    %--print whisker plot of trackLengths
    subplot(2,1,2),boxplot(trackL, 'Whisker', 9999, 'orientation', 'horizontal');
    xlabel('Track Length'); set(gca, 'XScale', 'log');
    title('Whisker plot of Track Length');
   
    
    %--specify colros for Q0, Q1, Q2, Q3, Q4
    color1=[0 0 1];
    color2=[0 0 1];
    
    %--put numbers
    text(minTrack,1.15,'\downarrow', 'Color', color1);
    text(minTrack,1.25,sprintf('%d',minTrack),'Color', color1);
    
    text(firstQ,0.88,'\uparrow','Color', color1);
    text(firstQ,0.78,sprintf('%d',firstQ),'Color', color1);
    
    text(medRef,1.15,'\downarrow','Color', color2);
    text(medRef,1.25,sprintf('%d',medRef),'Color', color2);
    
    text(thirdQ,0.88,'\uparrow','Color', color2);
    text(thirdQ,0.78,sprintf('%d',thirdQ),'Color', color2);
    
    text(maxTrack,1.15,'\downarrow','Color', color1);
    text(maxTrack-280,1.25,sprintf('%d',maxTrack),'Color', color1);
    
    %--save grapg
    mkdir(strcat(outDir, 'BA_Graphs/'));
    print(strcat(outDir, 'BA_Graphs/track_', num2str(shot)), '-dpng')
    
    
    x=1;





end