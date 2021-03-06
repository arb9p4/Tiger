function offset = MissAnalysis(alarmLoc, alarmConf, targetList, confuserScore, halo, meshTriData, meshTriNormData, meshTriDirData)

    s = size(alarmLoc);
    
    targetLoc = zeros(length(targetList),2);
    
    for i=length(targetList):-1:1
        switch(confuserScore(targetList(i).targetCategory))
            case 0
                targetLoc(i,:) = [targetList(i).center.east; targetList(i).center.north];
            case 1
                targetLoc(i,:) = [];
            case 2
                targetLoc(i,:) = [targetList(i).center.east; targetList(i).center.north];
        end
    end
    
    offset = zeros(s(1),2);
%    laneOrthogAll = zeros(3*s(1),2);
    
    %find the orthogonal basis for each target.  This could be moved
    %earlier in the processing chain to reduce computation.
    laneOrthog = zeros(3*length(targetList),2);
    for i=1:size(targetLoc,1)
        laneOrthog((i-1)*3+1:(i-1)*3+3,:) = LaneOrthogonal(targetLoc(i,:), meshTriData, meshTriNormData, meshTriDirData);
    end

    for i=s(1):-1:1
        offsetTemp = [alarmLoc(i,1) - targetLoc(:,1), alarmLoc(i,2)-targetLoc(:,2)];
        dist = sqrt(sum(offsetTemp.*offsetTemp,2));
        
        [~, minInd] = min(dist);
        
        minVec = offsetTemp(minInd,:);
        
%        laneOrthog = LaneOrthogonal(targetLoc(minInd,:), meshTriData, meshTriNormData, meshTriDirData);
        
%        laneOrthogAll((i-1)*3+1:(i-1)*3+3,:) = laneOrthog((minInd-1)*3+1:(minInd-1)*3+3,:);
        
        offset(i,:) = [dot(laneOrthog(1,:),minVec), dot(laneOrthog(2,:),minVec)];
    end
    
    