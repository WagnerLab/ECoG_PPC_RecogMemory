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
opts.yLimits        = [-0.6 2];
opts.timeLims       = [0 1; -1 0.2]; % statistcs evaluation; first row for stim
opts.aRatio         = [500 300];
opts.renderType     = 'SmoothCh';%{'SmoothCh','UnSmoothCh', 'SigChans','SignChans'};
opts.limitDw        = -4;
opts.limitUp        = 4;
opts.absLevel       = 1;
opts.Pthr           = 0.005;
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
%%
% get descriptive numbers
% number of ROI to cluster overlap
% cluster 1
chans=find(clusterSet1.chans);
nOver =sum([chans(clusterSet1.index)==clusterSet1.ROI_ids]);
nTot = numel(chans);
fprintf('CL1 #overlap / total = %i / %i \n', nOver,nTot)

% cluster 2
chans=find(clusterSet2.chans);
nOver =sum([chans(clusterSet2.index)==clusterSet2.ROI_ids]);
nTot = numel(chans);
fprintf('CL2 #overlap / total = %i / %i \n', nOver,nTot)

% Get Unified Clusters
% get cluster channels
dType = {'stim','RT'};
CLChans = cell(2,1);
for ii = 1:2
    CLChans{ii}=union(clusterSet1.subCLChans{ii},clusterSet2.subCLChans{ii});
    fprintf(' # of channels for CL1 and CL2 on %s data \n', dType{ii})
    disp([numel(clusterSet1.subCLChans{ii}) numel(clusterSet2.subCLChans{ii})])
end

% number of channels in the resulting aggregated cluster
for ii = 1:2
    fprintf('number of channels in cluster # %i = %i \n',ii,numel(CLChans{ii}))
end

% number of channels per subjects in the resulting clusters
for ii =1:2
    fprintf('For Cluster %i \n',ii)
    for jj=1:5
        kk= numel(intersect(CLChans{ii},find(data1.subjChans==jj)));
        fprintf('number of channels for subject %i = %i \n',jj,kk)
    end
end

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

opts.subjects       = [1:5]; % left subjects
opts.ROIs           = [1 2]; % roi 1 and 2, IPS and SPL
opts.ROIids         = true;  % plot roi colors
opts.ylims = [0.45 0.9];
opts.xlims = [0.45 0.7];

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

fileName5 = [ opts.dataType1 '/IPS-SPL/' 'allSubjsClassXVB' ...
    opts.lockType1 'Lock' opts.timeStr1 opts.dataType1 cell2mat(opts.bands1) '_tF' opts.timeFeatures ...
    '_tT' opts.timeType '_gTIPS-SPL_Solver' opts.extStr];

fileName6 = [ opts.dataType1 '/IPS-SPL/' 'allSubjsClassXVB' ...
    opts.lockType2 'Lock' opts.timeStr2 opts.dataType1 cell2mat(opts.bands1) '_tF' opts.timeFeatures ...
    '_tT' opts.timeType '_gTIPS-SPL_Solver' opts.extStr];

opts.fileName = fileName1;
opts.fileName = fileName2;
load([dataPath fileName1])
data1 = S; % stimLock by Channel
load([dataPath fileName2])
data2 = S; % RTLock by Channel
load([dataPath fileName3])
data3 = S; % stimLock by ROI
load([dataPath fileName4])
data4 = S; % RTLock by ROI
load([dataPath fileName5])
data5 = S; % stimLock by IPS-SPL
load([dataPath fileName6])
data6 = S; % RTLock by IPS-SPL

opts.savePath = '/Users/alexg8/Google Drive/Research/ECoG Manuscript/ECoG Manuscript Figures/Fig3/';
close all
%plotFigure3_v2(data1,data2,data3,data4,data5,data6,opts)
%% decoding statistics in the paper:
IPSch = data1.ROIid==1 & data1.hemChanId==1;
SPLch = data1.ROIid==2 & data1.hemChanId==1;

