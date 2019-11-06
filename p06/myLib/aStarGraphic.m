function [route, open, closed] = a_star(adj_matrix, cords, startNode, endNode, oBufSize, map, contDraw)
%A_STAR returns a list of indices that correspond to the shortest path

%% Constants
F = 1;  % G + H
G = 2;  % dist to start
H = 3;  % dist to end (aproximation)
X = 4;  % cords
Y = 5;  % cords
PREV = 6; % needed for path

M = size(adj_matrix, 1);

%% Init Variables
% L(F, G, H, X, Y, PREV)
L = [inf(M, 3), cords, zeros(M, 1)];
closed = false(M, 1);
open = zeros(0, 2);
route = [];

open(1, :) = [startNode, 0]; % h is not needed for the startNode
L(startNode, G) = 0;
L(startNode, PREV) = startNode; 

%% Init Plots
close all;
% figure('units','normalized','outerposition', [0 0 1 1]);
% hold on;
mapshow(map)
hold on;
% Contourplot
x = linspace(-71.12, -71.03, 50);
y = linspace(42.34, 42.375, 50);
[Xtmp, Ytmp] = meshgrid(x,y);
Z = zeros(50);
% Z = (Xtmp+71.08).^2 + (Ytmp-42.355).^2;
for xin = 1:50
    for yin = 1:50
        Z(yin, xin) = log(calcDistance([x(xin), y(yin)], L(startNode, X:Y)) +...
            calcDistance([x(xin),y(yin)], L(endNode, X:Y)));
    end
end
contour(Xtmp,Ytmp,Z)

%start and end
plot(L(startNode, X), L(startNode, Y), 'rx', 'LineWidth', 15);
plot(L(endNode, X), L(endNode, Y), 'bx', 'LineWidth', 15);
drawnow();

%% main loop
while (~(isempty(open) || closed(endNode)))
    [~, idx] = sort(open(:, 2));
    open = open(idx, :);
    if (size(open, 1) > oBufSize)
        open = open(1:oBufSize, :);
    end
    
    current = open(1, 1);
    neigh = find(adj_matrix(current, :));
    for j = neigh(~closed(neigh))
        if (j == current)
            continue
        end
        % check if distance to end has already been calculated
        if (L(j, H) == inf)
            L(j, H) = calcDistance(L(endNode, X:Y), L(j, X:Y));
        end
        
        % calc h and f
        % compare to current h and f of this node
        newDist = L(current, G) + adj_matrix(current, j);
        if (newDist < L(j, G))
            L(j, G) = newDist;
            L(j, PREV) = current;
            L(j, F) = L(j, G) + L(j, H);
        end
        open = [open; j, L(j, F)];
        plot(L(j, X), L(j, Y), 'ko', 'LineWidth', 2); %Plot reached point
        if (contDraw)
            drawnow();
        end
    end
    open(open(:, 1) == current, :) = [];
    closed(current) = true;
    plot(L(current, X), L(current, Y), 'g.', 'MarkerSize', 15);
end

%% reconstruct path

tmpRoute(1) = endNode;
current = endNode;
while (current ~= startNode)
    prev = L(current, PREV);
    if (prev == 0)
        disp('Could not reach end Node!')
        return
    end
    tmpRoute = [tmpRoute, prev];
    current = prev;    
end

route = flip(tmpRoute);
plot(L(route, X), L(route, Y), 'm', 'LineWidth', 3);

hold off;
end


%% PLOTS
% reached
% for i = [find(closed); find(open)]
%   tmp = reachedPlot;
%   reached = plot(L(i,1), L(i,2), 'k.', 'MarkerSize', 20);
%   delete(tmp);
% end

% % route
% for i = route
%     plot(L(i,1), L(i,2), 'g.', 'MarkerSize', 10);
% end

% start and target
% plot(L(start, 1), L(start, 2), 'rx', 'LineWidth', 15);
% plot(L(target,1), L(target, 2), 'bx', 'LineWidth', 15);
% end