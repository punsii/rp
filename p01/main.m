for s = ["highway", "local", "all"]
    load(s);
    figure;
    title(s)
    mapshow(lon, lat);
    %geoshow(lat, lon);
end