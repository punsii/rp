function finalTour = ant(points, pointIndices, A, A_all, L, nIter, alpha, beta, delta, rho, contDraw)

n = size(points, 1);
P = ones(n) * 0.5; % PheromonValues
H = 1./A; % Heuristik

finalTour = zeros(n, 1);
finalDist = inf;
tmpPlots = [];
noImprovementCounter = 0;
for t = 1:nIter
    alpha = alpha * (1 - 0.5/nIter);
%     fprintf('%d\n', t);
    minTour = zeros(n, 1);
    minDist = inf;
    for a = 1:n
        [tour, dist] = calcAntTour(a, A, H, P, alpha, beta);
        if dist < minDist
            minTour = tour;
            minDist = dist;
        end
        if (contDraw || (t == nIter))
            tmpPlots = [tmpPlots, ...
                plotTour(tour, P, points, 'blue')];
        end
    end
    if(contDraw || t == nIter)
        for j = 1:length(minTour)-1
            [~,~,~,plot] = aStar(A_all, L, pointIndices(minTour(j)), pointIndices(minTour(j+1)),...
                inf, false, true, false, false, "");
            tmpPlots = [tmpPlots, plot];
        end
        [~,~,~,plot] = aStar(A_all, L, pointIndices(minTour(end)), pointIndices(minTour(1)),...
            inf, false, true, false, false, "");
        tmpPlots = [tmpPlots, plot];
    end
    if (contDraw)
        drawnow();
    end
    if minDist < finalDist
        finalTour = minTour;
        finalDist = minDist;
        noImprovementCounter = 0;
    else
        noImprovementCounter = noImprovementCounter + 1;
    end
    if noImprovementCounter > 20
        delPlots(tmpPlots);
        break;
    end
    
    % Evaporation
    P = (1-rho) .* P;
    % Intensification
    for j = 2:n
        a = minTour(n-1);
        b = minTour(n);
        P(a, b) = P(a, b) + delta;
        P(b, a) = P(a, b);
    end
    % Stop starvation
    P(P < 0.001) = 0.001;
%     disp(P(1,:))
    delPlots(tmpPlots);
end
end

function delPlots(plots)
    for j = 1:length(plots)
        delete(plots(j))
    end
end

function plots = plotTour(tour, P, points, color)
    plots = [];
    minWidth = 0.05;
    
    vertices = points(tour, :);
    for i = 1:length(vertices)-1    %-1 because you're plotting by line segment 
        plots = [plots, plot(vertices(i:i+1, 1), vertices(i:i+1, 2), ...
            color, 'LineWidth', minWidth + sqrt(P(tour(i), tour(i+1))))];
    end
    %last line segments
    plots = [plots, ...
      plot([vertices(end, 1), vertices(1, 1)],  [vertices(end, 2), vertices(1, 2)], ...
        color, 'LineWidth', minWidth + log(P(tour(i), tour(i+1)) + 1))];
end