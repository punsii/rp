nIter = 100;
rho = 0.1; % prozentual Abnahme des PWertes je Iteration.
alpha = 1; % Gewichtung der Distanz
beta = 1;   % Gewichtung des PWertes

realMap = true;
usePlacenames = true; 
if ~usePlacenames 
    % 'A_all', 'L_all', 'kdTreeAll', 'nodeDistanceThreshhold'
    load('matFiles/boston_matrix_all.mat')
    A = A_all;
    L = L_all;
    points = L([607, 1279, 2203, 2281, 3217, 4253, 4423], :);
end

% 'all'
load('matFiles\boston_transformed_all.mat')
map = all;


%% init plots
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
drawnow();

if usePlacenames
    ant(nIter, rho, alpha, beta);
else
    ant(nIter, rho, alpha, beta, points, A, L);
end