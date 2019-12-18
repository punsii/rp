function [route, opened, closed, plots, dist] = aStar(adj_matrix, cords, startNode, endNode, oBufSize, drawDots, drawResult, contDraw, makeMovie, movieName)
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
if (drawDots && makeMovie)
    file = strcat("matFiles/videos/", movieName);
    vWriter = VideoWriter(file);
    vWriter.FrameRate = 10;
    open(vWriter)
end
% L(F, G, H, X, Y, PREV)
L = [inf(M, 3), cords, zeros(M, 1)];
closed = false(M, 1);
opened = zeros(0, 2);
route = [];

opened(1, :) = [startNode, 0]; % h is not needed for the startNode
L(startNode, G) = 0;
L(startNode, PREV) = startNode;

plots = [];
%% main loop
while (~(isempty(opened) || closed(endNode)))
    [~, idx] = sort(opened(:, 2));
    opened = opened(idx, :);
    if (size(opened, 1) > oBufSize)
        opened = opened(1:oBufSize, :);
    end

    current = opened(1, 1);
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
        opened = [opened; j, L(j, F)];
        if (drawDots)
            plots = [plots, ...
                plot(L(j, X), L(j, Y), 'ko', 'LineWidth', 1)]; %Plot reached point
            if (contDraw)
                drawnow();
            end
            if (makeMovie)
                writeVideo(vWriter, getframe(gcf));
            end
        end
    end
    opened(opened(:, 1) == current, :) = [];
    closed(current) = true;

    if(drawDots)
        plots = [plots, ...
            plot(L(current, X), L(current, Y), 'g.', 'MarkerSize', 15)];
    end
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
if(drawResult)
    plots = [plots, plot(L(route, X), L(route, Y), 'm', 'LineWidth', 3)];
    if (makeMovie)
        writeVideo(vWriter, getframe(gcf));
        close(vWriter);
    end
end

dist = L(endNode, G);
end
