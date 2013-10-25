
function [coh ph] = itc(X)
% out = itc(X)
% itc calculates the intertrial coherence. 
% X = phase matrix (in radians); dim1 = ntrials, dim2 = timepoints
% out = vector of length numel(dim2), of ITC values.

vect    = mean(exp(1i*X));
coh     = abs(vect);
ph      = angle(vect);


