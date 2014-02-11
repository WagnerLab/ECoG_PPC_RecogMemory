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

if strcmp(renderType,'SmoothCh')
    Colors = [;
        0.1 0 1;
        0 1 1;
        0 1 0.7;
        0.7 0.7 0.7;
        0.7 0.7 0.7;
        0.7 1 0;
        1 1 0;
        1 0 0.1;];
    nLevels     = size(Colors,1)/2;
    levels      = [linspace(-limitUp,-limitDw,nLevels),linspace(limitDw,limitUp,nLevels)];
    clbar_map   = cMapGenerate(Colors,levels);
    nclbar_bins = size(clbar_map,1);
    cbar_bins = linspace(limitDw,limitUp,nclbar_bins);
    
elseif strcmp(renderType,'UnSmoothCh')
     Colors = [;
        0.1 0 1;
        0 1 1;
        0 1 0.7;
        1 1 1 ;
        1 1 1;
        0.7 1 0;
        1 1 0;
        1 0 0.1;];
    nLevels     = size(Colors,1)/2;
    levels      = [linspace(-limitUp,-limitDw,nLevels),linspace(limitDw,limitUp,nLevels)];
    clbar_map   = cMapGenerate(Colors,levels);
    nclbar_bins = size(clbar_map,1);
    cbar_bins = linspace(limitDw,limitUp,nclbar_bins);
    
elseif strcmp(renderType,'UnSmoothCh2') 
    Colors = [;
        0.1 0 1;
        0 1 1;
        %0 1 0.7;
        %0.7 1 0;
        1 1 0;
        1 0 0.1;];
    nLevels     = size(Colors,1)/2;
    levels      = [linspace(-limitUp,-limitDw,nLevels),linspace(limitDw,limitUp,nLevels)];
    clbar_map   = cMapGenerate(Colors,levels);
    nclbar_bins = size(clbar_map,1);
    cbar_bins1 = linspace(absLimit,limitUp,nclbar_bins/2);
    cbar_bins2 = linspace(limitDw,-absLimit,nclbar_bins/2);
end

for bi = 1:nBins
    binStat = stat(:,bi);
    h  = figure(1);clf;
    set(gca,'Position',[200 200 800 800]);
    ha = tight_subplot(1,1,0.01,0.005,0.005);
    
    switch renderType
        case 'SmoothCh'
            ctmr_gauss_plot(gca,cortex,chanCoords,binStat,hem,clbar_map);
            el_add(chanCoords,'k',10);
            
        case 'UnSmoothCh'
            ctmr_gauss_plot(gca,cortex,[0 0 0],[0],hem);
            el_add(chanCoords,'k',24);
            for i = 1:nChans
                tval = binStat(i);
                if tval >= limitUp
                    color_id = clbar_map(end,:);
                elseif tval <= limitDw
                    color_id = clbar_map(1,:);
                else
                    color_id = histc(tval,cbar_bins);
                end
                
                el_color = clbar_map(color_id ==1,:);
                el_add(chanCoords(i,:),el_color,20);
            end
        case 'UnSmoothCh2'
            ctmr_gauss_plot(gca,cortex,[0 0 0],[0],hem);
            el_add(chanCoords,'k',24);
            for i = 1:nChans
                tval = binStat(i);
                if tval >= limitUp
                    color_id = nclbar_bins;
                    el_color = clbar_map(color_id,:);
                elseif tval <= limitDw
                    color_id = 1;
                    el_color = clbar_map(color_id,:);
                elseif tval >= absLimit
                    color_id = find(histc(tval,cbar_bins1))+ nclbar_bins/2;
                    el_color = clbar_map(color_id,:);
                elseif tval <= -absLimit
                    color_id = find(histc(tval,cbar_bins2));
                    el_color = clbar_map(color_id,:);
                else
                    el_color = [0 0 0];
                end
                el_add(chanCoords(i,:),el_color,20);
            end
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
    end
    loc_view(view.(hem)(1),view.(hem)(2))
    set(gca,'clim',[-limitUp limitUp])
    title([opts.preFix ' ' opts.comparisonType ' (Hit-CRs) @ ' num2str(bins(bi)) ' ms'],'fontsize',14)
    %colorbar
    savestr = [hem opts.preFix '_' opts.comparisonType renderType 'minLim' num2str(limitDw) '_' num2str(bins(bi)) extension '.tif'];
    print(h,'-dtiff',['-r' num2str(opts.resolution)],[opts.renderPath savestr])
end


