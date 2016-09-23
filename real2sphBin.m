function intervalBins = real2sphBin(realValues, intValues)
%
%
%

%%
intervalBins = ones(numel(realValues), 1);
for b = 1 : numel(intValues)
    isLarger = realValues > intValues(b);
    intervalBins(isLarger) = intervalBins(isLarger) + 1;
end

end
