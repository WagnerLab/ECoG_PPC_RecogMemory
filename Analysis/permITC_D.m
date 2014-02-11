function [coh ph] = permITC_D(X,nSh,nC1)
% out = permITC_D(X,nSh,nC1)
% this function constructs a permutation matrix for the phase matrix X
% inputs: 
%   X   -> dim1 is nTrials, dim2 is nSamps
%   nSh -> number of shuffles
%   nC1 -> number of trials for condition1, condition 2 is nTrials-nC1

nTrials = size(X,1);
nSamps  = size(X,2);

coh = zeros(nSh,nSamps);
ph  = zeros(nSh,nSamps);
for sh = 1:nSh
    idx1 = randsample(nTrials,nC1);
    idx2 = setdiff(1:nTrials,idx1);
    
    [v1C v1P]   = itc(X(idx1,:));
    [v2C v2P]   = itc(X(idx2,:));
    coh(sh,:)   = v1C-v2C;
    ph(sh,:)    = v1P-v2P;
end