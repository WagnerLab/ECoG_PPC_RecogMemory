%% ecog processing wrapper

%% preprocess data
addpath PreProcessing/
addpath lib/
for s ={'30'};%{'16b','18','24','28'}
    preProcessRawData(s{1},'SS2')
end

%% re-reference
addpath PreProcessing/
addpath lib/
%dateStr = '27-May-2013';
%subjects = {'16b','18','24','28'};
%dateStr = '17-Jun-2013';
subjects = {'30'};
%subjects = {'17b','19','29'};
%reference = 'origCAR'; nRefChans = 0;
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
dataPath = '../Results/';
for s = subjects
    dataIn = load([dataPath 'ERP_Data/subj' s{1} '/BandPassedSignals/BandPass.mat']);
    if strcmp(reference,'nonLPCleasL1TvalCh')
        dataIn.data.refInfoFile = [dataPath 'ERP_Data/subj' s{1} '/ERPsstimLocksubAmporigCAR0.mat'];
        data2=load(dataIn.data.refInfoFile);
        dataIn.data.RefChanTotalTstat =data2.data.chanTotalTstat; clear data2;
    end
    data = reReferenceData(dataIn.data,reference,nRefChans);
    save([dataPath 'ERP_Data/subj' s{1} '/BandPassedSignals/BandPass' reference num2str(data.nRefChans)],'data')
end

%% calc ERPs
addpath PreProcessing/
addpath Analysis/
addpath lib/

%dateStr = '27-May-2013';
%subjects = {'16b','18','24','28'};
subjects = {'30'};
%dateStr = '17-Jun-2013';
%subjects = {'17b','19','29'};
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
%reference = 'origCAR'; nRefChans = 0;
%reference = 'allChCAR'; nRefChans = 0;
lockType = 'RT'; %{'stim','RT'}
dataPath = '../Results/';
analysisType = 'Amp';%{'Amp','Power', 'logPower'};
baselineType = 'sub';%{'rel','sub'}
for s = subjects
    dataIn = load([dataPath 'ERP_Data/subj' s{1} '/BandPassedSignals/BandPass' reference num2str(nRefChans)]);
    dataIn.data.lockType = lockType;
    dataIn.data.analysisType = analysisType;
    dataIn.data.baselineType = baselineType;
    switch lockType
        case 'stim'
            data = calcERP(dataIn.data);
            save([dataPath 'ERP_Data/subj' s{1} '/ERPsstimLock' baselineType analysisType ...
                reference num2str(nRefChans) '.mat'],'data')
        case 'RT'
            % load stim locked data
            dataIn2 = load([dataPath 'ERP_Data/subj' s{1} '/ERPsstimLock' baselineType analysisType ...
                reference num2str(nRefChans) '.mat']);
            dataIn.data.baseLineMeans = dataIn2.data.baseLineMeans; dataIn2=[];
            data = calcERP(dataIn.data);
            save([dataPath 'ERP_Data/subj' s{1} '/ERPsRTLock' baselineType analysisType ...
                reference num2str(nRefChans) '.mat'],'data')
    end
end

fprintf('calc ERP done\n')

%% plot CAR and reverse signals;

addpath Plotting/

%dateStr = '27-May-2013';
%subjects = {'16b','18','24','28'};
dateStr = '17-Jun-2013';
subjects = {'17b','19','29'};
lockType = 'stim';
baselineType = 'sub';
analysisType = 'Amp';
reference = 'allChCAR'; nRefChans = 0;
%reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
dataPath = '../Results/';

for s = subjects
    load([dataPath 'ERP_Data/subj' s{1} '/ERPs' lockType 'Lock' baselineType analysisType ...
        reference num2str(nRefChans) dateStr '.mat']);
    x = data.CARSignal; % common signal
    y = fliplr(x); % reverser common signal
    figure; clf;
    h = plot2Traces(x(data.evIdx),y(data.evIdx),linspace(-2,2,1744),'rb');xlim([-0.2 1]);
    set(gca,'linewidth',2)
    set(gca,'fontweight','bold')
    set(gca,'fontsize',15);
    h2 = legend([h.h1.mainLine, h.h2.mainLine],'CAR','reverse');
    set(h2,'box','off')
    fileName = [dataPath '/Plots/ERPs/other/subj' s{1} 'MeanCARSignal' reference num2str(nRefChans) dateStr];
    print(h.f,'-dtiff','-r100',fileName);
end

%% plot erps
addpath Plotting/
close all
dateStr = '27-May-2013'; subjects = {'16b','18','24','28'};
%dateStr = '17-Jun-2013'; subjects = {'17b','19','29'};
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
%reference = 'origCAR'; nRefChans = 0;

dataPath = '../Results/';
opts                = [];
opts.plotPath       = [dataPath 'Plots/ERPs/'];
opts.type           = 'erp';
opts.lockType       = 'RT';
opts.smoother       = 'loess';
opts.smootherSpan   = 0.15;
opts.analysisType   = 'Amp';
opts.baselineType   = 'sub';

