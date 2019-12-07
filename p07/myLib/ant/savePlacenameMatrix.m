shaperead('boston_placenames.shp');

%% Transform placenameCords to WorldCords
info = geotiffinfo('boston.tif');
mstruct = geotiff2mstruct(info);
filename = 'matFiles\boston_transformed_placenames';
names = shaperead('boston_placenames.shp');

for j = 1:length(names)
    [names(j).Y, names(j).X] = projinv(mstruct, [names(j).X], [names(j).Y]);
end

%% Calculate Matrix

n = size(names, 1);

% 'A_all', 'L_all', 'kdTreeAll', 'nodeDistanceThreshhold'
load('matFiles/boston_matrix_all.mat');
originalA = A_all;
originalL = L_all;

nPoints = zeros(n, 1);
for j = 1:n
    nPoints(j) = p2pNode(names(j).X, names(j).Y, originalL);
end

A_placenames = zeros(n);
for j = 1:n-1
    for k = j+1:n
        [~, ~, ~, ~, dist] = aStar(originalA, originalL, nPoints(j), nPoints(k), inf, ...
                false, false, false, "");
        A_placenames(j, k) = dist;
        A_placenames(k, j) = dist;
    end
end

save(filename, 'names', 'A_placenames');
fprintf('Saved placenames and AdjMatrix to %s\n', filename)
    