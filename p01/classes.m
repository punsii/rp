type('boston_roads.txt')
%  CLASS 1 Limited access highway
%  CLASS 2 Multi-lane highway, not limited access
%  CLASS 3 Other numbered route
%  CLASS 4 Major road - collector
%  CLASS 5 Minor street or road
%  CLASS 6 Minor street or road
%  CLASS 7 Highway ramp

roads = shaperead('boston_roads.shp');
histcounts([roads.CLASS],'BinLimits',[1 7],'BinMethod','integer')
% 76   111	 138   953   1177  334  6

for k = 1:7
    filename = sprintf('%s%d','boston_roads_class_', k);
    class = shaperead('boston_roads.shp',...
        'Selector',{@(v1) (v1 == k),'CLASS'});
    save(filename, 'class');
    sprintf('Saved class %d to %s', k, filename)
end