for s = subjects
    dataIn = load([dataPath 'ERP_Data/subj' s{1} '/ERPs' opts.lockType 'Lock' opts.baselineType opts.analysisType ...
        reference num2str(nRefChans) dateStr '.mat']);
    plotERPs(dataIn.data,opts);
end

%% bandpass data

addpath PreProcessing/

%dateStr = '27-May-2013';
subjects = {'30'};
%subjects = {'16b','18','24','28'};
%dateStr = '17-Jun-2013';
%subjects = {'17b','19','29'};
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
dataPath = '../Results/';
for s = subjects
    dataIn = load([dataPath 'ERP_Data/subj' s{1} '/BandPassedSignals/BandPass' reference num2str(nRefChans) ]);
    for band = {'hgam'};%{'theta','alpha','beta','lgam','hgam','bb'};
        data = dataDecompose(dataIn.data,band{1});
        save([dataPath 'Spectral_Data/subj' s{1} '/BandPassedSignals/BandPass' band{1} reference num2str(nRefChans) '.mat'],'data')
    end
end

%% calc ERSPs

addpath Analysis/

%dateStr = '27-May-2013';
%subjects = {'16b','18','24','28'};
subjects = {'30'};
%dateStr = '17-Jun-2013';
%subjects = {'17b','19','29'};
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
lockType = 'RT';
dataPath = '../Results/';
analysisType = 'logPower';%{'Amp','Power', 'logPower'};
baselineType = 'sub';%{'rel','sub'}
for s = subjects
    for band = {'hgam'}%{'delta','theta','alpha','beta','lgam','hgam','bb'};
        %dataIn = load([dataPath 'Spectral_Data/subj' s{1} '/BandPassedSignals/BandPass' band{1}  reference num2str(nRefChans) dateStr '.mat']);
        dataIn = load([dataPath 'Spectral_Data/subj' s{1} '/BandPassedSignals/BandPass' band{1}  reference num2str(nRefChans)  '.mat']);
        dataIn.data.lockType = lockType;
        dataIn.data.analysisType = analysisType;
        dataIn.data.baselineType = baselineType;
        switch lockType
            case 'stim'
                data = calcERSP(dataIn.data);
                save([dataPath 'Spectral_Data/subj' s{1} '/ERSPs' band{1} 'stimLock' baselineType analysisType ...
                    reference num2str(nRefChans) '.mat'],'data')
            case 'RT'
                % load stim locked data
                dataIn2 = load([dataPath 'Spectral_Data/subj' s{1} '/ERSPs' band{1} 'stimLock' baselineType analysisType ...
                    reference num2str(nRefChans) '.mat']);
                dataIn.data.baseLineMeans = dataIn2.data.baseLineMeans; dataIn2=[];
                data = calcERSP(dataIn.data);
                save([dataPath 'Spectral_Data/subj' s{1} '/ERSPs' band{1} 'RTLock' baselineType analysisType ...
                    reference num2str(nRefChans) '.mat'],'data')
        end
    end
end

%% plot ersps
subjects = {'30'};
%subjects = {'17b','19','29'};
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
addpath Plotting/
dataPath = '../Results/';

opts = [];
opts.plotPath = [dataPath 'Plots/Spectral/'];
opts.lockType = 'stim';
opts.baselineType = 'sub';
opts.analysisType = 'logPower';
opts.type = 'power';
opts.smoother = 'loess';
opts.smootherSpan = 0.15;
for s = subjects
    for band = {'hgam'}%{'delta','theta','alpha','beta','lgam','hgam','bb'};
        dataIn = load([dataPath 'Spectral_Data/subj' s{1} '/ERSPs' band{1} opts.lockType 'Lock' opts.baselineType opts.analysisType ...
            reference num2str(nRefChans) '.mat']);
        plotERPs(dataIn.data,opts);
    end
end

%% group data

addpath Analysis/
addpath lib/

bands = {'hgam'};%{'erp','hgam','delta','theta','alpha','beta','lgam','hgam'};

opts = [];
opts.hems = 'all';
opts.lockType = 'RT';
opts.reference = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
opts.subjects       = {'16b','18','24','28','30','17b','19', '29'};
opts.hemId          = {'l'  ,'l' ,'l' ,'l' ,'l','r'  ,'r' , 'r'};

dataPath = '../Results/';

for ba = 1:numel(bands)
    opts.type   = bands{ba};
    if strcmp(opts.type,'erp')
        dataPath = [dataPath 'ERP_Data/group/'];
    else
        dataPath = [dataPath 'Spectral_Data/group/'];
    end
    data        = groupLPCData(opts);
    fileName    = [opts.hems data.prefix 'Group' data.extension];
    
    save([dataPath fileName '.mat'],'data')
    fprintf('grouping data completed for %s\n',opts.type)
