function [testIdx, testFoldIdx, trainFoldIdx] = balancedBootStrapXVal(nBoots,nSamples,nFolds,class1Idx,class2Idx)
% this function creates a class balanced (binary) test & train xvalidation 
% data sets with training data has been sampled with replacement
% (bootstrapped)
% a.gonzalez 2014

nclass1 = numel(class1Idx);
nclass2 = numel(class2Idx);

assert(isempty(intersect(class1Idx,class2Idx)), 'class indices overlap!')
% max number of samples PER CLASS for each fold
maxNtestSamp = floor(min(nclass1,nclass2)/nFolds);
NtestSamp = max(maxNtestSamp-1,1);
NtrainSamps = min(nclass1,nclass2)-NtestSamp;

testIdx = zeros(2*NtestSamp*nFolds,nBoots);
testFoldIdx = zeros(2*NtestSamp,nFolds,nBoots);
trainFoldIdx = zeros(2*NtrainSamps,nFolds,nBoots);

for  b = 1:nBoots
    testIdx1=randsample(class1Idx,NtestSamp*nFolds);
    testIdx2=randsample(class2Idx,NtestSamp*nFolds);
    for ff = 1: nFolds
        foldSampIdx         = (ff*NtestSamp-(NtestSamp-1)):NtestSamp*ff;
        testfoldSampIdx     = (ff*NtestSamp*2-(NtestSamp*2-1)):NtestSamp*ff*2;
        testFoldIdx(:,ff,b) = [testIdx1(foldSampIdx);testIdx2(foldSampIdx)];
        testIdx(testfoldSampIdx,b) = testFoldIdx(:,ff,b);
        
        % take out test samples from possible training
        trainIdx1 = randsample(setdiff(class1Idx,testIdx1(foldSampIdx)),NtrainSamps,true);
        trainIdx2 = randsample(setdiff(class2Idx,testIdx2(foldSampIdx)),NtrainSamps,true);
        
        trainFoldIdx(:,ff,b) = [trainIdx1;trainIdx2];
    end
    %testIdx(:,b) = [testIdx1;testIdx2];
    
    ff = randi(nFolds);
    assert(isempty(intersect(trainFoldIdx(:,ff,b),testFoldIdx(:,ff,b))),'training & test sets overlap!')
end

return