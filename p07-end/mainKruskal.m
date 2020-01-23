%% Preparation
fprintf('Preparing Matrices...\n')
load('matFiles\boston_transformed_all.mat', 'all')
map = all;
load('matFiles/boston_matrix_all.mat', 'L_all', 'A_all')

pointIndices = [42, 84, 126, 57, 168, 4903, 1234, 4567, 72, 3333, 5010, 1213, 794, 2030];
% pointIndices = [20, 106, 607, 1279, 2203, 2281, 3217, 3333, 4253, 4423, 5001];
% pointIndices = [20, 30, 40, 50, 60, 80];
nPoints = size(pointIndices, 2);
points = L_all(pointIndices, :);
A = generateAntMatrix(pointIndices, A_all, L_all);
fprintf('Done\n')

fprintf('Calculating Kruskal MST...\n')
mst = kruskal(A);
fprintf('Done\n')

%% Init Plots
fprintf('Plotting...\n')
xRange = [min(L_all(:, 1)), max(L_all(:, 1))];
yRange = [min(L_all(:, 2)), max(L_all(:, 2))];

close all;
figure;
mapPlot = mapshow(map);
hold on;
ax = gca;
delete(mapPlot);
ratio = (ax.XLim(2) - ax.XLim(1)) / (ax.YLim(2) - ax.YLim(1));
axis([xRange, yRange]);
pbaspect([1, ratio, 1]);
geoshow('resources/bostonNew.jpg');
plot([xRange(1), xRange(1), xRange(2), xRange(2)], ...
     [yRange(1), yRange(2), yRange(2), yRange(1)], ...
     'r--');
plot(points(:, 1), points(:, 2), 'rx', 'LineWidth', 3, 'MarkerSize', 10);
drawnow();

%% Plot mst

for j = 1:nPoints-1
    for k = j+1:nPoints
        if mst(j, k) > 0
            aStar(A_all, L_all, pointIndices(j), pointIndices(k),...
                inf, false, true, false, false, "");
        end
    end
end
fprintf('Done\n')