function data = calcMI(AmpData,PhaseData,lockType)

% dependencies:
%   subjChanInfo
%   subjExptInfo
%   modIndex

data=[];
data.expt           = AmpData.expt;
data.subjnum        = AmpData.subjnum;
data.reReferencing  = AmpData.reReferencing;
data.SR             = AmpData.SR;
data.nChans         = AmpData.nChans;
data.lockType       = lockType;
data.trialOnsets    = AmpData.trialOnsets;

data.phaseName  = PhaseData.band;
data.phaseBand  = PhaseData.bandLims;

data.ampName = AmpData.band;
data.ampName = AmpData.bandLims;

data.nPhBins = 20; nPhBins = data.nPhBins;
data.nShuf = 100;

switch  lockType
    case 'stim'
        data.trialDur = [-0.2 1]; dur = data.trialDur;
    case 'RT'
        data.trialDur = [-1 0.2]; dur = data.trialDur;
end
data.nTrials        = numel(AmpData.trialOnsets);
epochDur            = data.trialDur; % before converting into trials and baseline correcting

% add behavioral data
behavdatapath = ['~/Documents/ECOG/Results/BehavData/Subj' data.subjnum];
load([behavdatapath 'behav_perf.mat']);
data.behavior = behav_perf;

% get bad trials:
temp = subjExptInfo(data.subjnum,data.expt, data.reReferencing);
badtrials = temp.badtrials;

goodtrials = true(data.nTrials,1);
goodtrials(badtrials) = false;
data.goodTrials = goodtrials;

data.chanInfo = subjChanInfo(data.subjnum);

% time is the total time around the trial that was stored in the data
% this is might be greater than the trial duration of interest
epochTime = linspace(epochDur(1),epochDur(2),round(diff(epochDur)*data.SR)); nEpSamps = numel(epochTime);

% determine the samples that correspond to the specified trial duration
trialSamps     = epochTime>=dur(1) & epochTime<=dur(2); 

% Determine time samples in the trial
trialTime      = epochTime(trialSamps); data.trialTime = trialTime;

% get the reation times from behavioral data
data.allRTs = data.behavior.allRTs;

evOnsets = data.trialOnsets;
nEvents = numel(evOnsets);
epSamps = floor(epochTime*data.SR);
evIdx = zeros(nEvents,nEpSamps);

switch  data.lockType
    case 'stim'
        offset = zeros(nEvents,1);
    case 'RT'
        offset = round(data.allRTs*data.SR);
end

for ev = 1:nEvents
    evIdx(ev,:) = epSamps+evOnsets(ev)+offset(ev);
end

validTrials = find(~isnan(offset))';

ampSignal   = AmpData.amp;      AmpData     = []; 
phaseSignal = PhaseData.phase;  PhaseData   = [];
nChans  = size(ampSignal,1);

phase   = nan(nChans,nEvents,nEpSamps);
amp     = nan(nChans,nEvents,nEpSamps);
for ch = 1:nChans
    x = phaseSignal(ch,:);
    y = ampSignal(ch,:);
    for tr = validTrials
        phase(ch,tr,:)  = x(evIdx(tr,:));
        amp(ch,tr,:)    = y(evIdx(tr,:));
    end
end

data.phase = phase; data.amp = amp;

% Separate trials based on condition
data.Hits   = data.behavior.hits	& data.goodTrials;  H   = data.Hits;
data.CRs    = data.behavior.cr      & data.goodTrials;  CR  = data.CRs;
data.nHits  = sum(data.Hits);       data.nCRs   = sum(data.CRs);
data.condTrials = find(H+CR);

data.phaseBinEdges      = linspace(-pi,pi,data.nPhBins+1); phaseBinEdges = data.phaseBinEdges;
data.phaseBinCenters    = mean([phaseBinEdges(1:end-1)' phaseBinEdges(2:end)'],2);

data.mi                 = nan(nChans,data.nTrials,data.nPhBins);
data.miZ                = nan(nChans,data.nPhBins);
for c = 1:nChans
    % amplitude
    cAmp    = squeeze(amp(c,:,:));
    cPh     = squeeze(phase(c,:,:));
    
    cMI = zeros(data.nTrials,nPhBins);
    
    parfor tr = 1:data.nTrials
        cMI(tr,:) = modIndex(cPh(tr,:),cAmp(tr,:),phaseBinEdges);
    end
    data.mi(c,:,:) = cMI;    
    [~,data.miZ(c,:)] = ranksum2(cMI(H,:),cMI(CR,:));  
end




