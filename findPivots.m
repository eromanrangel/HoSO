function isPivot = findPivots(vertices)
%
%
%

%% Prepare
numOfPoints = size(vertices, 1);
numOfPivots = round(0.1 * numOfPoints);
subSetID = randperm(numOfPoints, min(3 * numOfPivots, numOfPoints));

% Pairwise distances
pwDist = squareform(pdist(vertices(subSetID, :)));
pwDist = diag(inf(numel(subSetID), 1)) + pwDist;

%% Pivots
isPivot = false(numOfPoints, 1);
isPivot(subSetID) = true;
while (sum(isPivot) > numOfPivots)
    [minY, ~] = min(pwDist);
    [~, minIDx] = min(minY);
    pwDist( :, minIDx ) = inf;
    pwDist( minIDx, : ) = inf;
    isPivot(subSetID(minIDx)) = false;
end

end
