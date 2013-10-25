function data = calcITC(data)
% data = calcITC(data)
% function epochs the phase signals, separates by trial condition computes
% inter trial coherence and permutation tests to quantify significance per
% channel
%
% dependencies:
%   subjChanInfo
%   subjExptInfo
%   itc

data.nPhBins = 200;
data.nBoot = 20;
data.nShuf = 100;

switch  data.lockType
    case 'stim'
        data.trialDur = [-0.2 1]; dur = data.trialDur;
        data.baseLine = [-0.2 0];
    case 'RT'
        data.trialDur = [-1 0.2]; dur = data.trialDur;
        % baseline period used from the stim locked data
end

data.nTrials        = numel(data.trialOnsets);
epochDur = data.trialDur; % before converting into trials and baseline correcting

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

X = data.phase; data.signal=[]; data.amp=[]; data.phase=[];

% Separate trials based on condition
data.Hits   = data.behavior.hits	 & data.goodTrials; H = data.Hits;
data.CRs    = data.behavior.cr & data.goodTrials;      CR = data.CRs;
data.nHits  = sum(data.Hits); data.nCRs = sum(data.CRs);
data.condTrials = find(H+CR);

nChans  = data.nChans; nShuf = data.nShuf; nBoot = data.nBoot;
nHits   = data.nHits;  nCRs = data.nCRs; condTrials = data.condTrials;

measurementTypes = {'ITC_H','ITC_CR','ITC_D','ITC_Z','ITC_HBM','ITC_HBSD', ...
    'ITC_CRBM','ITC_CRBSD','ITP_H','ITP_CR','ITP_D','ITP_Z'};
for mt = measurementTypes
    eval([mt{1} ' = zeros(nChans,nEpSamps);']);    
end

phase      = nan(nChans,nEvents,nEpSamps);

for ch = 1:nChans
    x = X(ch,:);
    for tr = validTrials
        phase(ch,tr,:) = x(evIdx(tr,:));
    end
end
parfor ch = 1:nChans
    Y = squeeze(phase(ch,:,:));
    
    [ITC_H(ch,:) ITP_H(ch,:)]       = itc(Y(H,:));
    [ITC_CR(ch,:) ITP_CR(ch,:)]     = itc(Y(CR,:));
    ITC_D(ch,:)                     = ITC_H(ch,:) - ITC_CR(ch,:);
    ITP_D(ch,:)                     = ITP_H(ch,:) - ITP_CR(ch,:);
    
    Y1 = bootstrp(nBoot,@itc,Y(H,:));
    Y2 = bootstrp(nBoot,@itc,Y(CR,:));
    
    ITC_HBM(ch,:)       = mean(Y1);
    ITC_HBSD(ch,:)      = std(Y1);
    ITC_CRBM (ch,:)     = mean(Y2);
    ITC_CRBSD(ch,:)     = std(Y2);    
    
    [shITC_D shITP_D]   = permITC_D(Y(condTrials,:),nShuf,nHits);
    ITC_Z(ch,:)         = (ITC_D(ch,:)-mean(shITC_D))./std(shITC_D);
    ITP_Z(ch,:)         = (ITP_D(ch,:)-mean(shITP_D))./std(shITP_D);

end

measurementTypes = {'phase','ITC_H','ITC_CR','ITC_D','ITC_Z','ITC_HBM','ITC_HBSD', ...
    'ITC_CRBM','ITC_CRBSD','ITP_H','ITP_CR','ITP_D','ITP_Z'};
for mt = measurementTypes
    data.(mt{1}) = eval(mt{1});
    eval( ['clear '  mt{1}]);
end


