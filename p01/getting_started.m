close all;
%% Teilaufgabe 1
roadColors = makesymbolspec('Line',...
 {'CLASS', 1, 'Color', 'r'}, ...
 {'CLASS', 2, 'Color', 'g'}, ...
 {'CLASS', 3, 'Color', 'm'},...
 {'CLASS', 4, 'Color', 'b'}, ...
 {'CLASS', 5, 'Color', 'k'}, ...
 {'CLASS', 6, 'Color', 'y'},...
 {'CLASS', 7, 'Color', 'c'});
shapeRoads = shaperead('boston_roads.shp');
figure
mapshow(roads, 'SymbolSpec', roadColors);

%% Teilaufgabe 2
% read is actually not needed here ...
[tifRoads, R] = geotiffread('boston.tif');
% figure
% mapshow(tifRoads, R);

info = geotiffinfo('boston.tif');
mstruct = geotiff2mstruct(info);
[lat, lon] = projinv(mstruct, [shapeRoads.X], [shapeRoads.Y]);

figure
geoshow(lat, lon);