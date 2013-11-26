%% ecog processing wrapper

%% preprocess data
addpath PreProcessing/
addpath lib/
for s ={'16b','18','24','28'}
    preProcessRawData(s{1},'SS2')
end

%% re-reference
addpath PreProcessing/
addpath lib/
%dateStr = '27-May-2013';
%subjects = {'16b','18','24','28'};
dateStr = '17-Jun-2013';
subjects = {'17b','19','29'};
%reference = 'origCAR'; nRefChans = 0;
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
dataPath = '../Results/';
for s = subjects
    dataIn = load([dataPath 'ERP_Data/subj' s{1} '/BandPassedSignals/BandPass' dateStr '.mat']);
    if strcmp(reference,'nonLPCleasL1TvalCh')
        dataIn.data.refInfoFile = [dataPath 'ERP_Data/subj' s{1} '/ERPsstimLocksubAmporigCAR0' dateStr '.mat'];
        data2=load(dataIn.data.refInfoFile);
        dataIn.data.RefChanTotalTstat =data2.data.chanTotalTstat; clear data2;
    end
    data = reReferenceData(dataIn.data,reference,nRefChans);
    save([dataPath 'ERP_Data/subj' s{1} '/BandPassedSignals/BandPass' reference num2str(data.nRefChans) dateStr],'data')
end

%% calc ERPs
addpath PreProcessing/
addpath Analysis/
addpath lib/

dateStr = '27-May-2013';
subjects = {'16b','18','24','28'};
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
    dataIn = load([dataPath 'ERP_Data/subj' s{1} '/BandPassedSignals/BandPass' reference num2str(nRefChans) dateStr]);
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

dateStr = '27-May-2013';
subjects = {'16b'};
%subjects = {'16b','18','24','28'};
%dateStr = '17-Jun-2013';
%subjects = {'17b','19','29'};
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
dataPath = '../Results/';
for s = subjects
    dataIn = load([dataPath 'ERP_Data/subj' s{1} '/BandPassedSignals/BandPass' reference num2str(nRefChans) dateStr]);
    for band = {'delta'}%{'delta','theta','alpha','beta','lgam','hgam','bb'};
        data = dataDecompose(dataIn.data,band{1});
        save([dataPath 'Spectral_Data/subj' s{1} '/BandPassedSignals/BandPass' band{1} reference num2str(nRefChans) dateStr '.mat'],'data')
    end
end

%% calc ERSPs

addpath Analysis/

dateStr = '27-May-2013';
subjects = {'16b','18','24','28'};
%dateStr = '17-Jun-2013';
%subjects = {'17b','19','29'};
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
lockType = 'RT';
dataPath = '../Results/';
analysisType = 'logPower';%{'Amp','Power', 'logPower'};
baselineType = 'sub';%{'rel','sub'}
for s = subjects
    for band = {'delta','theta','alpha','beta','lgam','hgam','bb'};
        dataIn = load([dataPath 'Spectral_Data/subj' s{1} '/BandPassedSignals/BandPass' band{1}  reference num2str(nRefChans) dateStr '.mat']);
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
subjects = {'16b','18','24','28'};
%subjects = {'17b','19','29'};
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;

dataPath = '../Results/';

opts = [];
opts.plotPath = [dataPath 'Plots/Spectral/'];
opts.lockType = 'RT';
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

bands = {'erp','hgam','delta','theta','alpha','beta','lgam'};

opts = [];
opts.hems = 'all';
opts.lockType = 'RT';
opts.reference = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
opts.subjects       = {'16b','18','24','28','17b','19', '29'};
opts.hemId          = {'l'  ,'l' ,'l' ,'l' ,'r'  ,'r' , 'r'};

dataPath = '../Results/';
if strcmp(opts.type,'erp')
    dataPath = [dataPath 'ERP_Data/group/'];
else
    dataPath = [dataPath 'Spectral_Data/group/'];
end
for ba = 1:numel(bands)
    opts.type   = bands{ba};    
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

