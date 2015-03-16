function data=calcERSP(data)
% function epochs the raw signals, separates by trial condition and
% calculates simple univariate stats

switch  data.lockType
    case 'stim'
        data.trialDur = [-0.2 1]; dur = data.trialDur;
        data.baseLine = [-0.2 0];
    case 'RT'
        data.trialDur = [-1 0.2]; dur = data.trialDur;
        % baseline period used from the stim locked data
end

data.nTrials        = numel(data.trialOnsets);
epochDur = [-2 2]; % before converting into trials and baseline correcting

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

% store the corresponding roi channel ids in data struct.
data.rois       = data.chanInfo;

% time is the total time around the trial that was stored in the data
% this is might be greater than the trial duration of interest
epochTime = linspace(epochDur(1),epochDur(2),ceil(diff(epochDur)*data.SR)); nEpSamps = numel(epochTime);

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
X = data.amp;data.signal=[]; data.amp=[]; data.phase=[];

erp = nan(data.nChans,nEvents,nEpSamps);
for ch = 1:data.nChans
    x = X(ch,:);
    for tr = validTrials
        erp(ch,tr,:) = x(evIdx(tr,:));
    end
end

% Percent signal change for amplitude.
switch data.analysisType
    case 'Power'
        erp = erp.^2;
    case 'logPower'
        erp = 20*log10(erp);
end

% Correct for baseline fluectuations before trial onset. In case of RT
% locked analysis, it uses the baselines from the stim locked (loaded outside)
if strcmp(data.lockType,'stim')
    baselineIdx = epochTime<=data.baseLine(2) & epochTime>= data.baseLine(1);
    data.baseLineMeans = nanmean(erp(:,:,baselineIdx),3);
end

switch data.baselineType
    case 'sub'
        erp = bsxfun(@minus,erp,data.baseLineMeans);
    case 'rel'
        erp = bsxfun(@rdivide,erp,data.baseLineMeans);
end

% Take relevant samples of trial
erp = erp(:,:,trialSamps); data.erp = erp;

% Separate trials based on condition
%data.Hits = data.behavior.hits	 & data.goodTrials;
data.Hits = data.behavior.HChits	 & data.goodTrials;
data.CRs = data.behavior.HCcr       & data.goodTrials;

% separate trials based on median RT
RTedgesC1 = [0,median(data.allRTs(data.Hits)),max(data.allRTs(data.Hits))+0.1];
RTedgesC2 = [0,median(data.allRTs(data.CRs)),max(data.allRTs(data.CRs))+0.1];
[~,qRTLabelsC1] = histc(data.allRTs(data.Hits),RTedgesC1);
[~,qRTLabelsC2] = histc(data.allRTs(data.CRs),RTedgesC2);
data.RTtype = zeros(data.nTrials,1);
data.RTtype(data.Hits) = qRTLabelsC1;
data.RTtype(data.CRs) = qRTLabelsC2;

end




