function [route, open, close] = a_star(adj_matrix, cords, startNode, endNode)
%A_STAR returns a list of indices that correspond to the shortest path

%% Constants
F = 1;  % G + H
G = 2;  % dist to start
H = 3;  % dist to end (aproximation)
X = 4;  % cords
Y = 5;  % cords
PREV = 6; % needed for path

M = size(adj_matrix, 1);

%% Init
% L(F, G, H, X, Y, PREV)
L = [inf(M, 3), cords, zeros(M, 1)];
close = false(M, 1);
open = false(M, 1);
route = zeros(0,0);

open(startNode) = true;
L(startNode, G) = 0;
L(startNode, PREV) = startNode;

%% main loop
while (~(isempty(find(open, 1)) || close(endNode)))
    tmp = int8(L(:, F) & open);
    tmp(tmp<=0) = inf;
    [~, current] = min(tmp);
    neigh = find(adj_matrix(current, :));
    for j = neigh(~close(neigh))
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
        open(j) = true;
    end
    open(current) = false;
    close(current) = true;
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