dateStr = '27-May-2013';
subjects = {'16b','18','24','28'};
dateStr = '17-Jun-2013';
subjects = {'17b','19','29'};
reference = 'nonLPCleasL1TvalCh'; nRefChans = 10;
lockType = 'stim';
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
    opts.lockType   = 'stim';
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
for bands = {'delta','theta','alpha','beta'}
    
    opts = [];
    opts.hems = 'l';
    opts.lockType = 'stim';
    opts.reference = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
    opts.type = 'ITC';
    opts.band = bands{1};
    
    subjects = {'16b','18','24','28','17b','19', '29'};
    hemId = [1 1 1 1 2 2 2];
    if strcmp(opts.hems,'l'), snums = [1:4];
    elseif strcmp(opts.hems,'r'), snums = [5:7];
    else snums = 1:7;
    end
    opts.hemId = hemId(snums);
    opts.subjects = subjects(snums);
    
    %dataPath = '../Results/ITC_Data/group/';
    
    %data = groupLPC_ITCData(opts);
    
    fileName = [opts.hems data.prefix 'Group' data.extension];
    save([dataPath fileName '.mat'],'data')
    
    fprintf('grouping data completed for %s\n',opts.band)
end

%% plot roi level data

opts                = [];
opts.hems           = 'l';
opts.lockType       = 'stim';
opts.reference      = 'nonLPCleasL1TvalCh';
opts.nRefChans      = 10;
opts.type           = 'power';
opts.band           = 'theta';
opts.smoother       = 'loess';
opts.smootherSpan   = 0.15;
opts.yLimits        = [-6 1.5];
opts.aRatio         = [500 300];

opts.subjects       = {'16b','18','24','28','17b','19', '29'};
opts.hemId          = {'l'  ,'l' ,'l' ,'l' ,'r'  ,'r' , 'r'};

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

%plotROI_ERPs(data,opts)

switch opts.lockType
    case 'RT'
        opts.timeLims   = [-0.6 0.1];
        opts.timeStr     = 'n600msTo100ms';
    case 'stim'
        opts.timeLims   = [0 0.9];
        opts.timeStr     = '0msTo900ms';
end

opts.aspectRatio = [50 300];
opts.hem        = 1;
opts.yLimits    = [-6 1];

opts.ROInums    = [1];
conditionBarPlotsWrapper (data, opts)
opts.ROInums    = [2];
conditionBarPlotsWrapper (data, opts)
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
opts.bands           = {'delta','theta','alpha','beta','lgam','hgam'};
opts.smoother       = 'loess';
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
opts.hems           = 'l';
opts.lockType       = 'RT';
opts.type           = 'power';
opts.band           = 'theta';
opts.comparisonType = 'BinZStat'; %{'BinTStat','BinpValT','BinpVal','BinZStat','BinpValz','BincondDiff'};
opts.timeType       = 'Bins';
opts.reference      = 'nonLPCleasL1TvalCh';
opts.nRefChans      = 10;
opts.renderType     = 'SmoothCh';%{'SmoothCh','UnSmoothCh', 'SigChans','SignChans'};
opts.limitDw        = 1;
opts.limitUp        = 5;
opts.resolution     = 400;
opts.avgBins        = [3:11];

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
opts.lockType       = 'stim';
opts.type           = 'power';
opts.band           = 'hgam';
opts.dtype          = 'ZStat';
opts.smoothData     = true;
opts.reference      = 'nonLPCleasL1TvalCh';
opts.nRefChans      = 10;
opts.resolution     = 400;
opts.aRatio         = [500 300];
opts.plotting       = false;

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

%% output group data to a csv file

addpath Analysis/

opts                = [];
opts.hems           = 'all';
opts.lockType       = 'RT';
opts.reference      = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
opts.type           = 'power'; opts.band = 'hgam';
%opts.type           = 'power'; opts.band = 'hgam';
opts.bin            = 'Bin'; % options are{'BigBin', 'Bin'};
opts.byBlockFlag    = 0;

