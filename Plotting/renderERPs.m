function renderERPs(data,opts)

% dependencies:
%   cMapGenerate
%   rendering scripts

hem         = opts.hems;
hemChans    = ismember(data.subjChans,find(strcmp(opts.hemId,opts.hems)))';
chanCoords  = data.MNILocs(hemChans,:);
nChans      = size(chanCoords,1);

bins        = round(mean(data.(opts.timeType),2)*1000);
if ~isempty(opts.avgBins)
    stat        = mean(data.(opts.comparisonType)(hemChans,opts.avgBins),2);
    bins        = round(mean([bins(opts.avgBins(1)) bins(opts.avgBins(end))]))+1;
else
    stat        = data.(opts.comparisonType)(hemChans,:);
end

roiIds      = data.ROIid;
renderType  = opts.renderType;

extension   = [opts.extension];
nBins       = numel(bins);

cortex      = data.([hem 'MNIcortex']);
view.l      = [310,30];
view.r      = [50,30];

% colorbar limits
limitUp     = opts.limitUp;
absLimit    = opts.absLevel;
limitDw     = opts.limitDw;

for bi = 1:nBins
    binStat = stat(:,bi);
    h  = figure(1);clf;
    set(gca,'Position',[200 200 800 800]);
    ha = tight_subplot(1,1,0.01,0.005,0.005);
    
    switch renderType
        case 'SigChans'
            ctmr_gauss_plot(gca,cortex,[0 0 0],[0],hem);
            el_add(chanCoords,[0 0 0],24);
            sigChans = find(abs(binStat)>=absLimit);
            posChans = binStat>=absLimit;
            negChans = binStat<=-absLimit;
            
            el_add(chanCoords(posChans,:),[0.9 0.5 0.1],20);
            el_add(chanCoords(negChans,:),[0.1 0.8 0.9],20);
            
        case 'SignChans'
            ctmr_gauss_plot(gca,cortex,[0 0 0],[0],hem);
            posChans = binStat>=1;
            negChans = binStat<=-1;
            
            el_add(chanCoords,[0 0 0],12);
            el_add(chanCoords(posChans|negChans,:),[0 0 0],25);
            el_add(chanCoords(posChans,:),[0.9 0.2 0.2],20);
            el_add(chanCoords(negChans,:),[0.2 0.2 0.9],20);
        
        otherwise
           plotSurfaceChanWeights(handle, cortex, chanCoords, binStat,opts)
    end
    loc_view(view.(hem)(1),view.(hem)(2))
    set(gca,'clim',[-limitUp limitUp])
    title([opts.preFix ' ' opts.comparisonType ' (Hit-CRs) @ ' num2str(bins(bi)) ' ms'],'fontsize',14)
    %colorbar
    savestr = [hem opts.preFix '_' opts.comparisonType renderType 'minLim' num2str(limitDw) '_' num2str(bins(bi)) extension '.tif'];
    print(h,'-dtiff',['-r' num2str(opts.resolution)],[opts.renderPath savestr])
end


