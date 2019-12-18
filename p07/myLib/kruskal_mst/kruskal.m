function [mst] = kruskal(A)
% Wähle Kante mit niedrigstem gewicht
% Wenn neue Kante keinen Kreis formt -> gehört zum mst
% Ansonsten verwerfen

nNodes = size(A, 1);
nEdges = (nNodes * (nNodes - 1)) / 2;
mst = zeros(nNodes, nNodes);

IDs = linspace(1, nNodes, nNodes);

% edges = [i, j, weight]
edges = zeros(nEdges, 3);
count = 1;
for j = 1:nNodes-1
    for k = j+1:nNodes
        edges(count, :) = [j, k, A(j, k)];
        count = count + 1;
    end
end
[~, idx] = sort(edges(:, 3));
edges = edges(idx, :);

while ~isempty(edges)
   j = edges(1, 1);
   k = edges(1, 2);
   
   if IDs(j) ~= IDs(k)
       w = edges(1, 3);
       IDs(IDs == k) = j;
       mst(j, k) = w;
       mst(k, j) = w;
   end
   
   edges(1, :) = [];
end
disp('a');

