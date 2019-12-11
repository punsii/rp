function finalTour = ant(points, A, nIter, alpha, beta, delta, rho, contDraw)

n = size(points, 1);
P = ones(n) * 0.5; % PheromonValues
H = 1./A; % Heuristik

finalTour = zeros(n, 1);
tmpPlots = [];
for t = 1:nIter
    fprintf('%d\n', t);
    minTour = zeros(n, 1);
    minDist = inf;
    for a = 1:n
        [tour, dist] = calcAntTour(a, A, H, P, alpha, beta);
        if dist < minDist
            minTour = tour;
        end
        if (contDraw || (t == nIter))
            tmpPlots = [tmpPlots, ...
                plotTour(tour, P, points, 'blue')];
        end
    end
    if(contDraw || t == nIter)
        tmpPlots = [tmpPlots, ...
            plotTour(tour, P, points, 'green')];
    end
    if (contDraw)
        drawnow();
    end
    if t == nIter
        finalTour = minTour;
        tmpPlots = [tmpPlots, ...
            plotTour(minTour, P, points, 'red')];
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
    delPlots(tmpPlots)
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
            color, 'LineWidth', minWidth + log(P(tour(i), tour(i+1)) + 1))];
    end
    %last line segments
    plots = [plots, ...
      plot([vertices(end, 1), vertices(1, 1)],  [vertices(end, 2), vertices(1, 2)], ...
        color, 'LineWidth', minWidth + log(P(tour(i), tour(i+1)) + 1))];
end