
function conditionBarPlotsWrapper (data, opts)


Bins    = (data.Bins(:,1) >= opts.timeLims(1)) & (data.Bins(:,2) <= opts.timeLims(2));


colors      = [];
colors{1}    = [0.9 0.5 0.1]; % color for condition 1
colors{2}    = [0.1 0.8 0.9]; % color for condition 2

ROInums = opts.ROInums; % 1-> IPS, 2-> SPL
hem     = opts.hem; % 1->left
nROIs   = numel(ROInums);

conds = {'BinmHits','BinmCRs'};
nConds = numel(conds);

chans   = cell(nROIs,1);
for r = 1:nROIs    
    chans{r} = (data.hemChanId==hem).*data.ROIid==(ROInums(r));    
end

M = cell(nConds*nROIs,1);
counter = 1;
for r = 1:nROIs
    for c = 1:nConds
        M{counter} = mean(data.(conds{c})(chans{r},Bins),2);
        opts.colors(counter,:) = colors{c};
        counter = counter +1;
    end
end

ha = barPlotWithErrors(M,opts);

plotPath = [opts.plotPath '/group/' opts.band '/barPlots/' ];
if ~exist(plotPath,'dir') mkdir(plotPath); end;
fileName = ['ConditionBarPlot'  cell2mat(data.ROIs([opts.ROInums])) 'TimeWindow' opts.timeStr];
print(ha,'-depsc2',[plotPath, fileName])