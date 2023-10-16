% Point Projection on set X
function projected_point = projection(point, constraint)
    projected_point = zeros(1,2);
    
    % for the x_1 coordinate
    if point(1) < constraint(1,1)
        projected_point(1) = constraint(1,1);
    elseif point(1) > constraint(1,2)
        projected_point(1) = constraint(1,2);
    else
        projected_point(1) = point(1);
    end
    
    % for the x_2 coordinate
    if point(2) < constraint(2,1)
        projected_point(2) = constraint(2,1);
    elseif point(2) > constraint(2,2)
        projected_point(2) = constraint(2,2);
    else
        projected_point(2) = point(2);
    end
    
end