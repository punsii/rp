roads = 0;
info = geotiffinfo('boston.tif');
mstruct = geotiff2mstruct(info);

for j = 1:7
    filename = sprintf('%s%d','matFiles\boston_transformed_c', j);
    load(filename); %loads the variable 'class'
    if j == 1
        roads = class;
    else
        roads = [roads; class];
    end
end

figure
geoshow('resources/myBoston_resized.jpg');
mapshow(roads);
% Work it, Make it, Do it, Makes us
% [lat, lon] = projinv(mstruct, [roads.X], [roads.Y]);
% geoshow(lat, lon);