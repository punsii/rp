function [route, open, closed] = aStar(adj_matrix, cords, startNode, endNode, oBufSize)
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

hold on;
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
    end
    open(open(:, 1) == current, :) = [];
    closed(current) = true;
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
end