function []= init_shapefile()
    info = geotiffinfo('boston.tif');
    mstruct = geotiff2mstruct(info);
    
    highway = shaperead('boston_roads.shp',...
        'Selector',{@(v1) (v1 <= 3),'CLASS'});
    [lat, lon] = projinv(mstruct, [highway.X], [highway.Y]);
    save('highway', 'lat', 'lon');
    disp('Saved class highway.');
    
    local = shaperead('boston_roads.shp',...
        'Selector',{@(v1) (v1 >= 4),'CLASS'});
    [lat, lon] = projinv(mstruct, [local.X], [local.Y]);
    save('local', 'lat', 'lon');
    disp('Saved class local.');
    
    all = shaperead('boston_roads.shp');
    [lat, lon] = projinv(mstruct, [all.X], [all.Y]);
    save('all', 'lat', 'lon');
    disp('Saved class all.');
end
