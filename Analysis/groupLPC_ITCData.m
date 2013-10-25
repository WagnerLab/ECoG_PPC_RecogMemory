function data = groupLPC_ITCData(opts)
% groups LPC channel data by subject.

% data parameters
subjects    = opts.subjects;
reference   = opts.reference;
nRefChans   = opts.nRefChans;
lockType    = opts.lockType;
type        = opts.type;
band        = opts.band;

dataPath    = ['~/Documents/ECOG/Results/ITC_Data/'];
preFix      = [type band];
extension   = [lockType 'Lock' reference num2str(nRefChans)] ;
fileName    = [preFix extension];

nSubjs  = numel(subjects);

data                = [];
data.options        = opts;
data.prefix         = preFix;
data.extension      = extension;
data.options        = opts;
data.subjChans      = [];
data.erp            = [];
data.LPCchanId      = [];
data.ROIid          = []; data.ROIs = {'IPS','SPL','AG'};
data.subROIid       = []; data.subROIs = {'pIPS','aIPS','pSPL','aSPL'};

data.maxNumBlocks   = 4;
data.dP_Block       = nan(nSubjs,data.maxNumBlocks);
data.HR_Block       = nan(nSubjs,data.maxNumBlocks);
data.FAR_Block      = nan(nSubjs,data.maxNumBlocks);


data.ITC_Hits         = []; data.ITC_CRs        = [];
data.ITC_D            = []; data.ITC_Z          = [];

data.ITP_Hits         = []; data.ITP_CRs        = [];
data.ITP_D            = []; data.ITP_Z          = [];

for s = 1:nSubjs
    
    dataIn = load([dataPath 'subj' subjects{s} '/' fileName '.mat']);
    
    temp                    = subjChanInfo(subjects{s});
    data.nSubjLPCchans(s)   = numel(temp.LPC);
    data.LPCchanId          = [data.LPCchanId temp.LPC];
    data.subjChans          = [data.subjChans s*ones(1,data.nSubjLPCchans(s))];
    
    ROIid   =   1*ismember(temp.LPC,temp.IPS) + ...
        2*ismember(temp.LPC,temp.SPL) + ...
        3*ismember(temp.LPC,temp.AG);
    subROIid=   1*ismember(temp.LPC,temp.pIPS) + ...
        2*ismember(temp.LPC,temp.aIPS) + ...
        3*ismember(temp.LPC,temp.pSPL) + ...
        4*ismember(temp.LPC,temp.aSPL);
    
    data.ROIid              = [data.ROIid; ROIid'];
    data.subROIid           = [data.subROIid; subROIid'];
    
    chans                   = dataIn.data.chanInfo.LPC;
    data.phase{s}           = squeeze(dataIn.data.phase(chans,:,:));
    
    data.ITC_Hits           = [data.ITC_Hits;dataIn.data.ITC_H(chans,:)];
    data.ITC_CRs            = [data.ITC_CRs;dataIn.data.ITC_CR(chans,:)];
    data.ITC_D              = [data.ITC_D;dataIn.data.ITC_D(chans,:)];
    data.ITC_Z              = [data.ITC_Z;dataIn.data.ITC_Z(chans,:)];
    
    data.ITP_Hits           = [data.ITP_Hits;dataIn.data.ITP_H(chans,:)];
    data.ITP_CRs            = [data.ITP_CRs;dataIn.data.ITP_CR(chans,:)];
    data.ITP_D              = [data.ITP_D;dataIn.data.ITP_D(chans,:)];
    data.ITP_Z              = [data.ITP_Z;dataIn.data.ITP_Z(chans,:)];
    
    data.Hits{s}            = dataIn.data.Hits;
    data.CRs{s}             = dataIn.data.CRs;
    data.RTs{s}             = dataIn.data.allRTs;
    data.dPrime(s)          = dataIn.data.behavior.dPrime;
    
    %by block
    data.nSubjBlocks(s) = dataIn.data.nBlocks;
    data.blockIds{s}    = zeros(sum(dataIn.data.nevents),1);
    endIds              = cumsum(dataIn.data.nevents);
    startIds            = endIds-dataIn.data.nevents+1;
    for bl = 1:data.nSubjBlocks(s)
        ids     = startIds(bl):endIds(bl);
        data.blockIds{s}(ids) = bl;
        h   = dataIn.data.behavior.hits(ids); cr = dataIn.data.behavior.cr(ids);
        m   = dataIn.data.behavior.miss(ids); fa = dataIn.data.behavior.fa(ids);
        nH  = sum(h);
        nM  = sum(m);
        nFA = sum(fa);
        nCR = sum(cr);
        data.dP_Block(s,bl) = calc_dPrime(nH,nM,nFA,nCR);
        data.HR_Block(s,bl) = nH/(nH+nM);
        data.FAR_Block(s,bl) = nFA/(nCR+nFA);
    end
end

data.SR             = dataIn.data.SR;
data.nTrialSamps    = numel(dataIn.data.trialTime);
data.trialDur       = dataIn.data.trialDur;
data.trialTime      = linspace(data.trialDur(1),data.trialDur(2),data.nTrialSamps);

data.winSize        = 0.05; % in seconds
data.sldWin         = data.winSize/2;
[data.binSamps  data.bins] = getBinSamps(data.winSize,data.sldWin,data.trialTime);
data.nBins          = size(data.bins,1);

nChans = numel(data.subjChans);

data.BinITC_Z       = zeros(nChans,data.nBins);
data.BinITP_Z       = zeros(nChans,data.nBins);

for b = 1:data.nBins
    data.BinITC_Z(:,b) =  mean(data.ITC_Z(:,data.binSamps(b,:)),2);
    data.BinITP_Z(:,b) =  mean(data.ITP_Z(:,data.binSamps(b,:)),2);
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

