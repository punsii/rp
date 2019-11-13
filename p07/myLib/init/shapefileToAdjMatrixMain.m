nodeDistanceThreshhold = 0.00003;

load('../../matFiles/boston_transformed_all.mat') %loads 'all'
[A_all, L_all] = shapefileToAdjMatrix(all, nodeDistanceThreshhold);
save('../../matFiles/boston_matrix_all.mat', 'A_all', 'L_all', 'nodeDistanceThreshhold');

load('../../matFiles\boston_transformed_highway.mat') %loads 'highway'
[A_highway, L_highway] = shapefileToAdjMatrix(highway, nodeDistanceThreshhold);
save('../../matFiles/boston_matrix_highway.mat', 'A_highway', 'L_highway', 'nodeDistanceThreshhold');

load('../../matFiles\boston_transformed_local.mat') %loads 'local'
[A_local, L_local] = shapefileToAdjMatrix(local, nodeDistanceThreshhold);
save('../../matFiles/boston_matrix_local.mat', 'A_local', 'L_local', 'nodeDistanceThreshhold');

function [A, L] = shapefileToAdjMatrix(roads, nodeDistanceThreshhold)

% CLASS 1 Limited access highway
% CLASS 2 Multi-lane highway, not limited access
% CLASS 3 Other numbered route
% CLASS 4 Major road - collector
% CLASS 5 Minor street or road
% CLASS 6 Minor street or road
% CLASS 7 Highway ramp
% speeds = [130, 130, 130, 50, 30, 30, 40];

% L = Tabelle mit Start und Endknoten
% indices in L und A: erste haelfte Startknoten, zweite haelfte Endknoten
nRoads = length(roads);
nNodes = nRoads * 2;
A = zeros(nNodes);
L = zeros(nNodes, 2);


for j = 1:length(roads)
    % Save start and endnode of each segment in L
    L(j, :) = [roads(j).X(1), roads(j).Y(1)];
    L(j + nRoads, :) = [roads(j).X(end-1), roads(j).Y(end-1)];
    
    % Save distance in A
    d = calcDistance(L(j, :), L(j + nRoads, :));
%     w = d / speeds(roads(j).CLASS);
    A(j, j + nRoads) = d; %w for travel time;
    A(j + nRoads, j) = d;
end

% Nahe Punkte sind Kreuzung -> kurze Kante!
for j = 1:nNodes-1
    for k = j:nNodes
        if(calcDistance(L(j,:), L(k,:)) < nodeDistanceThreshhold)
            A(j, k) = nodeDistanceThreshhold;
            A(k, j) = nodeDistanceThreshhold;
        end
    end
end
end