function data = groupLPCData2(opts)
% groups LPC channel data by subject.
% takes outputs from spectrogramWrapper.m
%
% dependencies:
%       getBinSamps
%       signtest2
%       ranksum2



% data parameters
subjects    = opts.subjects;
lockType    = opts.lockType;
type        = opts.type;

% trial computation parameters
% erps or a spectral band
switch type
    case 'erp'
        baselineType = 'sub';
        analysisType = 'Amp';
        dataPath = '~/Documents/ECOG/Results/ERP_Data/';
        preFix = 'ERPs' ;
        offset = 0;
    otherwise
        baselineType = 'sub';
        analysisType = 'logPower';
        dataPath = '~/Documents/ECOG/Results/Spectral_Data/';
        preFix = ['ERSPs' type];
        offset = 0;
end
extension = [lockType 'Lock' baselineType analysisType reference ...
    num2str(nRefChans)] ;
fileName = [preFix extension];

nSubjs  = numel(subjects);

data                = [];
data.options        = opts;
data.prefix         = preFix;
data.extension      = extension;
data.options        = opts;
data.subjChans      = [];
data.ERP            = [];
data.LPCchanId      = [];
data.ROIid          = []; data.ROIs = {'IPS','SPL','AG'};
data.subROIid       = []; data.subROIs = {'pIPS','aIPS','pSPL','aSPL'};

