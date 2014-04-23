
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

%% stim
ss = [1 3 4]
X = zeros(4,12);
for ii = 1:4
X(ii,:)=mean(data1.BinZStat(IPSch&data1.subjChans'==ii,:));
end
[~,pIPS,~,tIPS]=ttest(X);

X = zeros(3,12);
for ii = 1:3
X(ii,:)=mean(data1.BinZStat(SPLch&data1.subjChans'==ss(ii),:));
end
[~,pSPL,~,tSPL]=ttest(X);

%% RT

X = zeros(4,12);
for ii = 1:4
X(ii,:)=mean(data2.BinZStat(IPSch&data1.subjChans'==ii,:));
end
[~,pIPS,~,tIPS]=ttest(X);

X = zeros(3,12);
for ii = 1:3
X(ii,:)=mean(data2.BinZStat(SPLch&data1.subjChans'==ss(ii),:));
end
[~,pSPL,~,tSPL]=ttest(X);

