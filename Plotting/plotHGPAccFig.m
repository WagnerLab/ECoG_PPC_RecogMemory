function plotHGPAccFig(data1,data2,opts)

inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';

temp = load('../Results/ERP_Data/group/allERPsGroupstimLocksubAmpnonLPCleasL1TvalCh10.mat');
chanLocs    =  temp.data.MNILocs;
cortex{1}   =  temp.data.lMNIcortex;

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

hem_str     = {'l','r'};
view{1}     = [310,30];

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
f=figure(1); clf;
ha = tight_subplot(2,2,[0.01 0.01], 0.05, 0.05);
set(gcf,'PaperPositionMode','auto','position',[100 100 800 800])
set(ha(3),'visible','off');

axes(ha(2)); hold on;
scatterPlotWithErrors(M1,M2, cols, [lims; lims], [0.5 0.5 1]);
set(gca,'yTick',ticks,'xTick',ticks)
set(gca,'yTicklabel','','xTicklabel','')


axes(ha(4)); pos_ha=get(ha(4),'position'); hold on;
set(ha(4),'position',[pos_ha(1) 0.4 pos_ha(3) 0.1])
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
set(gca,'LineWidth',2,'FontSize',20, 'fontWeight','bold')
set(gca,'xtick',ticks,'xtickLabel',ticks,'ytick',[])

axes(ha(1)); pos_ha=get(ha(1),'position'); hold on;
set(ha(1),'position',[0.4 pos_ha(2) 0.1 pos_ha(4)]);
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
set(gca,'LineWidth',2,'FontSize',20,'fontWeight','bold')
set(gca,'ytick',ticks,'ytickLabel',ticks,'xtick',[])

cPath = pwd;
cd(opts.savePath)
addpath(cPath)
addpath([cPath '/Plotting/'])

filename = 'Fig3aHGP_ACC';
plot2svg([filename '.svg'],f)
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])

cd(cPath)

%%

hem=1;
chans   = data1.hemChanId == hem ;
limits = opts.rendLimits-opts.baseLineY;
opts.limitDw = limits(1);
opts.limitUp = limits(2);
opts.absLevel = 0.03;
opts.renderType = 'SmoothCh';
opts.hem        = hem_str{hem};

f=figure(2);clf;
set(f,'Position',[200 200 600 1200]);

ha = tight_subplot(2,1,0.001,0.001,0.001);
plotSurfaceChanWeights(ha(1), cortex{hem}, chanLocs(chans,:), data1.mBAC(chans)-0.5,opts)
loc_view(view{hem}(1),view{hem}(2))
set(gca,'clim',limits);
h =  title('stim-locked accuracies');
set(h,'units','normalized','position',[0.5 0.85 0],'fontSize',18)

plotSurfaceChanWeights(ha(2), cortex{hem}, chanLocs(chans,:), data2.mBAC(chans)-0.5,opts)
loc_view(view{hem}(1),view{hem}(2))
set(gca,'clim',limits)
h =  title('RT-locked accuracies');
set(h,'units','normalized','position',[0.5 0.85 0],'fontSize',18)

filename = [opts.savePath 'Fig3bHGP_acc_Renderings'];
print(f,'-dtiff',['-r' num2str(opts.resolution)],filename)

%%
cm = colormap;
cm = cm(1001:2000,:);
f(3)=figure(3); clf;
set(f(3),'position',[-400,100,110,200])
set(f(3),'colormap',cm)
h=colorbar;
set(gca,'visible','off')
set(h,'position',[0.25 0.1 0.5 0.8])
set(h,'yTick',[1 1000],'ytickLabel',[50 75],'box','off','fontSize',20)
set(h,'fontweight','bold')
set(gcf,'paperSize',[2 3])
set(gcf,'paperPositionMode','auto')
filename = [opts.savePath 'Fig3bc_cbar'];
print(f(3),'-dpdf',filename)