disp('Stim-Locked Data Acc across ROI channels Results')
[~,p,~,t]=ttest(data1.mBAC(IPSch),0.5);
fprintf('IPS T-Stat %g, P-Val %g, DF %i \n', t.tstat,p,t.df)
[~,p,~,t]=ttest(data1.mBAC(SPLch),0.5);
fprintf('SPL T-Stat %g, P-Val %g, DF %i \n', t.tstat,p,t.df)

disp('RT-Locked Data Acc across ROI channels Results')
[~,p,~,t]=ttest(data2.mBAC(IPSch),0.5);
fprintf('IPS T-Stat %g, P-Val %g, DF %i \n', t.tstat,p,t.df)
[~,p,~,t]=ttest(data2.mBAC(SPLch),0.5);
fprintf('SPL T-Stat %g, P-Val %g, DF %i \n', t.tstat,p,t.df)

fprintf('\n')
disp('Stim-Locked Data Acc by ROI Results')
X = mean(data3.perf,4);
mX = nanmean(X(1:5,:));
[~,p,~,t]=ttest(X(1:5,:),0.5);

fprintf(' IPS Mean: %.2g, T-Stat %.3g, P-Val %6.2e, DF %i \n',mX(1), t.tstat(1),p(1),t.df(1))
fprintf(' SPL Mean: %.2g T-Stat %.3g, P-Val %6.2e, DF %i \n',mX(2), t.tstat(2),p(2),t.df(2))
fprintf(' AG Mean: %.2g T-Stat %.4g, P-Val %6.2e, DF %i \n',mX(3), t.tstat(3),p(3),t.df(3))

fprintf('\n')
disp('RT-Locked Data Acc by ROI Results')
X = mean(data4.perf,4);
mX = nanmean(X(1:5,:));
[~,p,~,t]=ttest(X(1:5,:),0.5);

fprintf(' IPS Mean: %.2g, T-Stat %.3g, P-Val %6.2e, DF %i \n',mX(1), t.tstat(1),p(1),t.df(1))
fprintf(' SPL Mean: %.2g T-Stat %.3g, P-Val %6.2e, DF %i \n',mX(2), t.tstat(2),p(2),t.df(2))
fprintf(' AG Mean: %.2g T-Stat %.4g, P-Val %6.2e, DF %i \n',mX(3), t.tstat(3),p(3),t.df(3))

fprintf('\n')
disp('Stim-Locked Data Acc by IPS-SPL Results')
X = mean(data5.perf,4);
mX = nanmean(X([1 3 4 5],:));
[~,p,~,t]=ttest(X([1 3 4 5],:),0.5);

fprintf(' Mean: %.2g, T-Stat %.3g, P-Val %6.2e, DF %i \n',mX(1), t.tstat(1),p(1),t.df(1))

fprintf('\n')
disp('RT-Locked Data Acc by IPS-SPL Results')
X = mean(data6.perf,4);
mX = nanmean(X([1 3 4 5],:));
[~,p,~,t]=ttest(X([1 3 4 5],:),0.5);
fprintf(' Mean: %.2g, T-Stat %.3g, P-Val %6.2e, DF %i \n',mX(1), t.tstat(1),p(1),t.df(1))



%% plot ERP figure

cd ~/Documents/ECOG/scripts/

addpath Plotting/
addpath lib/

opts                = [];           opts.hem           = 'l';
opts.nRefChans      = 10;           opts.type           = 'erp';
opts.smoother       = 'loess';      opts.smootherSpan   = 0.15;
opts.lockType       = 'stim';       opts.reference      = 'nonLPCleasL1TvalCh';
opts.Pthr           = 0.005;         opts.timeLims       = [0 1; -1 0.2];

opts.subjects       = {'16b','18','24','28', '30', '17b','19', '29'};
opts.hemId          = {'l'  ,'l' ,'l' ,'l' ,'l','r'  ,'r' , 'r'};

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

%plotERPsByChan(data1,data2, opts)
plotERPsBySubj(data1,data2, opts)
%%  Rendering of seizure channels.
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