end

%% render channels

close all
opts                = [];
opts.mainPath       = '../Results/Plots/Renderings/channels/' ;
opts.level          = 'subj'; %{'group','subj'}
opts.cortexType     = 'MNI'; %{'Native','MNI'}
opts.chanNumLabel   = false; %{true,false}
opts.ROIColor       = true; %{true,false}
opts.ROIColors      = [[0.9 0.2 0.2];[0.1 0.5 0.8];[0.2 0.6 0.3]];
opts.subROIColor    = false; %{true,false}
opts.subROIColors   = [[0.7 0.1 0.1]; [0.95 0.4 0.4]; [0.05 0.3 0.7];[0.2 0.6 0.9]];
opts.resolution     = 300;

renderCortex(data,opts)

%% calc ITC

addpath Analysis/
addpath lib/

dateStr = '27-May-2013';
subjects = {'16b','18','24','28'};
dateStr = '17-Jun-2013';
subjects = {'17b','19','29'};
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
lockType = 'RT';
dataPath = '../Results/';

for s = subjects
    for band = {'delta','theta','alpha'}%{'delta','theta','alpha','beta','lgam','hgam','bb'};
        dataIn = load([dataPath 'Spectral_Data/subj' s{1} '/BandPassedSignals/BandPass' ...
            band{1}  reference num2str(nRefChans) dateStr '.mat']);
        dataIn.data.lockType = lockType;
        
        data = calcITC(dataIn.data);
        savePath = [dataPath 'ITC_Data/subj' s{1} '/'];
        if ~exist(savePath,'dir'), mkdir(savePath), end;
        save([savePath '/ITC' band{1} lockType 'Lock' reference num2str(nRefChans) '.mat'],'data')
    end
end

%% group ITC

addpath Analysis/

for bands = {'delta','theta','alpha'}
    
    opts            = [];
    opts.hems       = 'all';
    opts.lockType   = 'RT';
    opts.reference  = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
    opts.type       = 'ITC';
    opts.band       = bands{1};
    
    opts.subjects   = {'16b','18','24','28','17b','19', '29'};
    opts.hemId      = {'l'  ,'l' ,'l' ,'l' ,'r'  ,'r' , 'r'};
    dataPath        = '~/Documents/ECOG/Results/ITC_Data/group/';
    
    data = groupLPC_ITCData(opts);
    
    fileName = [opts.hems data.prefix 'Group' data.extension];
    save([dataPath fileName '.mat'],'data')
    
    fprintf('grouping data completed for %s\n',opts.band)
end

%% calc MI

%dateStr = '27-May-2013';
%subjects = {'16b','18','24','28'};
dateStr = '17-Jun-2013';
subjects = {'17b','19','29'};
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
lockType = 'stim';
dataPath = '../Results/';

for s = subjects
    for AmpBand = {'hgam'}
        data1 = load([dataPath 'Spectral_Data/subj' s{1} '/BandPassedSignals/BandPass' ...
            AmpBand{1}  reference num2str(nRefChans) dateStr '.mat']);
        
        for PhaseBand = {'delta','theta','alpha','beta'}
            data2 = load([dataPath 'Spectral_Data/subj' s{1} '/BandPassedSignals/BandPass' ...
                PhaseBand{1}  reference num2str(nRefChans) dateStr '.mat']);
            
            data = calcMI(data1.data,data2.data,lockType);
            savePath = [dataPath 'MI_Data/subj' s{1} '/'];
            
            if ~exist(savePath,'dir'), mkdir(savePath), end;
            save([savePath '/MI_AMP' AmpBand{1} '_PHASE' PhaseBand{1} ...
                lockType 'Lock' reference num2str(nRefChans) '.mat'],'data')
        end
    end
end

%% group MI

% to do ... (noted on Oct. 22 2013 )

opts = [];
opts.hems       = 'all';
opts.lockType = 'stim';
opts.reference = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
opts.type = 'MI';
opts.ampBand = 'hgam';

opts.subjects   = {'16b','18','24','28','17b','19', '29'};
opts.hemId      = {'l'  ,'l' ,'l' ,'l' ,'r'  ,'r' , 'r'};

dataPath = '../Results/MI_Data/group/';
for bands = {'theta'}
    
    opts.phaseBand = bands{1};
    
    data = groupLPC_MIData(opts);
    
    fileName = [opts.hems 'Group' data.fileParams];
    save([dataPath fileName '.mat'],'data')
    
end

%% plot roi level data

addpath Plotting
addpath lib

opts                = [];
opts.hems           = 'l';
opts.lockType       = 'stim';
opts.reference      = 'nonLPCleasL1TvalCh';
opts.nRefChans      = 10;
opts.type           = 'power';
opts.band           = 'hgam';
opts.smoother       = 'loess';
opts.acrossWhat     = 'Channels';
opts.smootherSpan   = 0.15;
opts.yLimits        = [-0.6 1.5];
opts.aRatio         = [500 300];

