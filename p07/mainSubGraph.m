%% Load
% 'A_all', 'L_all', 'nodeDistanceThreshhold'
% load('matFiles/boston_matrix_all.mat')
% L = L_all;
% A = A_all;
% % 'local'
% load('matFiles\boston_transformed_all.mat')
% map = all;

% % 'A_highway', 'L_highway', 'nodeDistanceThreshhold'
load('matFiles/boston_matrix_highway.mat')
L = L_highway;
A = A_highway;
% 'highway'
load('matFiles\boston_transformed_highway.mat')
map = highway;

% % 'A_local', 'L_local', 'nodeDistanceThreshhold'
% load('matFiles/boston_matrix_local.mat')
% L = L_local;
% A = A_local;
% % 'local'
% load('matFiles\boston_transformed_local.mat')
% map = local;

startNode = 10;

[in, out] = subGraphDjikstra(A, startNode);

mapshow(map);
hold on;
scatter(L(in, 1), L(in, 2), 20, ...
    'MarkerFaceColor', 'g', ...
    'MarkerEdgeColor', 'k', ...
    'LineWidth', 1);
scatter(L(out, 1), L(out, 2), 20, ...
    'MarkerFaceColor', 'r', ...
    'MarkerEdgeColor', 'k', ...
    'LineWidth', 1);
disp(out);