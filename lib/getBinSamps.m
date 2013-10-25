function [binSamps bins] = getBinSamps(win,sldWin,trialTime)
% function that returns sample matrix corresponding to the bins described
% by window size and sliding window size. 
% note that win and sldwin must be in the same units as trialTime
% inputs:
%   win     = window/bin size
%   sldwin  = sliding window size
%   trialTime = vector of time stamps for the duration of the trial
% outputs:
%   binSamps = matrix of logicals (Bin X Sample)    
%   bins     = nBins X 2, matrix of bin limits
% a.gonzl june 2013

nSamps = numel(trialTime);
dur = [min(trialTime) max(trialTime)];
bs = (dur(1):sldWin:(dur(2)-win))';
be = ((dur(1)+win):sldWin:dur(2))';
bins = [bs be];
nBins = size(bins,1);

binSamps = false(nBins,nSamps);
for b = 1:nBins
    binSamps(b,:)= trialTime>=bins(b,1) & trialTime<=bins(b,2);
end