switch opts.lockType
    case 'RT'
        opts.time   = [-0.6 0.1];
        timeStr     = 'n600msTo100ms';
    case 'stim'
        opts.time   = [0 0.9];
        timeStr     = '0msTo900ms';
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

addpath Classification/

opts                = [];
opts.lockType       = 'stim';
opts.reference      = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
%opts.dataType       = 'erp'; opts.bands          = {''};
opts.dataType       = 'power'; opts.bands          = {'beta'};
%opts.dataType       = 'power'; opts.bands          = {'delta','theta','alpha','beta','lgam','hgam'};
opts.toolboxNum     = 1;

% feauture settings
% timeType distinguishes between decoding individual samples, or taking
% time  bins
% options are {'','Bin'};
opts.timeType       = 'Bin';
% channelGroupingType makes the distinction between decoding between channels, rois or
% all channels within LPC
% options are {'channel','ROI','all'};
opts.channelGroupingType      = 'channel';
% timeFeatures distinguishes between taking the whole trial or taking a
% window of time
% options are {'window','trial'};
opts.timeFeatures   = 'trial';

S = ClassificationWrapper(opts);

savePath = ['../Results/Classification/group/' opts.dataType ...
    '/' opts.channelGroupingType '/'];
if ~exist(savePath,'dir'),mkdir(savePath), end

fileName = ['allSubjsClass' opts.lockType 'Lock' opts.dataType cell2mat(opts.bands) '_tF' opts.timeFeatures '_tT' ...
    opts.timeType '_gT' opts.channelGroupingType '_Solver' S.extStr];
save([savePath fileName],'S')

%% summarize performance

addpath Classification/

opts                = [];
opts.lockType       = 'stim';
opts.reference      = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
%opts.dataType       = 'power'; opts.bands          = {'delta','theta','alpha'};
opts.dataType       = 'power'; opts.bands          = {'hgam'};
%opts.dataType       = 'power'; opts.bands          = {'erp','hgam'};
%opts.dataType       = 'power'; opts.bands          = {'delta','theta','alpha','beta','lgam','hgam'};
opts.toolboxNum     = 1;
opts.timeType       = 'Bin';
opts.channelGroupingType      = 'channel';
opts.timeFeatures   = 'trial';
opts.extStr         = 'liblinearS0';%'NNDTWK5';%

dataPath = ['../Results/Classification/group/' opts.dataType ...
    '/' opts.channelGroupingType '/'];

fileName = ['allSubjsClass' opts.lockType 'Lock' opts.dataType cell2mat(opts.bands) '_tF' opts.timeFeatures '_tT' ...
    opts.timeType '_gT' opts.channelGroupingType '_Solver' opts.extStr];

load([dataPath fileName])
S = SummaryClassification(S,opts);
fileName = ['Sum' fileName];
save([dataPath fileName],'S')

%% plot decoding results

addpath lib/

opts                = [];
opts.lockType       = 'RT';
opts.scoreType      = 'mBAC'; % RTsLogitCorr mBAC
opts.accPlots       = false;
opts.weigthsPlots   = false;
opts.renderPlot     = true;
opts.RTcorrPlots    = false;
opts.stats          = true;
opts.baseLineY      = 0;
opts.rendLimits     = [-0.25 0.25];
opts.resolution     = 400;
opts.reference      = 'nonLPCleasL1TvalCh'; opts.nRefChans = 10;
opts.toolboxNum     = 1;
%opts.dataType       = 'erp'; opts.bands          = {''};
%opts.dataType       = 'power'; opts.bands          = {'delta','theta','alpha'};
opts.dataType       = 'power'; opts.bands          = {'theta'};
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

opts                = [];
opts.lockType1       = 'stim';
opts.dataType1       = 'power'; opts.bands1        = {'theta'};
%opts.dataType1       = 'power'; opts.bands1          = {'delta','theta','alpha','beta','lgam','hgam'};
opts.lockType2       = 'RT';
opts.dataType2       = 'power'; opts.bands2        = {'theta'};
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
