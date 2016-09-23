function HOSO = hoso3D(vertices)
%
% HOSO produces a set of Histogram of Spherical Orientations (HoSO's) for a
% set of vertices in a 3D space, as introduced in our paper.
%
% Input
%  - vertices: set of [N x 3] vertices with (x, y, z) coordinates.
% Output
%  - HOSO: set of [N x 1024] local descriptors, i.e., HoSO's
%
% Edgar Roman-Rangel. 2016
%
%

%% Sample a subset of vertices
isPivot = findPivots(vertices);
% Uncomment to visualize surface and selected points of interest
% plot3(vertices(:, 1), vertices(:, 2), vertices(:, 3), '.'), hold on
% plot3(vertices(isPivot, 1), vertices(isPivot, 2), vertices(isPivot, 3), 'r.')
vertices(~isPivot, :) = [];

%% Parameters
numOfPoints = size(vertices, 1);
meanRHO = mean(pdist(vertices));

% Rho
rhoInts = [0.5, 1.0];
numOfRhoInts = numel(rhoInts);
% Theta
numOfThetaInts = 8;
thetaInts = linspace(2 * pi / numOfThetaInts, 2 * pi, numOfThetaInts);
% Phi
numOfPhiInts = 4;
phiInts = linspace(pi / numOfPhiInts, pi, numOfPhiInts);
% Orientation Kernel (OK)
numOfOKBins = 8;
OK = orientationKernel(180, numOfOKBins, 10);

%% Find centroid and spheric coordinates wrt it (normalize them)
centroid = mean(vertices, 1);
[~, thetaC, phiC] = sphereCoord(vertices, centroid);
thetaC = mod(thetaC, pi);
phiC = mod(phiC, pi);

%% Compute spheric coordinates wrt each point used as pivot, one at the time
HOSO = zeros(numOfPoints, numOfRhoInts * numOfThetaInts * numOfPhiInts * 2 * numOfOKBins);
for point = 1 : numOfPoints
    % Compute spheric coordinates wrt each point used as pivot
    [rho, theta, phi] = sphereCoord(vertices, vertices(point, :));
    
    % rho scale invariant. theta and phi aligned wrt centroid (rot. invar.)
    rho = rho / meanRHO;
    theta = theta - thetaC(point);
    phi = phi - phiC(point);
    
    % Make sure [0 <= theta <= 2pi] and [0 <= phi <= pi]
    theta = rem(rem(theta, 2 * pi) + 2 * pi, 2 * pi);
    phi = mod(phi, pi);
    
    % Put distances and angles into interval values of the sphere
    rhoB = real2sphBin(rho, rhoInts);
    thetaB = real2sphBin(theta, thetaInts);
    phiB = real2sphBin(phi, phiInts);
    
    % Temp matrices histograms (Theta: T; or Phi: P) per ring (xR)
    matxHTxR = zeros(numOfOKBins * numOfThetaInts * numOfPhiInts, numOfRhoInts);
    matxHPxR = zeros(numOfOKBins * numOfThetaInts * numOfPhiInts, numOfRhoInts);
    for r = 1 : numOfRhoInts    % Rho
        % Temp store of histograms
        matxHoTheta = zeros(numOfOKBins, numOfThetaInts * numOfPhiInts);
        matxHoPhi = zeros(numOfOKBins, numOfThetaInts * numOfPhiInts);
        colIdx = 1;
        
        for t = 1 : numOfThetaInts  % Theta
        for p = 1 : numOfPhiInts    % Phi
            % Find neighbor points within spherical regions, and align them
            inRegion = rhoB == r & thetaB == t & phiB == p;
            if sum(inRegion) > 0
                % Reorient local orientations -> rotation invariant
                thisTheta = mod(thetaC(inRegion) - thetaC(point), pi);
                thisPhi = mod(phiC(inRegion) - phiC(point), pi);

                % Compute the actual distribution of spheric orientations
                matxHoTheta(:, colIdx) = computeHOSO(thisTheta, OK);
                matxHoPhi(:, colIdx) = computeHOSO(thisPhi, OK);
            end
            colIdx = colIdx + 1;
        end
        end
        
        % Put together histograms of same type of angles
        matxHTxR(:, r) = matxHoTheta(:);
        matxHPxR(:, r) = matxHoPhi(:);
    end
    
    % Put all histograms together to get point descriptor
    HOSO(point, :) = [matxHTxR(:)', matxHPxR(:)'];
end

end


%% Compute the local HoSO for a spherical region
function histOfOrientations = computeHOSO(orientatons, H)

% Convert radians to degrees
orientatonsD = round(orientatons * 180 / pi);
orientatonsD(orientatonsD == 0) = 180;

% Sum the OK to obtain the histogram
histOfOrientations = sum(H(orientatonsD, :), 1)';

% Normalize it
sumH = sum(histOfOrientations);
if sumH > 0
    histOfOrientations = histOfOrientations / sumH;
end

end
