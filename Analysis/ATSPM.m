function out = ATSPM(s1,s2,segLength,lagPoints, startPoints, Dtype)
% out = ADPM(s1,s2,maxLag, segLength, type)
% ADPM = adaptive time series pattern match
% this function takes two signals of *equal length* and finds the optimal
% lag between the two signals based. The computation is based on the
% specified Dtype, and the patterns need to match up to length segLength.
% Default Dtype is an L2 distance.
% The algorithm basically does a grid search based on the maxLag and
% segment Length across the two signals, and outputs the best parameters
% and the score based on Dtype obtained.
% 
% Note: 
% high segLength -> the more smooth the scores are, less adaptive
% low  segLength -> more adaptive, more noisy grid search
% ** everything should be in sample space, not seconds**
% A. Gonzl. Sept 2013
% Stanford Memory Lab

% total number of samples
T  = numel(s1);
if T ~= numel(s2)
    error('Time series need to be of equal length')
end

% grid search settings
nTaus           = numel(lagPoints);
nS              = numel(startPoints);
maxLag          = max(lagPoints);
% grid score matrix
lossMat    = zeros(nS,nTaus);

% function to use
switch Dtype
    case 'DTW'
        % dynamic time warping loss
        Lf = @(x,y)sqrt(dtw_c(x,y,maxLag));
    otherwise
        Lf = @(x,y)norm(x-y,2);
end

% actual algorithm
parfor sId = 1:nS
    s = startPoints(sId);
    for tauId = 1:nTaus
        tau = lagPoints(tauId);        
        % select the segments and find a score
        v1                  = s1(s:s+segLength);
        v2                  = s2((s+tau):(s+tau+segLength));
        lossMat(sId,tauId)  = Lf(v1,v2);
    end
end

% store optimal params
out             = [];
out.lossMat     = lossMat;
out.score       = min(lossMat(:));

[i,j]          = find(lossMat==out.score);
out.bestStart  = startPoints(i);
out.bestLag    = lagPoints(j);
out.bestStartIdx  = i;
out.bestLagIdx    = j;
return
