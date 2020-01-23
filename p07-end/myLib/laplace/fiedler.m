function [eigenValues] = fiedler(laplace)
eigenValues = eig(laplace);
eigenValues(eigenValues < 1E-10) = 0;
end