opts.subjects       = {'16b','18','24','28','30','17b','19', '29'};
opts.hemId          = {'l'  ,'l' ,'l' ,'l' ,'l','r'  ,'r' , 'r'};

opts.mainPath = '../Results/' ;
if strcmp(opts.type,'erp')
    opts.measType       = 'm';      % {'m','z','c','Zc'}
    opts.comparisonType = 'ZStat';  % {ZStat,ZcStat}
    opts.baselineType   = 'sub';
    opts.analysisType   = 'Amp';
    opts.dataPath       = [opts.mainPath 'ERP_Data/group/'];
    opts.preFix         = 'ERPs' ;
    opts.plotPath       = [opts.mainPath 'Plots/ERPs/'  opts.hems '/'];
    opts.band           = '';
elseif strcmp(opts.type,'power')
    opts.measType       = 'm';     % {'m','z','c','Zc'}
    opts.comparisonType = 'ZStat'; % {ZStat,ZcStat}
    opts.baselineType   = 'sub';
    opts.analysisType   = 'logPower';
    opts.dataPath       = [opts.mainPath 'Spectral_Data/group/'];
    opts.preFix         = ['ERSPs' opts.band];
    opts.plotPath       = [opts.mainPath 'Plots/Spectral/' opts.hems '/'];
elseif strcmp(opts.type,'ITC')
    opts.measType       = 'ITC_';
    opts.comparisonType = 'ITC_Z';
    opts.baselineType   = '';
    opts.analysisType   = '';
    opts.dataPath       = [opts.mainPath 'ITC_Data/group/'];
    opts.preFix         = ['ITC' opts.band];
    opts.plotPath       = [opts.mainPath 'Plots/ITC/' opts.hems '/'];
end

opts.extension  = [opts.lockType 'Lock' opts.baselineType opts.analysisType opts.reference ...
    num2str(opts.nRefChans)] ;
fileName        = ['all' opts.preFix 'Group' opts.extension '.mat'];
load([opts.dataPath fileName])
close all

plotROI_ERPs(data,opts)

switch opts.lockType
    case 'RT'
        opts.timeLims   = [-0.6 0.1];
        opts.timeStr     = 'n600msTo100ms';
    case 'stim'
        opts.timeLims   = [0 1];
        opts.timeStr     = '0msTo1000ms';
end

% opts.aspectRatio = [50 300];
% opts.hem        = 1;
% opts.yLimits    = [-0.5 1];
%
% opts.ROInums    = [1];
% conditionBarPlotsWrapper (data, opts)
% opts.ROInums    = [2];
% conditionBarPlotsWrapper (data, opts)
%plotSubROI_ERPs(data,opts)

%% Bar accross bands per ROI accross multiple bands

addpath Plotting/

close all
opts                = [];
opts.hems           = 'l';
opts.lockType       = 'stim';
opts.reference      = 'nonLPCleasL1TvalCh';
opts.nRefChans      = 10;
opts.type           = 'power';
opts.bands           = {'theta'};
opts.smoother       = 'loess';
opts.smootherSpan   = 0.15;
opts.yLimits        = [-6 1.5];
opts.aRatio         = [50 300];

opts.subjects       = {'16b','18','24','28','17b','19', '29'};
opts.hemId          = {'l'  ,'l' ,'l' ,'l' ,'r'  ,'r' , 'r'};

opts.mainPath = '../Results/' ;

opts.measType       = 'm';     % {'m','z','c','Zc'}
opts.comparisonType = 'ZStat'; % {ZStat,ZcStat}
opts.baselineType   = 'sub';
opts.analysisType   = 'logPower';
opts.dataPath       = [opts.mainPath 'Spectral_Data/group/'];
opts.plotPath       = [opts.mainPath 'Plots/Spectral/' opts.hems '/'];

switch opts.lockType
    case 'RT'
        opts.timeLims   = [-0.6 0.1];
        opts.timeStr     = 'n600msTo100ms';
    case 'stim'
        opts.timeLims   = [0 0.9];
        opts.timeStr     = '0msTo900ms';
end

opts.aspectRatio = [600 300];
opts.hem        = 1;

opts.ROInums    = [1];
plotROI_TC_multiband(opts)

opts.ROInums    = [2];
plotROI_TC_multiband(opts)

opts.yLimits    = [-2.5 1];
opts.yTicks     = [-2 -1 0];
conditionBarMultiBandWrapper(opts)


opts.ROInums    = [2];
% opts.yLimits    = [-5.5 1];
% opts.yTicks     = [-4 -2 0];
opts.yLimits    = [-2.5 1];
opts.yTicks     = [-2 -1 0];
conditionBarMultiBandWrapper(opts)

%% mni group renderings

