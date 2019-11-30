function [L] = createLaplace(A)
%CREATELAPLACE calculates a laplace matrix from a adjacenzy matrix
n = size(A, 1);
L = zeros(n);
% Non-diagonal
for j = 1:n
    for k = j+1:n
        if (A(j, k) > 0)
            L(j, k) = -1;
            L(k, j) = -1;
        end
    end
    % Diagonal needs to be the negative sum of the rest of the row
    L(j, j) = size(find(L(j, :)), 2); 
end

