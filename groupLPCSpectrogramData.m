function data = groupLPCSpectrogramData(opts)
% groups LPC channel data by subject.
% takes outputs from calcERP or calcERSP
%
% dependencies:
%       getBinSamps
%       signtest2
%       ranksum2

% data parameters
subjects    = opts.subjects;
lockType    = opts.lockType;

dataPath = '~/Documents/ECOG/Results/Spectral_Data/';

nSubjs  = numel(subjects);

data                = [];
data.options        = opts;
data.subjChans      = [];
data.ERP            = [];
data.LPCchanId      = [];
data.ROIid          = []; data.ROIs = {'IPS','SPL','AG'};
data.subROIid       = []; data.subROIs = {'pIPS','aIPS','pSPL','aSPL'};

conds   = {'Hits','CRs'};
stats1  = {'mean','median','tStat','tStatPval','signRankP'};
stats2  = {'H_CRstStat','H_CRstStatPval','H_CRsranksSum','H_CRsranksSumPval'};
% pre-allocate
for ss = 1:numel(stats1)
    for cc = 1:numel(conds)
        data.([stats1{ss} conds{cc}]) = [];
    end
end
for ss = 1:numel(stats2)
    data.(stats2{ss}) = [];
end

for s = 1:nSubjs
    fileName = [lockType '_Spectrogram_subj' subjects{s}];
    dataIn = load([dataPath 'subj' subjects{s} '/epoched/'  fileName '.mat']);
    
    temp = subjChanInfo(subjects{s});
    data.nSubjLPCchans(s)   = numel(temp.LPC);
    data.LPCchanId          = [data.LPCchanId; temp.LPC'];
    data.subjChans          = [data.subjChans s*ones(1,data.nSubjLPCchans(s))];
    
    ROIid = 1*ismember(temp.LPC,temp.IPS) + ...
        2*ismember(temp.LPC,temp.SPL) + ...
        3*ismember(temp.LPC,temp.AG);
    subROIid = 1*ismember(temp.LPC,temp.pIPS) + ...
        2*ismember(temp.LPC,temp.aIPS) + ...
        3*ismember(temp.LPC,temp.pSPL) + ...
        4*ismember(temp.LPC,temp.aSPL);
    
    data.ROIid      = [data.ROIid; ROIid'];
    data.subROIid   = [data.subROIid; subROIid'];
    
    data.Hits{s}    = dataIn.data.Hits;
    data.Miss{s}    = dataIn.data.behavior.miss & dataIn.data.goodTrials;
    data.CRs{s}     = dataIn.data.CRs;
    data.FA{s}      = dataIn.data.behavior.fa   & dataIn.data.goodTrials;
    data.RTs{s}     = dataIn.data.behavior.allRTs;
    data.dPrime(s)  = dataIn.data.behavior.dPrime;
    
    for ss = 1:numel(stats1)
        for cc = 1:numel(conds)
            data.([stats1{ss} conds{cc}]) = cat(1,data.([stats1{ss} conds{cc}]), ...
                dataIn.data.([stats1{ss} conds{cc}])(dataIn.data.chanInfo.LPC,:,:));
        end
    end
    for ss = 1:numel(stats2)
        data.(stats2{ss}) = cat(1,data.(stats2{ss}),...
            dataIn.data.(stats2{ss})(dataIn.data.chanInfo.LPC,:,:));
    end
    % data.Spec{s}    = dataIn.data.trialSpectrogram(dataIn.data.chanInfo.LPC,:,:,:);
    % other of the summary statitiscs for LPC channels.
end

data.nChans     = numel(data.subjChans);
data.Freqs      = dataIn.data.Freqs;
data.nFreqs     = dataIn.data.nFreqs;
data.epochTime  = dataIn.data.epochTime;
data.nEpSamps   = dataIn.data.nEpSamps;
data.SpecSR     = dataIn.data.SpecSR;
data.nROIs      = numel(data.ROIs);

% channel by hemisphere id; 1 for lefts, 2 for rights
data.hemChanId      = ismember(data.subjChans,find(strcmp(opts.hemId,'r')))'+1;
data.meanROIHits    = zeros(2,data.nROIs,data.nFreqs,data.nEpSamps);
data.meanROICRs     = zeros(2,data.nROIs,data.nFreqs,data.nEpSamps);
data.mainEfpValROIs = zeros(2,data.nROIs,data.nFreqs,data.nEpSamps);
data.mainEfTvalROIs = zeros(2,data.nROIs,data.nFreqs,data.nEpSamps);

% fixed effects results.
for hem = 1:2
    for rr   = 1: numel(data.ROIs)
        chans = (data.ROIid == rr) & (data.hemChanId == hem);
        for ff = 1:data.nFreqs
             [~,a2,~,a4]= ttest(squeeze(data.H_CRsranksSum(chans,ff,:)));
             data.mainEfpValROIs(hem,rr,ff,:) = a2;
             data.mainEfTvalROIs(hem,rr,ff,:) = a4.tstat;

            data.meanROIHits(hem,rr,ff,:)   = squeeze(mean(data.meanHits(chans,ff,:)));
            data.meanROICRs(hem,rr,ff,:)    = squeeze(mean(data.meanCRs(chans,ff,:)));            
        end
    end
end

return