addpath Plotting/
close all
opts                = [];
opts.hem            = 'l';
opts.lockType       = 'RT';
opts.type           = 'power';
opts.band           = 'hgam';
opts.comparisonType = 'BinZStat'; %{'BinTStat','BinpValT','BinpVal','BinZStat','BinpValz','BincondDiff'};
opts.timeType       = 'Bins';
opts.reference      = 'nonLPCleasL1TvalCh';
opts.nRefChans      = 10;
opts.renderType     = 'SmoothCh';%{'SmoothCh','UnSmoothCh', 'SigChans','SignChans'};
opts.limitDw        = -4;
opts.limitUp        = 4;
opts.absLevel       = 1;
opts.resolution     = 400;
opts.avgBins        = [];

opts.subjects       = {'16b','18','24','28','17b','19', '29'};
opts.hemId          = {'l'  ,'l' ,'l' ,'l' ,'r'  ,'r' , 'r'};

opts.mainPath = '../Results/' ;
if strcmp(opts.type,'erp')
    opts.baselineType   = 'sub';
    opts.analysisType   = 'Amp';
    opts.dataPath       = [opts.mainPath 'ERP_Data/group/'];
    opts.preFix         = 'ERPs' ;
    opts.renderPath = [opts.mainPath 'Plots/Renderings/ERPs/'];
elseif strcmp(opts.type,'power')
    opts.baselineType   = 'sub';
    opts.analysisType   = 'logPower';
    opts.dataPath       = [opts.mainPath 'Spectral_Data/group/'];
    opts.preFix         = ['ERSPs' opts.band];
    opts.renderPath     = [opts.mainPath 'Plots/Renderings/Spectral/' opts.band '/'];
elseif strcmp(opts.type,'ITC')
    opts.baselineType   = '';
    opts.analysisType   = '';
    opts.dataPath       = [opts.mainPath 'ITC_Data/group/'];
    opts.preFix         = ['ITC' opts.band];
    opts.renderPath     = [opts.mainPath 'Plots/Renderings/ITC/' opts.band '/'];
end

opts.extension = [opts.lockType 'Lock' opts.baselineType opts.analysisType opts.reference ...
    num2str(opts.nRefChans)] ;
fileName    = ['all' opts.preFix 'Group' opts.extension '.mat'];

load([opts.dataPath fileName])
if ~exist(opts.renderPath,'dir'),mkdir(opts.renderPath),end
renderERPs(data,opts)

%% cluster channels
addpath Plotting/
addpath Analysis//
close all

opts                = [];
opts.hems            = 'l'; opts.hemNum=1;
opts.ROIs           = [1 2];
opts.nClusters      = 3;
opts.lockType       = 'RT';
opts.type           = 'power';
opts.band           = 'hgam';
opts.dtype          = 'ZStat';
opts.smoothData     = true;
opts.reference      = 'nonLPCleasL1TvalCh';
opts.nRefChans      = 10;
opts.plotting       = false;
opts.findSubCluster = true; % only wors for K=2
opts.resolution     = 400;
opts.aRatio         = [500 300];


opts.mainPath = '../Results/' ;
if strcmp(opts.type,'erp')
    opts.measType       = 'm';      % {'m','z','c','Zc'}
    opts.comparisonType = 'ZStat';  % {ZStat,ZcStat}
    opts.baselineType   = 'sub';
    opts.analysisType   = 'Amp';
    opts.dataPath       = [opts.mainPath 'ERP_Data/group/'];
    opts.preFix         = 'ERPs' ;
    opts.plotPath       = [opts.mainPath 'Plots/ERPs/'  opts.hems '/'];
    opts.band           = '';
elseif strcmp(opts.type,'power')
    opts.measType       = 'm';     % {'m','z','c','Zc'}
    opts.comparisonType = 'ZStat'; % {ZStat,ZcStat}
    opts.baselineType   = 'sub';
    opts.analysisType   = 'logPower';
    opts.dataPath       = [opts.mainPath 'Spectral_Data/group/'];
    opts.preFix         = ['ERSPs' opts.band];
    opts.plotPath       = [opts.mainPath 'Plots/Spectral/' opts.hems '/'];
elseif strcmp(opts.type,'ITC')
    opts.measType       = 'ITC_';
    opts.comparisonType = 'ITC_Z';
    opts.baselineType   = '';
    opts.analysisType   = '';
    opts.dataPath       = [opts.mainPath 'ITC_Data/group/'];
    opts.preFix         = ['ITC' opts.band];
    opts.plotPath       = [opts.mainPath 'Plots/ITC/' opts.hems '/'];
end

opts.extension = [opts.lockType 'Lock' opts.baselineType opts.analysisType opts.reference ...
    num2str(opts.nRefChans)] ;
fileName    = ['all' opts.preFix 'Group' opts.extension '.mat'];

load([opts.dataPath fileName])
out=clusterWrapper(data, opts);

