%% Preparation
fprintf('Preparing Matrices...\n')
load('matFiles\boston_transformed_all.mat', 'all')
map = all;
load('matFiles/boston_matrix_all.mat', 'L_all', 'A_all')

% pointIndices = [20, 106, 607, 1279, 2203, 2281, 3217, 3333, 4253, 4423, 5001];
pointIndices = [20, 30, 40, 50, 60, 80];
points = L(pointIndices, :);
A = generateAntMatrix(pointIndices, A_all, L_all);
fprintf('Done\n')

fprintf('Calculating Kruskal MST...\n')
mst = kruskal(A)
fprintf('Done\n')