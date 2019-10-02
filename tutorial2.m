% info = geotiffinfo('boston.tif');
% disp(info);
% disp(info.PCS);
% disp(info.Projection);
% disp(info.UOMLength);
% disp(info);
% 
[boston, R] = geotiffread('boston.tif');
% mapshow(boston, R)
% axis image
% title('Boston')
% 
roads = shaperead('boston_roads');
% R.XWorldLimits = R.XWorldLimits * unitsratio('m','sf');
% R.YWorldLimits = R.YWorldLimits * unitsratio('m','sf');
% figure
% mapshow(boston, R)
% mapshow(roads)
% title('Boston and Roads')

filename = 'boston_ovr.jpg';
overview = imread(filename);
overviewR = worldfileread(getworldfilename(filename), 'geographic', size(overview));
mstruct = geotiff2mstruct(info);
latlim = overviewR.LatitudeLimits;
lonlim = overviewR.LongitudeLimits;figure('Renderer', 'opengl')
ax = axesm(mstruct, 'Grid', 'on',...
'GColor', [.9 .9 .9], ...
'MapLatlimit', latlim, 'MapLonLimit', lonlim, ...
'ParallelLabel', 'on', 'PLabelLocation', .025, 'PlabelMeridian', 'west', ...
'MeridianLabel', 'on', 'MlabelLocation', .05, 'MLabelParallel', 'south', ...
'MLabelRound', -2, 'PLabelRound', -2, ...
'PLineVisible', 'on', 'PLineLocation', .025, ...
'MLineVisible', 'on', 'MlineLocation', .05);
geoshow(overview, overviewR)
axis off
tightmap
title({'Boston and Surrounding Region', 'Geographic Coordinates'})
mapshow(boston, R)
plot(R.XWorldLimits([1 1 2 2 1]), R.YWorldLimits([1 2 2 1 1]), 'Color', 'red')
title({'Boston and Surrounding Region', 'Geographic and Projected Coordinates'})
delta = 1000;
xLimits = R.XWorldLimits + [-delta delta];
yLimits = R.YWorldLimits + [-delta delta];
xlim(ax,xLimits)
ylim(ax,yLimits)
setm(ax, 'Grid', 'off');

roadColors = makesymbolspec('Line',...
 {'CLASS', 2, 'Color', 'k'}, ...
 {'CLASS', 3, 'Color', 'g'},...
 {'CLASS', 4, 'Color', 'magenta'}, ...
 {'CLASS', 5, 'Color', 'cyan'}, ...
 {'CLASS', 6, 'Color', 'b'},...
 {'Default', 'Color', 'k'});
mapshow(roads, 'SymbolSpec', roadColors)
title({'Boston and Surrounding Region','Including Boston Roads'})

placenames = gpxread('boston_placenames');
geoshow(placenames, 'Marker','o', 'MarkerSize', 6, ...
'MarkerEdgeColor', 'y', 'MarkerFaceColor','y')
title({'Boston and Surrounding Region','Including Boston Roads and Placenames'});

