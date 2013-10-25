
function [out,phaseBins] = modIndex(phase, amp, phaseBins)
% function calculates modulation index as described in
% Tort et al. J. Neurophysiology 2010
% takes in an amplitude signal, a phase signal, and the edges for the phase
% bins
% returns the mi as a function of bin
% assumes both and phase inputs are vectors.
% created by A.Gonzl Apr. 2013

nBins = numel(phaseBins)-1;
[~,binIdx] = histc(phase,phaseBins);

out = zeros(nBins,1);
for b = 1:(nBins)
    out(b) = mean(amp(binIdx==b));
end
out = out/nansum(out);
end
