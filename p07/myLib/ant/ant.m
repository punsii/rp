function bestRoute = ant(nIter, rho, alpha, beta, points, originalA, originalL)
%% init
% Use Placenames if no points are given
if ~exists(points)
    load('matFiles/boston_transformed_placenames.mat', 'A_placenames', 'names');
    A = A_placenames;
    points = transpose([names.X; names.Y]);
else
    A = generateAntMatrix(points, originalA, originalL);
end

n = size(points, 2);
P = ones(n) * 0.5; % PheromonValues

bestTour = zeros(n);
for t = 1:nIter
    for a = 1:n
        calcAntTour(i, P, A, rho, alpha, beta)
    end
    Vergleichen um aktuell beste Tour zu finden
    Update der Pheromone
end
end