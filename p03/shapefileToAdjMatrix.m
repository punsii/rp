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
A = zeros(2 * nRoads);
L = zeros(2 * nRoads, 2);


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
for j = 1:nRoads-1
    for k = j:nRoads
        if(calcDistance(L(j,:), L(k,:)) < nodeDistanceThreshhold)
            A(j, k) = nodeDistanceThreshhold;
            A(k, j) = nodeDistanceThreshhold;
        end
    end
end
end