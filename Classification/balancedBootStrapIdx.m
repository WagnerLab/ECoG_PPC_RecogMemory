
function BootIdxMat = balancedBootStrapIdx(nBoots,nSamples,nF,class1Idx,class2Idx)
% returns a matrix of nSamples X nBoots; each column has the same number of
% class1 labels and class2 labels

nclass1 = numel(class1Idx);
nclass2 = numel(class2Idx);
if nSamples > 2 * min(nclass1,nclass2)
    nSamples = 2 * min(nclass1,nclass2);
    nSamples = 2 * nF*floor(nSamples/(2*nF));
    warning('resseting the number of samples')
end

BootIdxMat = zeros(nSamples,nBoots);
for b = 1: nBoots
    BootIdxMat(:,b)= [randsample(class1Idx,nSamples/2,true); ...
        randsample(class2Idx,nSamples/2,true)];
end

return