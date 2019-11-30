function [L] = laplaceDelEdge(L, j, k)
%LAPLACEDELEDGE Delete an edge from L-matrix representation of a graph
L(j, k) = 0;
L(k, j) = 0;
L(j, j) = L(j, j) - 1;
L(k, k) = L(k, k) - 1;
end