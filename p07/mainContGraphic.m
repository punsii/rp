
oBufSize = inf;
contDraw = false;
makeMovie = true;
movieName = "aStar01.avi";
realMap = false;

%% Load
% 'A_all', 'L_all', 'nodeDistanceThreshhold'
load('matFiles/boston_matrix_all.mat')
L = L_all;
A = A_all;
% 'local'
load('matFiles\boston_transformed_all.mat')
map = all;

% % 'A_highway', 'L_highway', 'nodeDistanceThreshhold'
% load('matFiles/boston_matrix_highway.mat')
% L = L_highway;
% A = A_highway;
% % 'highway'
% load('matFiles\boston_transformed_local.mat')
% map = highway;

% % 'A_local', 'L_local', 'nodeDistanceThreshhold'
% load('matFiles/boston_matrix_local.mat')
% L = L_local;
% A = A_local;
% % 'local'
% load('matFiles\boston_transformed_local.mat')
% map = local;

% start = 10;
% %650
% target = 3462;
% %3462
% %900

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
    geoshow('resources/myBoston_resized.jpg');
    plot([xRange(1), xRange(1), xRange(2), xRange(2)], ...
         [yRange(1), yRange(2), yRange(2), yRange(1)], ...
         'r--');
end
drawnow();

tmpPlots = [];
%% Main
while true
    txt = text(xRange(1), yRange(1), "Choose a start point");
    [x, y] = ginput(1);
    delete(txt);
    start = p2pNode(x, y, L);
    tmpPlots = [tmpPlots, ...
        plot(L(start, 1), L(start, 2), 'rx', 'LineWidth', 15)];
    
    txt = text(xRange(1), yRange(1), "Choose an end point");
    [x, y] = ginput(1);
    delete(txt);
    target = p2pNode(x, y , L);
    tmpPlots = [tmpPlots, ...
        plot(L(target, 1), L(target, 2), 'bx', 'LineWidth', 15)];
    
    tmpPlots = [tmpPlots, ...
        contPlot(L(start, :), L(target, :), xRange, yRange, 50)];
    drawnow();

    [route, open, closed, aStarPlots] = ...
        aStarGraphic(A, L, start, target, oBufSize, contDraw, makeMovie, movieName);
    tmpPlots = [tmpPlots, aStarPlots];
    
    uiwait(msgbox('New Route?'));
    delPlots(tmpPlots);

%     disp(route)
%     disp(calcDistance(L(start, :), L(target, :)))
end

function plot = contPlot(p1, p2, xRange, yRange, contRes)
    x = linspace(xRange(1), xRange(2), contRes);
    y = linspace(yRange(1), yRange(2), contRes);
    [Xtmp, Ytmp] = meshgrid(x,y);
    Z = zeros(contRes);
    for xin = 1:contRes
        for yin = 1:contRes
            Z(yin, xin) = log(calcDistance([x(xin), y(yin)], p1) +...
                calcDistance([x(xin),y(yin)], p2));
        end
    end
    [~, plot] = contour(Xtmp,Ytmp,Z);
end

function delPlots(plots)
    for j = 1:length(plots)
        delete(plots(j))
    end
end