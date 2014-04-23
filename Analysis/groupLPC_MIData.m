function data = groupLPC_MIData(opts)
% groups LPC channel data by subject.

% data parameters
subjects    = opts.subjects;
reference   = opts.reference;
nRefChans   = opts.nRefChans;
lockType    = opts.lockType;
type        = opts.type;
ampBand     = opts.ampBand;
phaseBand   = opts.phaseBand;

dataPath    = ['~/Documents/ECOG/Results/MI_Data/'];
preFix      = [type '_AMP' ampBand '_PHASE' phaseBand];
extension   = [lockType 'Lock' reference num2str(nRefChans)] ;
fileName    = [preFix extension];

nSubjs  = numel(subjects);

data                = [];
data.options        = opts;
data.fileParams=fileName;
data.prefix         = preFix;
data.extension      = extension;
data.options        = opts;
data.subjChans      = [];
data.LPCchanId      = [];
data.ROIid          = []; data.ROIs = {'IPS','SPL','AG'};
data.subROIid       = []; data.subROIs = {'pIPS','aIPS','pSPL','aSPL'};

data.nPhBins = 20; nPhBins = data.nPhBins;

data.MI_mHits       = []; data.MI_mCRs        = [];
data.MI_HHits       = []; data.MI_HCRs        = [];
data.MI_Z          = [];

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
    
    H   = dataIn.data.Hits;
    CRs = dataIn.data.CRs;    

    data.ROIid              = [data.ROIid; ROIid'];
    data.subROIid           = [data.subROIid; subROIid'];
    
    chans                   = dataIn.data.chanInfo.LPC;
      
    data.MI_mHits           = [data.MI_mHits;squeeze(mean(dataIn.data.mi(chans,H,:),2))];
    data.MI_mCRs            = [data.MI_mCRs;squeeze(mean(dataIn.data.mi(chans,CRs,:),2))];
    data.MI_Z               = [data.MI_Z; dataIn.data.miZ(chans,:)];
      
    data.Hits{s}            = H;
    data.CRs{s}             = CRs;
    data.RTs{s}             = dataIn.data.allRTs;
    data.dPrime(s)          = dataIn.data.behavior.dPrime;
end

data.MI_HHits = Entropy(data.MI_mHits);
data.MI_HCRs  = Entropy(data.MI_mCRs);

data.phaseBinEdges = dataIn.data.phaseBinEdges;
data.phaseBinCenters = dataIn.data.phaseBinCenters;

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