fileName2 = ['K' num2str(opts.nClusters) 'Clusters' fileName];
opts.savePath = [opts.dataPath 'clusters/'];
if ~exist(opts.savePath,'dir'), mkdir(opts.savePath),end

save([opts.savePath fileName2],'out')

%% output group data to a csv file and compute stats

addpath Analysis/
clc

opts                = [];
opts.hems           = 'all';
opts.lockType       = 'stim';
opts.reference      = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
%opts.type           = 'erp'; opts.band = '';
opts.type           = 'power'; opts.band = 'hgam';
opts.bin            = 'Bin'; % options are{'BigBin', 'Bin'};
opts.byBlockFlag    = 0;

switch opts.lockType
    case 'RT'
        opts.time   = [-1 0.2];
        timeStr     = 'n1000msTo200ms';
    case 'stim'
        opts.time   = [0 1];
        timeStr     = '0msTo1000ms';
end


dataPath = '../Results/';
if strcmp(opts.type,'erp')
    dataPath = [dataPath 'ERP_Data/group/'];
    fileName = [opts.hems 'ERPsGroup' opts.lockType 'LocksubAmp' ...
        opts.reference num2str(opts.nRefChans)];
elseif strcmp(opts.type,'power')
    dataPath = [dataPath 'Spectral_Data/group/'];
    fileName = [opts.hems 'ERSPs' opts.band 'Group' opts.lockType  ...
        'LocksublogPower' opts.reference num2str(opts.nRefChans)];
elseif strcmp(opts.type,'itc')
    dataPath = [dataPath 'ITC_Data/group/'];
    fileName = [opts.hems 'ITC' opts.band 'Group' opts.lockType  ...
        'Lock' opts.reference num2str(opts.nRefChans)];
end

load([dataPath fileName])
clc

printStats(data,opts)

savePath = '../Results/Rdata/';
blockStr = {'bySubj','byBlock'}; blockStr = blockStr{opts.byBlockFlag+1};
out = exportLPCData2R(data,opts);
csvwrite([savePath opts.bin timeStr fileName blockStr '.csv'],single(out));

%% %%%%%%%%%

%% decoding

clearvars; close all;
addpath Classification/
addpath lib/

LT  = {'stim','RT'};
GT = {'ROI','channel','IPS-SPL'};
for gt = 1:3
    for lt = 1:2;
        opts                = [];
        opts.lockType       = LT{lt};
        opts.reference      = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
        %opts.dataType       = 'erp'; opts.bands          = {''};
        opts.dataType       = 'power'; opts.bands          = {'hgam'};%{'delta','theta','alpha','beta','lgam','hgam'};
        %opts.dataType       = 'power'; opts.bands          = {'erp','delta','theta','alpha','beta','lgam','hgam'};
        opts.toolboxNum     = 1;
        
        % feauture settings
        % timeType distinguishes between decoding individual samples, or taking
        % time  bins
        % options are {'','Bin'};
        opts.timeType       = 'Bin';
        % channelGroupingType makes the distinction between decoding between channels, rois or
        % all channels within LPC
        % options are {'channel','ROI','IPS-SPL','all'};
        opts.channelGroupingType      = GT{gt};
        % timeFeatures distinguishes between takingv the whole trial or taking a
        % window of time
        % options are {'window','trial'};
        opts.timeFeatures   = 'window';
        
        switch opts.lockType
            case 'RT'
                opts.timeLims   = [-0.8 0.2];
                opts.timeStr     = 'n800msTo200ms';
                %         opts.timeLims   = [-0.6 0.1];
                %         opts.timeStr     = 'n600msTo100ms';
            case 'stim'
                %opts.timeLims   = [-0.2 1];
                %opts.timeStr     = 'n200msTo1000ms';
                opts.timeLims   = [0 1];
                opts.timeStr     = '0msTo1000ms';
        end
        
        S = ClassificationWrapper(opts);
        
        savePath = ['../Results/Classification/group/' opts.dataType ...
            '/' opts.channelGroupingType '/'];
        if ~exist(savePath,'dir'),mkdir(savePath), end
        
        fileName = ['allSubjsClassXVB' opts.lockType 'Lock' opts.timeStr opts.dataType cell2mat(opts.bands) '_tF' opts.timeFeatures '_tT' ...
            opts.timeType '_gT' opts.channelGroupingType '_Solver' S.extStr];
        save([savePath fileName],'S')
    end
end
%% summarize performance

addpath Classification/

opts                = [];
opts.lockType       = 'RT';
opts.reference      = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
%opts.dataType       = 'power'; opts.bands          = {'delta','theta','alpha'};
opts.dataType       = 'power'; opts.bands          = {'hgam'};
%opts.dataType       = 'power'; opts.bands          = {'erp','hgam'};
%opts.dataType       = 'power'; opts.bands          = {'delta','theta','alpha','beta','lgam','hgam'};
opts.toolboxNum     = 1;
opts.timeType       = 'Bin';
opts.channelGroupingType      = 'ROI';
opts.timeFeatures   = 'window';
opts.extStr         = 'liblinearS0';%'NNDTWK5';%