for s = 1:nSubjs
    
    dataIn = load([dataPath 'subj' subjects{s} '/' fileName '.mat']);
    
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
    
    data.ROIid              = [data.ROIid; ROIid'];
    data.subROIid           = [data.subROIid; subROIid'];
    
    data.ERP{s}             = squeeze(dataIn.data.erp(dataIn.data.chanInfo.LPC,:,:));  
    data.Hits{s}            = dataIn.data.Hits;
    data.Miss{s}            = dataIn.data.behavior.miss & dataIn.data.goodTrials;
    data.CRs{s}             = dataIn.data.CRs;
    data.FA{s}              = dataIn.data.behavior.fa   & dataIn.data.goodTrials;
    data.RTtype{s}          = dataIn.data.RTtype;
    data.RTs{s}             = dataIn.data.allRTs;
    data.dPrime(s)          = dataIn.data.behavior.dPrime;
    
    %by block
    data.nSubjBlocks(s) = dataIn.data.nBlocks;
    data.blockIds{s}    = zeros(sum(dataIn.data.nevents),1);
    endIds              = cumsum(dataIn.data.nevents);
    startIds            = endIds-dataIn.data.nevents+1;
    for bl = 1:data.nSubjBlocks(s)
        ids = startIds(bl):endIds(bl);
        data.blockIds{s}(ids) = bl;
        h = dataIn.data.behavior.hits(ids); cr = dataIn.data.behavior.cr(ids);
        m = dataIn.data.behavior.miss(ids); fa = dataIn.data.behavior.fa(ids);
        rts  = data.RTs{s}(ids);
        nH = sum(h);
        nM = sum(m);
        nFA = sum(fa);
        nCR = sum(cr);
        data.dP_Block(s,bl) = calc_dPrime(nH,nM,nFA,nCR);
        data.HR_Block(s,bl) = nH/(nH+nM);
        data.FAR_Block(s,bl) = nFA/(nCR+nFA);
        data.hRT_Block(s,bl) = median(rts(h==1));
        data.crsRT_Block(s,bl) = median(rts(cr==1));
    end
end

nChans = numel(data.subjChans);

% trial time info
data.baselineType   = dataIn.data.baselineType;
data.SR             = dataIn.data.SR;
data.nTrialSamps    =numel(dataIn.data.trialTime);
data.trialDur       = dataIn.data.trialDur;
data.trialTime      = linspace(data.trialDur(1),data.trialDur(2),data.nTrialSamps);

% small time bin info
data.winSize        = 0.1; % in seconds
data.sldWin         = data.winSize;
[data.BinSamps  data.Bins] = getBinSamps(data.winSize,data.sldWin,data.trialTime);
data.nBins          = size(data.Bins,1);

% big time bin info
data.BigWinSize = 0.2; % in seconds
data.sldBigWin = data.BigWinSize/2;
[data.BinBinSamps  data.BigBins] = getBinSamps(data.BigWinSize,data.sldBigWin,data.trialTime);
data.nBigBins = size(data.BigBins,1);

% pre allocation
fields = {'ZStat','PValZ','mHits','mCRs','zHits','zCRs','cHits','cCRs','ZcHits','ZcCRs','ZcStat'};

for f = fields
    data.(f{1}) = zeros(nChans,data.nTrialSamps);
end

fields2 = strcat('Bin',fields);
for f = fields2
    data.(f{1}) = zeros(nChans,data.nBins);
end

fields2 = strcat('BigBin',fields);
for f = fields2
    data.(f{1}) = zeros(nChans,data.nBigBins);
end

fields2 = strcat('BinBlock',fields);
for f = fields2
    data.(f{1}) = nan(nChans,data.nBins,data.maxNumBlocks);
end

data.binErp = [];
ch = 1;

data.BinERP     = cell(nSubjs,1);
data.BigBinERP  = cell(nSubjs,1);

for s = 1:nSubjs
    H               = data.Hits{s};    
    CRs             = data.CRs{s};      
    RTs             = data.RTs{s};
    
    nTrials         = numel(H);
    nSubjChans      = data.nSubjLPCchans(s);
    
    data.BinERP{s}      = nan(nSubjChans,nTrials,data.nBins);
    data.BigBinERP{s}   = nan(nSubjChans,nTrials,data.nBigBins);
    
    for Sch = 1: data.nSubjLPCchans(s)        
        
        % original sampled data
        Z       = squeeze(data.ERP{s}(Sch,:,:));
        data    = getEffectScores(Z,RTs,H,CRs,data,ch,1,'');
        
        % binned        
        binERP  = binTrials(Z,data.BinSamps);
        data.BinERP{s}(Sch,:,:) = binERP;
        data    = getEffectScores(binERP,RTs,H,CRs,data,ch,1,'Bin');
        
        % Big bins         
        BigBinERP   = binTrials(Z,data.BinBinSamps);        
        data.BigBinERP{s}(Sch,:,:) = BigBinERP;
        data        = getEffectScores(BigBinERP,RTs,H,CRs,data,ch,1,'BigBin');
        
        %separate data by block
        Z = binERP;
        for bl = 1:data.nSubjBlocks(s)
            ids = data.blockIds{s}==bl;
            
            H2 = H&ids; CRs2 = CRs&ids;
            data    = getEffectScores(Z,RTs,H2,CRs2,data,ch,bl,'BinBlock');                        
        end
        ch = ch + 1;
    end
end

% channel by hemisphere id; 1 for lefts, 2 for rights
data.hemChanId  = ismember(data.subjChans,find(strcmp(opts.hemId,'r')))'+1;

% obtain group level roi main effects
data.mainEfpValROIs = zeros(3,data.nBigBins,2);
for hem = 1:2
    for r   = 1: numel(data.ROIs)
        chans = (data.ROIid == r) & (data.hemChanId == hem);
        [~,data.mainEfpValROIs(r,:,hem)] = ttest(data.BigBinZStat(chans,:));
    end
end

% obtain group level roi comparison statistics
% three comparsions:
data.ROIcontrasts       =  {'AG', 'IPS' ;'AG' ,'SPL';'IPS','SPL'};
data.contrEfpValROIs    = zeros(3,data.nBigBins,2);
for hem = 1:2
    for rc = 1:size(data.ROIcontrasts,1)        
        r1 = find(strcmp(data.ROIcontrasts(rc,1),data.ROIs));
        r2 = find(strcmp(data.ROIcontrasts(rc,2),data.ROIs));
        chans1 = (data.ROIid == r1) & (data.hemChanId == hem);
        chans2 = (data.ROIid == r2) & (data.hemChanId == hem);
        [~,data.contrEfpValROIs(rc,:,hem)] = ttest2(data.BigBinZStat(chans1,:),data.BigBinZStat(chans2,:));
    end
end

% subject channel information
for s = 1:nSubjs
    subjChans = data.LPCchanId(data.subjChans==s);
    temp = load(['./lib/elecLocs/subj' subjects{s} '_mni_elcoord_corrected.mat'],'mni_elcoord');
    data.MNIlocsSubj{s} = temp.mni_elcoord(subjChans,:);
    temp = load(['./lib/elecLocs/subj' subjects{s} '_electrodes_surface_loc_all1_correctnumbering.mat']);
    data.OrigLocsSubj{s} = temp.elecmatrix(subjChans,:);
    temp = load(['./lib/elecLocs/subj' subjects{s} '_cortex.mat']);
    data.cortex{s} = temp.cortex;
end

data.MNILocs = []; data.subjLocs = [];
for s = 1:nSubjs
    data.MNILocs = vertcat(data.MNILocs, data.MNIlocsSubj{s});
    data.subjLocs = vertcat(data.subjLocs, data.OrigLocsSubj{s});
end

switch data.options.hems
    case 'l'
        temp = load('./lib/elecLocs/MNI_cortex_left');
        data.MNIcortex = temp.cortex;
    case 'r'
        temp = load('./lib/elecLocs/MNI_cortex_right');
        data.MNIcortex = temp.cortex;
    otherwise
        temp = load('./lib/elecLocs/MNI_cortex_left');
        data.lMNIcortex = temp.cortex;
        temp = load('./lib/elecLocs/MNI_cortex_right');
        data.rMNIcortex = temp.cortex;
        temp = load('./lib/elecLocs/MNI_cortex_both');
        data.MNIcortex = temp.cortex;
end


function data = getEffectScores(Z,RTs,H,CRs,data,ch,bl,preFix)
% data = getEffectScores(Z,RTs,H,CRs,data,preFix)
% inputs:
% Z     -> data matrix with 1st dimension of Ntrials. 2nd dim of timepoints
% RTs   -> vector with Ntrials
% H     -> cond1, logical vector Ntrials
% CRs   -> cond2, logical vector Ntrials
% data  -> data structure to write output to.
% preFix-> preFix string for the outputs

nH      = sum(H);
nCRs    = sum(CRs);

% original sampled data
X       = Z(H,:);
Y       = Z(CRs,:);

% store means for each condition
data.([preFix 'mHits'])(ch,:,bl)        = mean(X);
data.([preFix 'mCRs'])(ch,:,bl)         = mean(Y);

% test each condition against 0
[~,data.([preFix 'zHits'])(ch,:,bl)]                = signtest2(X);
[~,data.([preFix 'zCRs'])(ch,:,bl)]                 = signtest2(Y);
% test conditions against each other
[data.([preFix 'PValZ'])(ch,:,bl) data.([preFix 'ZStat'])(ch,:,bl)] = ranksum2(X,Y);

% correlate each condition to RT (transformed to z values)
data.([preFix 'cHits'])(ch,:,bl)        = corr(X,log10(RTs(H)));
data.([preFix 'cCRs'])(ch,:,bl)         = corr(Y,log10(RTs(CRs)));
data.([preFix 'ZcHits'])(ch,:,bl)       = atanh(data.([preFix 'cHits'])(ch,:,bl))*sqrt(nH-3);
data.([preFix 'ZcCRs'])(ch,:,bl)        = atanh(data.([preFix 'cCRs'])(ch,:,bl))*sqrt(nCRs-3);
data.([preFix 'ZcStat'])(ch,:,bl)       = data.([preFix 'ZcHits'])(ch,:,bl)-data.([preFix 'ZcCRs'])(ch,:,bl);

