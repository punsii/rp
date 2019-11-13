%% Load
% % 'A_all', 'L_all', 'nodeDistanceThreshhold'
% load('matFiles/boston_matrix_all.mat')
% L = L_all;
% A = A_all;
% % 'local'
load('matFiles\boston_transformed_all.mat')
map = all;

% 'A_highway', 'L_highway', 'nodeDistanceThreshhold'
load('matFiles/boston_matrix_highway.mat')
% 'highway'
load('matFiles\boston_transformed_local.mat')

% 'A_local', 'L_local', 'nodeDistanceThreshhold'
load('matFiles/boston_matrix_local.mat')
% 'local'
load('matFiles\boston_transformed_local.mat')

% start = 10;
% %650
% target = 3462;
% %3462
% %900
oBufSize = 100;

%% init plots
close all;
mapPlot = mapshow(map);
hold on;
xRange = [min(L(:, 1)), max(L(:, 1))];
yRange = [min(L(:, 2)), max(L(:, 2))];
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

    hWayEnter = closestHWay(start, all);
    hWayExit = closestHWay(target, all);
    
    [r1, o1, c1] = aStar(A_local, L_local, start, hWayEnter, oBufSize);
    [r2, o2, c2] = aStar(A_highway, L_highway, hWayEnter, hWayExit, oBufSize);
    [r3, o3, c3] = aStar(A_local, L_local, hWayExit, target, oBufSize);
    route = [r1; r2; r3];
    open = [o1; o2; o3];
    closed = [c3; c2; c3];
    disp(t);
    open = open(:, 1);
    
    % visited spots
    j = L([find(closed); open], :);
    tmpPlots = [tmpPlots, ...
        scatter(j(:, 1), j(:, 2), 20, ...
        'MarkerFaceColor', 'g', ...
        'MarkerEdgeColor', 'k', ...
        'LineWidth', 1)];

    % route
    j = L(route, :);
    tmpPlots = [tmpPlots, ...
        plot(j(:, 1), j(:, 2), 'm', 'LineWidth', 3)];
    
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