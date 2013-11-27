function plotROI_TC_multiband(opts)

bands   = opts.bands;
nBands  = numel(bands);
ROInum  = opts.ROInums; % 1-> IPS, 2-> SPL
hem     = opts.hem;     % 1->left
conds   = {'mHits','mCRs'};
lockTypes = {'stim','RT'};
nConds  = numel(conds);

smoother        = opts.smoother;
smootherSpan    = opts.smootherSpan;
yLimits         = opts.yLimits;


% pre-allocate some info
ba = 1;
extension  = ['stimLock' opts.baselineType opts.analysisType ...
    opts.reference num2str(opts.nRefChans)] ;
fileName   = ['allERSPs' bands{ba} 'Group' extension '.mat'];
load([opts.dataPath, fileName]);

chans   = (data.hemChanId==hem)&(data.ROIid==ROInum);

figure(); clf; 
ha = tight_subplot(3,2, [0.02 0.01], 0.01, 0.01);

hacnt = 1;
for ba = 1:nBands
    for lt = 1:2
        extension  = [lockTypes{lt} 'Lock' opts.baselineType opts.analysisType ...
        opts.reference num2str(opts.nRefChans)] ;
        fileName   = ['allERSPs' bands{ba} 'Group' extension '.mat'];
        load([opts.dataPath, fileName]);
        
        t    = data.trialTime;
        X = cell(nConds,1);
        for co = 1:nConds
            X{co} = data.(conds{co})(chans,:);            
        end
        axes(ha(hacnt));set(gca,'yTickLabelMode','auto');
        plotNTraces(X,t,'oc',smoother,smootherSpan,'mean',yLimits);
        if lt==2 ,set(gca,'YAXisLocation','right'),end
        set(gca,'xticklabel','','yticklabel','')
        hacnt=hacnt+1;
    end
end

plotPath = [opts.plotPath '/group/multiBand/' ];
if ~exist(plotPath,'dir') mkdir(plotPath); end;
fileName = [data.ROIs{ROInum} opts.lockType 'AvgPower' cell2mat(bands)];
plot2svg([plotPath fileName '.svg'],gcf,'tiff')