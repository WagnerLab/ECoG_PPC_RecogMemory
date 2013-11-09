function [acc1, acc0, accT, confPoints ] = accByConf(probVector, classVector , confPoints)
% [acc, conf] = accByConf(probVector, classVector ,nPoints)
% this function tabulates the accuracy by probability values in nPoints.
% acc1, acc0 correspond to class labels 1 and 0, accT corresponds to the
% overall accuracy.
% assumes class labels 1 corresponds to the highest probability value.
% confPoints must be increasing

if ~exist('confPoints','var')
    confPoints = linspace(.1,.9,10);
end

nVect   = size(probVector,2);
nPoints = length(confPoints);

acc1 = nan(nVect,nPoints);
acc0 = acc1;

for jj = 1:nVect
    for ii = 1:nPoints
        acc1(jj,ii) = nanmean(classVector(probVector(:,jj) > confPoints(ii))==1);
        acc0(jj,ii) = nanmean(classVector(probVector(:,jj) < 1-confPoints(ii))==0);        
    end
end
accT = (acc0+acc1)/2;