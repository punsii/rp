function idx =  p2pNode(x, y, L)
dMin = inf;
for j = 1 : size(L, 1)
    d = calcDistance(L(j, :), [x, y]);
    if (d < dMin)
        idx = j;
        dMin = d;
    end
end
end