switch opts.lockType
    case 'RT'
        opts.timeLims   = [-0.8 0.2];
        opts.timeStr     = 'n800msTo200ms';
        %         opts.timeLims   = [-0.6 0.1];
        %         opts.timeStr     = 'n600msTo100ms';
    case 'stim'
        %opts.timeLims   = [-0.2 1];
        %opts.timeStr     = 'n200msTo1000ms';
        opts.timeLims   = [0 1];
        opts.timeStr     = '0msTo1000ms';
end

dataPath = ['../Results/Classification/group/' opts.dataType ...
    '/' opts.channelGroupingType '/'];

fileName = ['allSubjsClassXVB' opts.lockType 'Lock' opts.timeStr opts.dataType cell2mat(opts.bands) '_tF' opts.timeFeatures '_tT' ...
    opts.timeType '_gT' opts.channelGroupingType '_Solver' opts.extStr];

load([dataPath fileName])
S = SummaryClassification(S,opts);
fileName = ['Sum' fileName];
save([dataPath fileName],'S')

%% plot decoding results

addpath lib/

opts                = [];
opts.lockType       = 'stim';
opts.scoreType      = 'mBAC'; % RTsLogitCorr mBAC
opts.accPlots       = true;
opts.weigthsPlots   = false;
opts.renderPlot     = true;
opts.RTcorrPlots    = false;
opts.stats          = false;
opts.baseLineY      = 0;
opts.rendLimits     = [-0.15 0.15];
opts.resolution     = 400;
opts.reference      = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
opts.toolboxNum     = 1;
opts.dataType       = 'power'; opts.bands          = {'hgam'};
%opts.dataType       = 'power'; opts.bands          = {'delta','theta','alpha'};
%opts.dataType       = 'power'; opts.bands          = {'theta'};
%opts.dataType       = 'power'; opts.bands          = {'delta','theta','alpha','beta','lgam','hgam'};


% accuracy plots options:
opts.accPlotsOpts.indPoints   = false; % plot individual points
opts.accPlotsOpts.horizontal  = false; % horizontal plot
opts.accPlotsOpts.yLimits     = [0.49 0.61]; % horizontal plot
opts.accPlotsOpts.aspectRatio = [200 600];

opts.timeType       = 'Bin';
opts.channelGroupingType      = 'channel';
opts.timeFeatures   = 'trial';
opts.extStr         = 'liblinearS0';%'NNDTW_K5';

dataPath = ['../Results/Classification/group/' opts.dataType ...
    '/' opts.channelGroupingType '/'];

fileName = ['SumallSubjsClass' opts.lockType 'Lock' opts.dataType cell2mat(opts.bands) '_tF' opts.timeFeatures '_tT' ...
    opts.timeType '_gT' opts.channelGroupingType '_Solver' opts.extStr];

opts.fileName = fileName;
load([dataPath fileName])

close all
plotDecodingAcc(S,opts)
%plotFA_MISS_relationToACC

%% plot relationship between channel accuracies

close all;
opts                = [];
opts.lockType1       = 'stim';
opts.dataType1       = 'power'; opts.bands1        = {'theta','hgam'};
%opts.dataType1       = 'power'; opts.bands1          = {'delta','theta','alpha','beta','lgam','hgam'};
opts.lockType2       = 'stim';
opts.dataType2       = 'power'; opts.bands2        = {'hgam'};
%opts.dataType2       = 'power'; opts.bands2          = {'delta','theta','alpha','beta','lgam','hgam'};

opts.subjects       = [1:4]; % left subjects
opts.ROIs           = [1 2]; % roi 1 and 2, IPS and SPL
opts.ROIids         = true;  % plot roi colors
opts.lims = [0.45 0.80];

opts.timeType       = 'Bin';
opts.channelGroupingType      = 'channel';
opts.timeFeatures   = 'trial';
opts.extStr         = 'liblinearS0';%'NNDTW_K5';

dataPath = ['../Results/Classification/group/'];

fileName1 = [ opts.dataType1 '/' opts.channelGroupingType '/' 'SumallSubjsClass' ...
    opts.lockType1 'Lock' opts.dataType1 cell2mat(opts.bands1) '_tF' opts.timeFeatures ...
    '_tT' opts.timeType '_gT' opts.channelGroupingType '_Solver' opts.extStr];

fileName2 = [ opts.dataType2 '/' opts.channelGroupingType '/' 'SumallSubjsClass' ...
    opts.lockType2 'Lock' opts.dataType2 cell2mat(opts.bands2) '_tF' opts.timeFeatures ...
    '_tT' opts.timeType '_gT' opts.channelGroupingType '_Solver' opts.extStr];

