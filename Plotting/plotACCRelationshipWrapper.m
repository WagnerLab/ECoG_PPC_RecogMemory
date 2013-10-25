function plotACCRelationshipWrapper(data1,data2,opts)

% dependencies 
%   scatterPlotWithErrors.m
plotName1   = [opts.lockType1 opts.dataType1 cell2mat(opts.bands1) opts.extStr];
plotName2   = [opts.lockType2 opts.dataType2 cell2mat(opts.bands2) opts.extStr];
plotName3   = [plotName1 plotName2];

colors      = [];
colors{1}  = [0.9 0.2 0.2];
colors{2}  = [0.1 0.5 0.8];
colors{3}   = [0.2 0.6 0.3];
colors{4}    = 0.1*[1 1 1];

ticks = [0.5:0.1:0.9];
nBoot1 = data1.classificationParams.nBoots;
nBoot2 = data2.classificationParams.nBoots;

% channel selection
Subjchans   = ismember(data1.subjChans,opts.subjects);
chans       = double(ismember(data1.ROIid.*Subjchans,opts.ROIs));

lims = opts.lims;
N = sum(chans);
nROIs = numel(opts.ROIs);
nChanPerROI =[];
if opts.ROIids
    cols = zeros(N,3);
    cnt = 1;
    for rr = opts.ROIs
        
        roiChans = chans & (data1.ROIid==rr); n = sum(roiChans);
        nChanPerROI = [nChanPerROI sum(roiChans)];
        chans(cnt:(n+cnt-1)) = find(roiChans);
        cols(cnt:(n+cnt-1),:)= repmat(colors{rr},n,1);
        
        cnt = cnt + n;
    end
    chans = chans(1:N);
else
    cols = repmat(colors{4},[N,1]);
end

M1 =[];
M1(:,1) = data1.mBAC(chans);
M1(:,2) = data1.sdBAC(chans)/sqrt(nBoot1-1);

M2 =[];
M2(:,1) = data2.mBAC(chans);
M2(:,2) = data2.sdBAC(chans)/sqrt(nBoot2-1);

% plot M1 vs M2
figure(1); clf; hold on;
set(gcf,'PaperPositionMode','auto','position',[100 100 600 600])
scatterPlotWithErrors(M1,M2, cols, [lims; lims], [0.5 0.5 1]);
%axis square
set(gca,'yTick',ticks,'xTick',ticks)
set(gca,'yTicklabel','','xTicklabel','')
print(gcf,'-depsc2',[opts.savePath '/' plotName3])

if opts.ROIids
    % plot M1 horizontally
    figure(2); clf; hold on;
    set(gcf,'PaperPositionMode','auto','position',[100 100 600 100])
    xlim(lims);ylim([0 nROIs]+0.5)
    
    cnt = 1;
    for r = 1:nROIs
        roiChans = cnt:nChanPerROI(r)+cnt-1;
        
        ym = mean([M1(roiChans,1)]);
        ys = std([M1(roiChans,1)])/sqrt(nChanPerROI(r)-1);
        
        barh(r,ym,'FaceColor',colors{r},'edgeColor','none','basevalue', 0.5,'ShowBaseLine','off')
        plot([-ys ys]+ym,[r r],'color',[0 0 0],'linewidth',4)
        
        cnt = cnt + nChanPerROI(r);
    end
    plot([0.5 0.5],ylim,'--k','linewidth',2)
    set(gca,'LineWidth',2,'FontSize',16)
    set(gca,'xtick',ticks,'ytick',[])
    %axis square
    print(gcf,'-depsc2',[opts.savePath '/' plotName1])
    
    % plot M2 vertically
    figure(3); clf; hold on;
    set(gcf,'PaperPositionMode','auto','position',[100 100 100 600])
    xlim([0 nROIs]+0.5); ylim(lims)
    
    cnt = 1;    
    for r = 1:nROIs
        roiChans = cnt:nChanPerROI(r)+cnt-1;
        
        ym = mean([M2(roiChans,1)]);
        ys = std([M2(roiChans,1)])/sqrt(nChanPerROI(r)-1);
        
        bar(r,ym,'FaceColor',colors{r},'edgeColor','none','basevalue', 0.5,'ShowBaseLine','off')
        plot([r r],[-ys ys]+ym,'color',[0 0 0],'linewidth',4)
        
        cnt = cnt + nChanPerROI(r);
    end
    plot(xlim,[0.5 0.5],'--k','linewidth',2)
    set(gca,'LineWidth',2,'FontSize',16)
    set(gca,'ytick',ticks,'xtick',[])
    %axis square
    print(gcf,'-depsc2',[opts.savePath '/' plotName2])
    
end



