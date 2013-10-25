
function [badtrials trial_var goodtrials]  = CalculateBadTrials(X, thr)
% Function takes input data matrix X (#chans, # trials, # samples)
% It collapses across channels and calculates the variability within a
% trial. If the within trial variance is greater than thr * (across channels ... 
% variance). Then reject the trial.

% default threshold is 2 std
if ~exist('thr','var'), thr = 2; end

[nch ntr nbins]=size(X);

% zscore by channel
XZ = bsxfun(@minus,X(:,:),nanmean(X(:,:),2));
XZ = bsxfun(@rdivide,XZ,nanstd(XZ,0,2));
XZ = reshape(XZ,[nch ntr nbins]); 

% collapse across channels and calculate the trial covariane matrix
X = permute(XZ,[2 1 3]); clear XZ;
trial_var = nanvar(X(:,:),0,2);
        
% calculate an upper bound on the variance for each trial
high_var_bound = nanmean(trial_var)+thr*nanstd(trial_var);
        
% deterime bad trials
badtrials = (trial_var > high_var_bound);
goodtrials= (trial_var < high_var_bound);