opts.fileName = fileName1;
opts.fileName = fileName2;
load([dataPath fileName1])
data1 = S;
load([dataPath fileName2])
data2 = S;

opts.savePath = '/Users/alexg8/Google Drive/Research/ECoG Manuscript/ECoG Manuscript Figures/individualPlotsPDFs';
close all
plotACCRelationshipWrapper(data1,data2,opts)

%% find IPS / SPL time segment matches

clearvars

opts                = [];
opts.lockType       = 'stim';
opts.reference      = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
%opts.dataType       = 'erp'; opts.bands          = {''};
opts.dataType       = 'power'; opts.bands          = {'hgam'};
%opts.dataType       = 'power'; opts.bands          = {'delta','theta','alpha','beta','lgam','hgam'};
opts.timeType       = 'Bin';
opts.channelGroupingType      = 'channel';
opts.timeFeatures   = 'trial';
opts.extStr         = 'liblinearS0';
opts.analysis       = 'trial';

% load decoding structure
dataPath = ['../Results/Classification/group/' opts.dataType ...
    '/' opts.channelGroupingType '/'];

fileName = ['SumallSubjsClass' opts.lockType 'Lock' opts.dataType cell2mat(opts.bands) '_tF' opts.timeFeatures '_tT' ...
    opts.timeType '_gT' opts.channelGroupingType '_Solver' opts.extStr];

opts.fileName = fileName;
load([dataPath fileName])

% load data structure
dataPath = '../Results/';
if strcmp(opts.dataType,'erp')
    dataPath = [dataPath 'ERP_Data/group/'];
    fileName = [opts.hems 'ERPsGroup' opts.lockType 'LocksubAmp' ...
        opts.reference num2str(opts.nRefChans)];
elseif strcmp(opts.dataType,'power')
    dataPath = [dataPath 'Spectral_Data/group/'];
    fileName = ['allERSPs' cell2mat(opts.bands) 'Group' opts.lockType  ...
        'LocksublogPower' opts.reference num2str(opts.nRefChans)];
end
load([dataPath fileName])

out = matchChannelPatterns(data,S,opts);

savePath = '../Results/lagAnalysis/';
if ~exist(savePath,'dir'), mkdir(savePath), end;
fileName = ['lag' opts.analysis 'Analysis' opts.lockType 'Lock' opts.dataType cell2mat(opts.bands)];
save([savePath fileName])

%% get spectrogram
addpath PreProcessing/
addpath Analysis/

%dateStr = '27-May-2013';
%subjects = {'16b'};
subjects = {'30'};
%dateStr = '17-Jun-2013';
%subjects = {'17b','19','29'};
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
dataPath = '../Results/';
for s = subjects
   % dataIn = load([dataPath 'ERP_Data/subj' s{1} '/BandPassedSignals/BandPass' reference num2str(nRefChans) dateStr]);
    dataIn = load([dataPath 'ERP_Data/subj' s{1} '/BandPassedSignals/BandPass' reference num2str(nRefChans)]);
    data=spectrogramWrapper(dataIn.data);
    
    save([dataPath 'Spectral_Data/subj' s{1} '/SpectrogramData_subj' s{1} '.mat'],'data')
    fprintf('Analysis Completed for subjectd %s \n',s{1});
end
%% epoch the spectrograms
addpath PreProcessing/
addpath Analysis/
addpath Lib/

%subjects = {'16b','18','24','28'};
subjects = {'30'};
%subjects = {'17b','19','29'};
lockType = 'stim';
dataPath = '../Results/Spectral_Data/';

for s = subjects
    fprintf('epoching spectrograms for subjects %s \n',s{1})
    
    dataIn=load([dataPath '/subj' s{1} '/SpectrogramData_subj' s{1} '.mat'],'data');
    dataIn=dataIn.data;
    dataIn.lockType = lockType;
    
    savePath  = strcat(dataPath, 'subj', s{1}, '/epoched/');
    if ~exist(savePath,'dir')
        mkdir(savePath);
    end
    if strcmp(lockType,'RT')
        stimData = load([savePath,'stim_Spectrogram_subj' s{1},'.mat']);
        dataIn.baseLineMeans = stimData.data.baseLineMeans;
    end
    data = getAvgSpectrogram(dataIn);
    save([savePath, lockType, '_Spectrogram_subj' s{1}],'data');
    
    fprintf('epoching spectrograms completed for subjects %s \n',s{1})
end

%% group lpc data across subjects

opts                = [];
opts.subjects   = {'16b','18','24','28'};
opts.hemId      = {'l','l','l', 'l'};
opts.lockType  = 'RT';

data = groupLPCSpectrogramData(opts);
dataPath1 = '../Results/Spectral_Data/group/';
dataPath2 =[ '~/Google Drive/Research/ECoG Manuscript/data/'];
fileName = [lockType 'GroupSpectrumData'];

save([dataPath1 fileName],'data')
save([dataPath2 fileName],'data')

