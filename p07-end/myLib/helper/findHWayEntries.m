function [hEntries] = findHWayEntries(shape, A)
hEntries = [];
nRoads = size(shape, 1);
for j = 1:nRoads
    segment = shape(j);
    % We are at a highway
    if segment.CLASS <= 3
        %Startnodes
        neighs = find(A(j, :));
        for k = 1:size(neighs, 2)
            % A neighbour is a local road
            neigh = neighs(k);
            index = mod(neigh, nRoads);
            if (index == 0)
                index = nRoads;
            end
            if (shape(index).CLASS > 3)
                hEntries = [hEntries, j];
                break;
            end
        end
        %Endnodes
        neighs = find(A(j + nRoads, :));
        for k = 1:size(neighs, 2)
            neigh = neighs(k);
            index = mod(neigh, nRoads);
            if (index == 0)
                index = nRoads;
            end
            if (shape(index).CLASS > 3)
                hEntries = [hEntries, j + nRoads];
                break;
            end
        end   
    end
end
end