function [rho, theta, phi] = sphereCoord(vertices, intPoint)
%
% Compute spherical coordinates of a set of vertices with respect to a
% point of interest.
%

%% Find the coordinate distances (component-wise)
dX = intPoint(1) - vertices(:, 1);
dY = intPoint(2) - vertices(:, 2);
dZ = intPoint(3) - vertices(:, 3);

% Compute the spherical coordinates
rho = sqrt(dX.^2 + dY.^2 + dZ.^2);
theta = atan2(dY, dX);
phi = acos(dZ ./ rho);

% Make sure it is not NaN
theta(isnan(theta)) = 0;
phi(isnan(phi)) = 0;

end
