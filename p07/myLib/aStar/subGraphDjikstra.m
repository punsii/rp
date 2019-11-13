function [in, out] = subGraphDjikstra(adj_matrix, startNode)
%A_STAR returns a list of indices that correspond to the shortest path

%% Constants
G = 1;  % dist to start
PREV = 2; % needed for path

M = size(adj_matrix, 1);

%% Init Variables
% L(G, X, Y, PREV)
L = [inf(M, 1), zeros(M, 1)];
closed = false(M, 1);
open = zeros(0, 2);

open(1, :) = [startNode, 0]; % h is not needed for the startNode
L(startNode, G) = 0;
L(startNode, PREV) = startNode; 

hold on;
%% main loop
while (~(isempty(open)))
    [~, idx] = sort(open(:, 2));
    open = open(idx, :);
    
    current = open(1, 1);
    neigh = find(adj_matrix(current, :));
    for j = neigh(~closed(neigh))
        if (j == current)
            continue
        end
        newDist = L(current, G) + adj_matrix(current, j);
        if (newDist < L(j, G))
            L(j, G) = newDist;
            L(j, PREV) = current;
        end
        open = [open; j, L(j, G)];
    end
    open(open(:, 1) == current, :) = [];
    closed(current) = true;
end

in = find(closed);
out = find(closed == 0);
end