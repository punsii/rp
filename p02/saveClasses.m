% CLASS 1 Limited access highway
% CLASS 2 Multi-lane highway, not limited access
% CLASS 3 Other numbered route
% CLASS 4 Major road - collector
% CLASS 5 Minor street or road
% CLASS 6 Minor street or road
% CLASS 7 Highway ramp
% 76   111	 138   953   1177  334  6

for j = 1:7
    filename = sprintf('%s%d','matFiles\boston_transformed_c', j);
    class = shaperead('boston_roads.shp',...
        'Selector',{@(v1) (v1 == j),'CLASS'});
    
    fprintf('%d %3d %%\n',j , 0);
    for k = 1:length(class)
        if (mod(k, 100) == 0)
            %Deletes last line
            %([3 digits, space, %, newline] = 6 chars)
            fprintf(repmat('\b', 1, 6)); 
            fprintf('%3d %%\n', ceil(k/length(class) * 100));
        end
        [class(k).Y, class(k).X] = projinv(mstruct, [class(k).X], [class(k).Y]);
    end
    fprintf(repmat('\b', 1, 6)); 
    fprintf('%3d %%\n', 100);
    
    save(filename, 'class');
    fprintf('Saved class %d to %s\n', j, filename)
end
