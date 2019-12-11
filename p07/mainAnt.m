%% Define Constants
nIter = 100;
rho = 0.05; % prozentual Abnahme des PWertes je Iteration.
alpha = 1; % Gewichtung der Distanz-Heuristik
beta = 2;   % Gewichtung des PWertes


realMap = true;
contDraw = true;
usePlacenames = false;

%% Preparation
fprintf('Preparing Matrices...\n')
load('matFiles\boston_transformed_all.mat', 'all')
map = all;

if ~usePlacenames 
    load('matFiles/boston_matrix_all.mat', 'A_all', 'L_all')
%     pointIndices = [607, 1279, 2203, 2281, 3217, 4253, 4423];
    pointIndices = [607, 2203, 2281, 3217, 4253, 4423];
    points = L_all(pointIndices, :);
    A = generateAntMatrix(pointIndices, A_all, L_all);
else
    load('matFiles/boston_transformed_placenames.mat', 'A_placenames', 'names');
    A = A_placenames;
    points = transpose([names.X; names.Y]);   
end
fprintf('Done\n')

%% Init Plots
fprintf('Plotting map now...\n');
xRange = [min(L(:, 1)), max(L(:, 1))];
yRange = [min(L(:, 2)), max(L(:, 2))];

close all;
figure;
mapPlot = mapshow(map);
hold on;
if (realMap)
    ax = gca;
    delete(mapPlot);
    ratio = (ax.XLim(2) - ax.XLim(1)) / (ax.YLim(2) - ax.YLim(1));
    axis([xRange, yRange]);
    pbaspect([1, ratio, 1]);
    geoshow('resources/bostonNew.jpg');
    plot([xRange(1), xRange(1), xRange(2), xRange(2)], ...
         [yRange(1), yRange(2), yRange(2), yRange(1)], ...
         'r--');
end
plot(points(:, 1), points(:, 2), 'rx', 'LineWidth', 3, 'MarkerSize', 10);
drawnow();
fprintf('Done\n')

fprintf('Starting ants...');
ant(points, A, nIter, alpha, beta, rho, contDraw);