oBufSize = inf;
forceHighway = true;

draw = true;
contDraw = false;
makeMovie = false;
movieName = "aStarTMP";

realMap = true;

%% Load
% 'A_all', 'L_all', 'nodeDistanceThreshhold'
load('matFiles/boston_matrix_all.mat')
L = L_all;
A = A_all;
% 'local'
load('matFiles\boston_transformed_all.mat')
map = all;

if (forceHighway)
    % 'A_highway', 'L_highway', 'nodeDistanceThreshhold'
    load('matFiles/boston_matrix_highway.mat')
    % 'highway'
    load('matFiles\boston_transformed_highway.mat')

    % 'A_local', 'L_local', 'nodeDistanceThreshhold'
    load('matFiles/boston_matrix_local.mat')
    % 'local'
    load('matFiles\boston_transformed_local.mat')
end
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
    
    if (forceHighway)
        mapshow(highway);
        tic;
        hEntries = findHWayEntries(all, A);
        hWayEnter = hEntries(p2pNode(L(start, 1), L(start, 2), L(hEntries, :)));
        hWayExit = hEntries(p2pNode(L(target, 1), L(target, 2), L(hEntries, :)));
        
        % get index in corresponding sub shapefiles.
        startLocal = p2pNode(L(start, 1), L(start, 2), L_local);
        targetLocal = p2pNode(L(target, 1), L(target, 2), L_local);
        hWayEnterLocal = p2pNode(L(hWayEnter, 1), L(hWayEnter, 2), L_local);
        hWayExitLocal = p2pNode(L(hWayExit, 1), L(hWayExit, 2), L_local);
        hWayEnterHighway = p2pNode(L(hWayEnter, 1), L(hWayEnter, 2), L_highway);
        hWayExitHighway = p2pNode(L(hWayExit, 1), L(hWayExit, 2), L_highway);
        
        [r1, o1, c1, p1] = aStar(A_local, L_local, startLocal, hWayEnterLocal, ...
            oBufSize, draw, contDraw, makeMovie, strcat(movieName, 'p1'));
        [r2, o2, c2, p2] = aStar(A_highway, L_highway, hWayEnterHighway, hWayExitHighway, ...
            oBufSize, draw, contDraw, makeMovie, strcat(movieName, 'p2'));
        [r3, o3, c3, p3] = aStar(A_local, L_local, hWayExitLocal, targetLocal, ...
            oBufSize, draw, contDraw, makeMovie, strcat(movieName, 'p3'));
        t = toc;
        disp(t);
        route = [r1, r2, r3];
        opened = [o1; o2; o3];
        closed = [c3; c2; c3];
        tmpPlots = [tmpPlots, p1, p2, p3];
    else
        tic;
        [route, opened, closed, aStarPlots] = ...
            aStar(A, L, start, target, oBufSize, ...
                draw, contDraw, makeMovie, movieName);
        t = toc;
        disp(t);
        tmpPlots = [tmpPlots, aStarPlots];
    end

    if (~draw)
        opened = opened(:, 1);
        % visited spots
        j = L([find(closed); opened], :);
        tmpPlots = [tmpPlots, ...
            scatter(j(:, 1), j(:, 2), 20, ...
            'MarkerFaceColor', 'g', ...
            'MarkerEdgeColor', 'k', ...
            'LineWidth', 1)];

        % route
        j = L(route, :);
        tmpPlots = [tmpPlots, ...
            plot(j(:, 1), j(:, 2), 'm', 'LineWidth', 3)];
    end
    
    uiwait(msgbox('New Route?'));
    delPlots(tmpPlots);
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