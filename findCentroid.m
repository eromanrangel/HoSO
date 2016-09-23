function centroid = findCentroid(vertices)
%
%
%

%% Find the limits of the active space
maxVal = max(vertices, [], 1);
minVal = min(vertices, [], 1);

% Compute centroid
centroid.x = (maxVal(1) - minVal(1)) / 2;
centroid.y = (maxVal(2) - minVal(2)) / 2;
centroid.z = (maxVal(3) - minVal(3)) / 2;

end
