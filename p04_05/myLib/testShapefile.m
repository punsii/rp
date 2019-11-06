function [] = testShapefile(A, L, nodeDistanceThreshhold)

[rows, cols, elements] = find(A);
for j = 1:length(rows)
    if (elements(j) == nodeDistanceThreshhold)
        plot(L(cols(j),1), L(cols(j),2), 'rx');
    else
        mapshow([L(cols(j),1), L(rows(j),1)], [L(cols(j),2), L(rows(j),2)]);
    end
end
end