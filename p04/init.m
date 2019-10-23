nodeDistanceThreshhold = 20;

load('matFiles/boston_transformed_all.mat') %loads 'all'
[A_all, L_all] = shapefileToAdjMatrix(all, nodeDistanceThreshhold);
save('matFiles/boston_matrix_all.mat', 'A_all', 'L_all', 'nodeDistanceThreshhold');

load('matFiles\boston_transformed_highway.mat') %loads 'highway'
[A_highway, L_highway] = shapefileToAdjMatrix(highway, nodeDistanceThreshhold);
save('matFiles/boston_matrix_highway.mat', 'A_highway', 'L_highway', 'nodeDistanceThreshhold');

load('matFiles\boston_transformed_local.mat') %loads 'local'
[A_local, L_local] = shapefileToAdjMatrix(local, nodeDistanceThreshhold);
save('matFiles/boston_matrix_local.mat', 'A_local', 'L_local', 'nodeDistanceThreshhold');