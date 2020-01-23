function [route, dist] = calcAntTour(route, A, H, P, beta, alpha)
open = true(size(A, 1), 1);
dist = 0;

current = route;
open(current) = false;
while ~isempty(find(open, 1))
    options = find(open);
    PHValues = P(current, options) .^ alpha .* H(current, options) .^ beta;
    PHValues(PHValues == inf) = realmax;
    weights = PHValues ./ sum(PHValues);
    last = current;
    current = datasample(options, 1, 'Weights', weights);
    
    dist = dist + A(last, current);
    route = [route, current];
    
    open(current) = false;
end
dist = dist + A(route(end), route(1));
end

