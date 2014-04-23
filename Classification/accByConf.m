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

includeTrials = ~isnan(probVector);

acc1 = nan(nVect,nPoints);
acc0 = acc1;

for jj = 1:nVect
    for ii = 1:nPoints
        %acc1(jj,ii) = %nanmean(classVector(probVector(:,jj) > confPoints(ii))==1);
        acc1(jj,ii) = mean(classVector(probVector(:,jj)>confPoints(ii) & includeTrials(:,jj))==1);
        %acc0(jj,ii) = nanmean(classVector(probVector(:,jj) < 1-confPoints(ii))==0);        
        acc0(jj,ii) = mean(classVector(probVector(:,jj)<(1-confPoints(ii)) & includeTrials(:,jj))==0);
    end
end
accT = (acc0+acc1)/2;

tt1=[]; 
tt2=[];
tt3=[];
for ii = 1:nPoints

    acc1_2=[];
    acc0_2=[];
    for jj = 1:nVect
        %acc1(jj,ii) = %nanmean(classVector(probVector(:,jj) > confPoints(ii))==1);
        acc1_2 = [acc1_2;classVector(probVector(:,jj)>confPoints(ii) & includeTrials(:,jj))==1];
        %acc0(jj,ii) = nanmean(classVector(probVector(:,jj) < 1-confPoints(ii))==0);        
        acc0_2 = [acc0_2;classVector(probVector(:,jj)<(1-confPoints(ii)) & includeTrials(:,jj))==0];
    end
    tt1{ii} = acc1_2;
    tt2{ii} = acc0_2;
    tt3{ii} = [acc1_2; acc0_2];
end

return