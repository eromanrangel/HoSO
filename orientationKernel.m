function OK = orientationKernel(numOfOrientations, numOfBins, sigma)
%
% Compute orientation kernel for a smooth histogram of local orientations.
% Useful for shapes and other sensitive signals
%
% Input:
%  - numOfOrientations: Number of orientations values for which to compute
%  the Gaussian function. 180 is suggested.
%  - numOfBins: Number of bins for each orientation kernel. 8 is suggested.
%  - sigma: variance of the Gaussian distribution. 10 is suggested.
% Output:
%  - OK: the orientation kernel. A set of row vector with the kernels for
%  each local orientation. [180x8] will be produced using the suggested
%  values.
%
% Edgar Roman-Rangel. 2016.
%
% Citation:
% Edgar Roman-Rangel, Carlos Pallan, Jean-Marc Odobez, and Daniel 
% Gatica-Perez. "Analyzing Ancient Maya Glyph Collections with Contextual
% Shape Descriptors". In Special Issue in Cultural Heritage and Art
% Preservation. International Journal of Computer Vision. 94(1):101–117.
% August, 2011.
%


%% Find the size of each Gaussian kernel
numDumm = numOfOrientations;
while(mod(numDumm, numOfBins) ~= 0)
    numDumm = 2 * numDumm;
end
binSize = numDumm / numOfBins;


%% Compute central Gaussian
pivot = round(numOfOrientations / 2);
G = zeros(numOfOrientations, numDumm);
G(pivot, :) = pdf('norm', 1 : numDumm, round(numDumm / 2), sigma);
OK = zeros(numOfOrientations, numOfBins);

bin = 1;
for b = 1 : numOfBins
	OK(pivot, b) = sum(G(pivot, bin : bin + binSize - 1));
	bin = bin + binSize;
end


%% Compute the other Gaussians
for h = pivot + 1 : numOfOrientations
    G(h, :) = circshift(G(h - 1, :), [0, (numDumm / numOfOrientations)]);
    bin = 1;
    for b = 1 : numOfBins
        OK(h, b) = sum(G(h, bin : bin + binSize - 1));
        bin = bin + binSize;
    end
end
for h = pivot - 1 : -1 : 1
    G(h, :) = circshift(G(h + 1, :), [0, -(numDumm / numOfOrientations)]);
    bin = 1;
    for b = 1 : numOfBins
        OK(h, b) = sum(G(h, bin : bin + binSize - 1));
        bin = bin + binSize;
    end
end


%% Keep only the most probable bins
[~, idSortH] = sort(OK, 2);
for h = 1 : numOfOrientations
    OK(h, idSortH(h, 1 : end - 4)) = 0;
end

end
