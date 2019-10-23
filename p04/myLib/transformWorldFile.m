calcWorldFile(...    
    [...
        1616,   1207; ...
        29  ,   1077; ...
        72  ,   220 ; ...
        1727,   43  ; ...
        827 ,   459 ; ...
    ], ...
    [ ...
        42.310398, -70.977099; ...
        42.319045, -71.120392; ...
        42.376249, -71.115752; ...
        42.387917, -70.966682; ...
        42.360188, -71.047661; ...
    ], ...
    'resources/myBoston_resized.jgw' ...
)

info = geotiffinfo('boston.tif');
mstruct = geotiff2mstruct(info);
for j = 1:7
    filename = sprintf('%s%d','mat_files\boston_roads_geo_class_', j);
    class = shaperead('boston_roads.shp',...
        'Selector',{@(v1) (v1 == k),'CLASS'});
    for k = 1:length(class)
        [class(k).Y, class(k).X] = projinv(mstruct, [class(k).X], [class(k).Y]);
    end
    save(filename, 'class');
    sprintf('Saved class %d to %s', k, filename)
end



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
    % where a is a vector with the 6 parameters for the affinetransform
    % in the order (a11, a21, a12, a22, b1, b1)
    t = zeros(nPoints * 2, 1);
    X = zeros(nPoints * 2, 6);
    for j = 1:nPoints
        %Fill Matricies X and t
        X(2 * j - 1, :) = [picPoints(j, 1), 0, picPoints(j, 2), 0, 1, 0];
        X(2 * j, :)     = [0, picPoints(j, 1), 0, picPoints(j, 2), 0, 1];
        t(2 * j - 1) = geoPoints(j, 1);
        t(2 * j)     = geoPoints(j, 2);
    end
    a = X\t; %shortcut for linsolve
    fid = fopen(path, 'w+');
    fprintf(fid, '%.12f\n', a);
    fclose(fid);
    disp('X');
    disp(X);
    disp('a');
    disp(a);
    disp('t');
    disp(t);
    return
end