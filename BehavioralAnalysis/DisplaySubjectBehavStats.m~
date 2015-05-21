

dataPath = '/Users/alexg8/Documents/ECOG/Results/BehavData/';

subjs = {'16b','18','24','28','30','17b','29','19'};
nSubjs = numel(subjs);

HitRate = zeros(1,nSubjs);
FARate = zeros(1,nSubjs);
dPrime = zeros(1,nSubjs);
HCprop = zeros(1,nSubjs);
RTHits  = zeros(1,nSubjs);
RTCRs  = zeros(1,nSubjs);

for s = 1:nSubjs
    load(sprintf('%sSubj%sbehav_perf.mat',dataPath,subjs{s}))
    HitRate(s) = behav_perf.hitrate;
    FARate(s) = behav_perf.farate;    
    dPrime(s) = behav_perf.dPrime;
    HCprop(s) = sum(behav_perf.HCOresp+behav_perf.HCNresp)/numel(behav_perf.old);

    RTHits(s)  = behav_perf.hitRTStats.RTmedian;
    RTCRs(s)  = behav_perf.crRTStats.RTmedian;
end

display(HitRate)
display(FARate)
display(dPrime)
display(HCprop)

