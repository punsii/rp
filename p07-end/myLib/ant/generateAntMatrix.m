function A = generateAntMatrix(points, originalA, originalL)
n = size(points, 2);
A = zeros(n); % Distanzen aller Verbindungen

for j = 1:n-1
    for k = j+1:n
        [~, ~, ~, ~, dist] = aStar(originalA, originalL, points(j), points(k), inf, ...
                false, false, false, "");
        A(j, k) = dist;
        A(k, j) = dist;
    end
end
end

