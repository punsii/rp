load('matFiles/boston_matrix_all.mat') % 'A_all', 'L_all', 'nodeDistanceThreshhold'

load('matFiles/boston_matrix_highway.mat') % 'A_highway', 'L_highway', 'nodeDistanceThreshhold'

load('matFiles/boston_matrix_local.mat') % 'A_local', 'L_local', 'nodeDistanceThreshhold'

testShapefile(A_all, L_all, 20);