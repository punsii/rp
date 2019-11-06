function idx =  p2pShape(x, y, shape)
dMin = inf;
for j = 1 : size(shape, 1)
    for k = 1 : size(shape(j).X, 2)
        d = getDistance([shape(j).X(k), shapefile(j).Y(k)], [x, y]);
        if (d < dMin)
            idx = [j, k];
            dMin = d;
        end
    end
end
end