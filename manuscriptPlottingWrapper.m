%% Figure 2: HighGammaPower IPS/SPL traces and Renderings
addpath Plotting/

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
opts.aRatio         = [500 300];
opts.renderType     = 'SmoothCh';%{'SmoothCh','UnSmoothCh', 'SigChans','SignChans'};
opts.limitDw        = -4;
opts.limitUp        = 4;
opts.absLevel       = 1;
opts.resolution     = 400;

opts.subjects       = {'16b','18','24','28','17b','19', '29'};
opts.hemId          = {'l'  ,'l' ,'l' ,'l' ,'r'  ,'r' , 'r'};

opts.measType       = 'm';     % {'m','z','c','Zc'}
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

plotFigure2(data1,data2,opts);

%% Figure 3: Channel wise classification accuracy /

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