%% Define Constants
nIter = 500;
alpha = 1;  % Gewichtung der Distanz-Heuristik
beta = 0.6;   % Gewichtung des PWertes
delta = 10;  % Konstante für addition
rho = 0.1;  % prozentual Abnahme des PWertes je Iteration.


realMap = true;
contDraw = false;
usePlacenames = false;

%% Preparation
fprintf('Preparing Matrices...\n')
load('matFiles\boston_transformed_all.mat', 'all')
map = all;
load('matFiles/boston_matrix_all.mat', 'L_all', 'A_all')
L = L_all;

if ~usePlacenames 
    pointIndices = [20, 106, 607, 1279, 2203, 2281, 3217, 3333, 4253, 4423, 5001];
%     pointIndices = [20, 30, 40, 50, 60, 80];
    points = L(pointIndices, :);
    A = generateAntMatrix(pointIndices, A_all, L);
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

%% Main

fprintf('Starting ants...\n');
finalTour = ant(points, pointIndices, A, A_all, L, nIter, alpha, beta, delta, rho, contDraw);
fprintf('Done\n');

fprintf('Plotting final result...\n');
for j = 1:length(finalTour)-1
    aStar(A_all, L_all, pointIndices(finalTour(j)), pointIndices(finalTour(j+1)),...
        inf, false, true, false, false, "");
end
aStar(A_all, L_all, pointIndices(finalTour(end)), pointIndices(finalTour(1)),...
    inf, false, true, false, false, "");
fprintf('Done\n');    