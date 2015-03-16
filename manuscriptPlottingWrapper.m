%% Figure 1: HighGammaPower IPS/SPL traces and Renderings
cd ~/Documents/ECOG/scripts/

addpath Plotting/
addpath lib/

opts                = [];
opts.hem           = 'l';
opts.lockType       = 'stim';
opts.reference      = 'nonLPCleasL1TvalCh';
opts.nRefChans      = 10;
opts.type           = 'power';
opts.band           = 'hgam';
opts.smoother       = 'loess';
opts.smootherSpan   = 0.15;
opts.yLimits        = [-0.6 1.6];
opts.timeLims       = [0 1; -1 0.2]; % statistcs evaluation; first row for stim
opts.aRatio         = [500 300];
opts.renderType     = 'SmoothCh';%{'SmoothCh','UnSmoothCh', 'SigChans','SignChans'};
opts.limitDw        = -4;
opts.limitUp        = 4;
opts.absLevel       = 1;
opts.Pthr           = 0.01;
opts.resolution     = 600;

opts.subjects       = {'16b','18','24','28','30','17b','19', '29'};
opts.hemId          = {'l'  ,'l' ,'l' ,'l' , 'l', 'r'  ,'r' , 'r'};

opts.measType       = 'm';     % {'m','z','c','Zc'}
opts.comparisonType = 'ZStat'; % {ZStat,ZcStat}

opts.baselineType   = 'sub';
opts.analysisType   = 'logPower';
opts.mainPath       = '../Results/' ;
opts.dataPath       = [opts.mainPath 'Spectral_Data/group/'];
opts.preFix         = ['ERSPs' opts.band];
opts.plotPath       = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ',... '
    'Manuscript Figures/Fig1/'];

opts.extension1  = [ 'stimLock' opts.baselineType opts.analysisType opts.reference ...
    num2str(opts.nRefChans)] ;
opts.extension2  = [ 'RTLock' opts.baselineType opts.analysisType opts.reference ...
    num2str(opts.nRefChans)] ;

fileName1        = ['all' opts.preFix 'Group' opts.extension1 '.mat'];
fileName2        = ['all' opts.preFix 'Group' opts.extension2 '.mat'];
load([opts.dataPath fileName1]);
data1            = data;
load([opts.dataPath fileName2]);
data2            = data;
clear data; close all

plotHGPTracesByChan(data1,data2,opts);
%plotHGPTracesBySubj(data1,data2,opts);

addpath Plotting/
addpath lib/

% channels
opts.plotPath       = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ',... '
    'Manuscript Figures/Fig1/'];
opts.level          = 'group'; %{'group','subj'}
opts.cortexType     = 'MNI'; %{'Native','MNI'}
opts.chanNumLabel   = false; %{true,false}
opts.ROIColor       = true; %{true,false}
opts.ROIColors      = [[0.9 0.2 0.2];[0.1 0.5 0.8];[0.2 0.6 0.3]];
opts.subROIColor    = false; %{true,false}
opts.subROIColors   = [[0.7 0.1 0.1]; [0.95 0.4 0.4]; [0.05 0.3 0.7];[0.2 0.6 0.9]];
opts.resolution     = 300;

%renderChansFig1(data1,opts)

%% Figure 2: clusters

addpath Plotting/
addpath Analysis/
addpath lib/
close all

opts                = [];
opts.smoother       = 'loess';
opts.smootherSpan   = 0.15;
opts.resolution     = 600;
opts.Pthr           = 0.01;
opts.timeLims       = [0 1; -1 0.2]; % statistcs evaluation; first row for stim
opts.plotPath       = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ',...
    'Manuscript Figures/Fig2/'];

dataPath= '../Results/Spectral_Data/group/';
pre     = 'allERSPshgamGroup';
post    = 'LocksublogPowernonLPCleasL1TvalCh10.mat';

