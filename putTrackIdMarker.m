function I=putTrackIdMarker(I, clist, tracks, bBoxRadius, frameNumber)
    
    %--MAKE BOX WITH TRACK NO
    [m, n, ~]=size(I);
    col_space=floor(((n-20)/size(clist,1)));
    textPos=[];
    rID=m-20; cID=20; 
    
    texts=[tracks; frameNumber];
    framePos=[n-50 5];
    
    for i=1:size(clist,1)
        I(rID-bBoxRadius:rID+bBoxRadius, cID-bBoxRadius:cID+bBoxRadius, 1) = clist(i, 1);
        I(rID-bBoxRadius:rID+bBoxRadius, cID-bBoxRadius:cID+bBoxRadius, 2) = clist(i, 2);
        I(rID-bBoxRadius:rID+bBoxRadius, cID-bBoxRadius:cID+bBoxRadius, 3) = clist(i, 3);   
        textPos=[textPos; cID+bBoxRadius*2 rID-10 ];
        cID=cID+col_space;         
    end
    textPos=[textPos; framePos];
    I = insertText(uint8(I), textPos, texts, 'AnchorPoint', 'LeftTop');
        
end