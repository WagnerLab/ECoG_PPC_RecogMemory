
function conditionBarMultiBandWrapper (opts)
% plots the average power for each condition per band, for multiple bands.

colors      = [];
colors{1}   = [0.9 0.5 0.1]; % color for condition 1
colors{2}   = [0.1 0.8 0.9]; % color for condition 2

bands   = opts.bands;
nBands  = numel(bands);
ROInum  = opts.ROInums; % 1-> IPS, 2-> SPL
hem     = opts.hem;     % 1->left
conds   = {'BinmHits','BinmCRs'};
nConds  = numel(conds);

% set positions of each bar set
opts.xPositions = 1:(nBands*nConds + nBands-1);
opts.xPositions((nConds+1):(nConds+1):end) = [];
opts.xLimits = [opts.xPositions(1)-1, opts.xPositions(end)+1];

% load first bands to pre-allocate variables
ba = 1;

extension  = [opts.lockType 'Lock' opts.baselineType opts.analysisType ...
    opts.reference num2str(opts.nRefChans)] ;
fileName   = ['allERSPs' bands{ba} 'Group' extension '.mat'];
load([opts.dataPath, fileName]);

Bins    = (data.Bins(:,1) >= opts.timeLims(1)) & (data.Bins(:,2) <= opts.timeLims(2));
chans   = (data.hemChanId==hem)&(data.ROIid==ROInum);

M       = cell(nConds*nBands,1);
counter = 1;
for c = 1:nConds
    M{counter} = mean(data.(conds{c})(chans,Bins),2);
    opts.colors(counter,:) = colors{c};
    counter = counter +1;
end

for ba = 2:nBands
    extension  = [opts.lockType 'Lock' opts.baselineType opts.analysisType ...
        opts.reference num2str(opts.nRefChans)] ;
    fileName   = ['allERSPs' bands{ba} 'Group' extension '.mat'];
    load([opts.dataPath, fileName]);
    for c = 1:nConds
        M{counter} = mean(data.(conds{c})(chans,Bins),2);
        opts.colors(counter,:) = colors{c};
        counter = counter +1;
    end
end

ha = barPlotWithErrors(M,opts);

plotPath = [opts.plotPath '/group/barPlots/' ];
if ~exist(plotPath,'dir') mkdir(plotPath); end;
fileName = [data.ROIs{ROInum} opts.lockType 'AvgPower' cell2mat(bands) 'TimeWindow' opts.timeStr];
print(ha,'-depsc2',[plotPath, fileName])