load([dataPath 'clusters/K2Clusters' pre 'stim' post]);
clusterSet1 = out;
load([dataPath 'clusters/K2Clusters' pre 'RT' post]);
clusterSet2 = out;

load([dataPath pre 'stim' post]);
data1       = data;
load([dataPath pre 'RT' post]);
data2       = data;

plotHGPclustersFig2(data1,clusterSet1,data2,clusterSet2,opts)
%
%
%% supplement for cluster 3,4
ClusterSet = cell(4,1);
load([dataPath 'clusters/K3Clusters' pre 'stim' post]);
ClusterSet{1} = out;
load([dataPath 'clusters/K3Clusters' pre 'RT' post]);
ClusterSet{2} = out;
load([dataPath 'clusters/K4Clusters' pre 'stim' post]);
ClusterSet{3} = out;
load([dataPath 'clusters/K4Clusters' pre 'RT' post]);
ClusterSet{4} = out;

plotHGPclustersK3and4(ClusterSet,opts)
%% Figure 3: Channel wise classification accuracy

close all;
opts                = [];
opts.lockType1       = 'stim';
opts.dataType1       = 'power'; opts.bands1        = {'hgam'};
opts.lockType2       = 'RT';
opts.dataType2       = 'power'; opts.bands2        = {'hgam'};

opts.subjects       = [1:4]; % left subjects
opts.ROIs           = [1 2]; % roi 1 and 2, IPS and SPL
opts.ROIids         = true;  % plot roi colors
opts.lims = [0.45 0.78];

opts.rendLimits     = [-0.15 0.15];
opts.resolution     = 400;
opts.baseLineY      = 0;

opts.timeType       = 'Bin';
opts.channelGroupingType      = 'channel';
opts.timeFeatures   = 'trial';
opts.extStr         = 'liblinearS0';%'NNDTW_K5';

opts.timeStr1     = '0msTo1000ms';
opts.timeStr2     = 'n800msTo200ms';

dataPath = ['../Results/Classification/group/'];

fileName1 = [ opts.dataType1 '/' opts.channelGroupingType '/' 'SumallSubjsClassXVB' ...
    opts.lockType1 'Lock' opts.timeStr1 opts.dataType1 cell2mat(opts.bands1) '_tF' opts.timeFeatures ...
    '_tT' opts.timeType '_gT' opts.channelGroupingType '_Solver' opts.extStr];

fileName2 = [ opts.dataType2 '/' opts.channelGroupingType '/' 'SumallSubjsClassXVB' ...
    opts.lockType2 'Lock' opts.timeStr2 opts.dataType2 cell2mat(opts.bands2) '_tF' opts.timeFeatures ...
    '_tT' opts.timeType '_gT' opts.channelGroupingType '_Solver' opts.extStr];

fileName3 = [ opts.dataType1 '/ROI/' 'allSubjsClassXVB' ...
    opts.lockType1 'Lock' opts.timeStr1 opts.dataType1 cell2mat(opts.bands1) '_tF' opts.timeFeatures ...
    '_tT' opts.timeType '_gTROI_Solver' opts.extStr];

fileName4 = [ opts.dataType1 '/ROI/' 'allSubjsClassXVB' ...
    opts.lockType2 'Lock' opts.timeStr2 opts.dataType1 cell2mat(opts.bands1) '_tF' opts.timeFeatures ...
    '_tT' opts.timeType '_gTROI_Solver' opts.extStr];

opts.fileName = fileName1;
opts.fileName = fileName2;
load([dataPath fileName1])
data1 = S; % stimLock by Channel
load([dataPath fileName2])
data2 = S; % RTLock by Channel
load([dataPath fileName3])
data3 = S; % stimLock by ROI
load([dataPath fileName4])
data4 = S; % stimLock by ROI


opts.savePath = '/Users/alexg8/Google Drive/Research/ECoG Manuscript/ECoG Manuscript Figures/Fig3/';
close all
plotFigure3(data1,data2,data3,data4,opts)

