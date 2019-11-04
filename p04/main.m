%% Load
load('matFiles/boston_matrix_all.mat') % 'A_all', 'L_all', 'nodeDistanceThreshhold'
L = L_all;
A = A_all;
load('matFiles\boston_transformed_all.mat')
map = all;

% load('matFiles/boston_matrix_highway.mat') % 'A_highway', 'L_highway', 'nodeDistanceThreshhold'
% L = L_highway;
% A = A_highway;
% load('matFiles\boston_transformed_local.mat')
% map = highway;

% load('matFiles/boston_matrix_local.mat') % 'A_local', 'L_local', 'nodeDistanceThreshhold'
% L = L_local;
% A = A_local;
% load('matFiles\boston_transformed_local.mat')
% map = local;

oBufSize = 1000;
start = 10;
%650
target = 3462;
%3462
%900

%% Main
[route, open, closed] = aStarGraphic(A, L, start, target, oBufSize, map);

disp(route)
disp(calcDistance(L(start, :), L(target, :)))

% %% Plot
% close all;
% figure('units','normalized','outerposition', [0 0 1 1]);
% hold on;
% % plotting order determines what is drawn on top!
% mapshow(map)
% % testShapefile(A, L, nodeDistanceThreshhold);
% 
% % reached
% for i = [find(closed); find(open)]
%     plot(L(i,1), L(i,2), 'k.', 'MarkerSize', 20);
% end
% 
% % route
% for i = route
%     plot(L(i,1), L(i,2), 'g.', 'MarkerSize', 10);
% end
% 
% % start and target
% plot(L(start, 1), L(start, 2), 'rx', 'LineWidth', 15);
% plot(L(target,1), L(target, 2), 'bx', 'LineWidth', 15);
% hold off;