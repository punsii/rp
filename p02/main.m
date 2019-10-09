roads = shaperead('boston_roads.shp');
info = geotiffinfo('boston.tif');
mstruct = geotiff2mstruct(info);

fprintf('%3d %%\n', 0);
for j = 1:length(roads)
    if (mod(j, 100) == 0)
        %Deletes last line
        %([3 digits, space, %, newline] = 6 chars)
        fprintf(repmat('\b', 1, 6)); 
        fprintf('%3d %%\n', ceil(j/length(roads) * 100));
    end
    [roads(j).Y, roads(j).X] = projinv(mstruct, [roads(j).X], [roads(j).Y]);
end

figure
geoshow('resources/myBoston_resized.jpg');
mapshow(roads);
% Work it, Make it, Do it, Makes us
% [lat, lon] = projinv(mstruct, [roads.X], [roads.Y]);
% geoshow(lat, lon);