%% plot ERP figure

cd ~/Documents/ECOG/scripts/

addpath Plotting/
addpath lib/

opts                = [];           opts.hem           = 'l';
opts.nRefChans      = 10;           opts.type           = 'erp';
opts.smoother       = 'loess';      opts.smootherSpan   = 0.15;
opts.lockType       = 'stim';       opts.reference      = 'nonLPCleasL1TvalCh';
opts.Pthr           = 0.01;         opts.timeLims       = [0 1; -1 0.2];

opts.subjects       = {'16b','18','24','28','17b','19', '29'};
opts.hemId          = {'l'  ,'l' ,'l' ,'l' ,'r'  ,'r' , 'r'};

opts.measType       = 'm';     % {'m','z','c','Zc'}
opts.comparisonType = 'ZStat'; % {ZStat,ZcStat}

opts.baselineType   = 'sub';
opts.analysisType   = 'Amp';
opts.mainPath       = '../Results/' ;
opts.dataPath       = [opts.mainPath 'ERP_Data/group/'];
opts.preFix         = 'ERPs';
opts.plotPath       = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ',... '
    'Manuscript Figures/supplement/'];

opts.extension1  = [ 'stimLock' opts.baselineType opts.analysisType opts.reference ...
    num2str(opts.nRefChans)] ;
opts.extension2  = [ 'RTLock' opts.baselineType opts.analysisType opts.reference ...
    num2str(opts.nRefChans)] ;

fileName1        = ['all' opts.preFix 'Group' opts.extension1 '.mat'];
fileName2        = ['all' opts.preFix 'Group' opts.extension2 '.mat'];
load([opts.dataPath fileName1]);
data1            = data;
load([opts.dataPath fileName2]);
data2            = data;
clear data; close all

plotERPsByChan(data1,data2, opts)
%% Figure XXX: HGP-RT correlation

addpath Plotting/

opts                = [];
opts.hem           = 'l';
opts.lockType       = 'stim';
opts.reference      = 'nonLPCleasL1TvalCh';
opts.nRefChans      = 10;
opts.type           = 'power';
opts.band           = 'hgam';
opts.smoother       = 'loess';
opts.smootherSpan   = 0.01;
opts.yLimits        = [-0.25 0.25];
opts.aRatio         = [500 300];
opts.renderType     = 'SmoothCh';%{'SmoothCh','UnSmoothCh', 'SigChans','SignChans'};
opts.limitDw        = -3;
opts.limitUp        = 3;
opts.absLevel       = 1;
opts.resolution     = 400;

opts.subjects       = {'16b','18','24','28','17b','19', '29'};
opts.hemId          = {'l'  ,'l' ,'l' ,'l' ,'r'  ,'r' , 'r'};

opts.measType       = 'c';     % {'m','z','c','Zc'}
opts.comparisonType = 'ZStat'; % {ZStat,ZcStat}

opts.baselineType   = 'sub';
opts.analysisType   = 'logPower';
opts.mainPath       = '../Results/' ;
opts.dataPath       = [opts.mainPath 'Spectral_Data/group/'];
opts.preFix         = ['ERSPs' opts.band];
opts.plotPath       = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ',... '
    'Manuscript Figures/individualPlotsPDFs/'];

opts.extension1  = [ 'stimLock' opts.baselineType opts.analysisType opts.reference ...
    num2str(opts.nRefChans)] ;
opts.extension2  = [ 'RTLock' opts.baselineType opts.analysisType opts.reference ...
    num2str(opts.nRefChans)] ;

fileName1        = ['all' opts.preFix 'Group' opts.extension1 '.mat'];
fileName2        = ['all' opts.preFix 'Group' opts.extension2 '.mat'];
load([opts.dataPath fileName1]);
data1            = data;
load([opts.dataPath fileName2]);
data2            = data;
clear data; close all

plotHGP_RTcorr(data1,data2,opts);