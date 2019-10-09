function [returnCode] = calcWorldFile(picPoints, geoPoints, path)
    if length(size(picPoints)) ~= 2 ...
            | size(picPoints, 2) ~= 2 ...
            | size(picPoints, 1) < 3 ...
            | size(picPoints) ~= size(geoPoints)
        returnCode = -1;
        return
    end
    
    nPoints = size(picPoints, 1); 
    % we want to solve for a in Xa = t
    t = zeros(nPoints * 2, 1);
    X = zeros(nPoints * 2, 6);
    for j = 1:nPoints
        %Fill Matricies X and t
        X(2 * j - 1, :) = [picPoints(j, 1), picPoints(j, 2), 1, 0, 0, 0];
        X(2 * j, :)     = [0, 0, 0, picPoints(j, 1), picPoints(j, 2), 1];
        t(2 * j - 1) = geoPoints(j, 1);
        t(2 * j)     = geoPoints(j, 2);
    end
    a = t\X; %shortcut for linsolve
    FID = fopen(path, 'w+');
    fprintf(FID, '%f\n', a);
    return
end