function plotROI_ERPs(data,opts)

close all;

savePath        = opts.plotPath;
type            = opts.type;
band            = opts.band;
measType        = opts.measType ;
comparisonType  = opts.comparisonType;
smoother        = opts.smoother;
smootherSpan    = opts.smootherSpan;
yLimits         = opts.yLimits;
hemChans        = ismember(data.subjChans,find(strcmp(opts.hemId,opts.hems)))';
t               = data.trialTime;
extStr          = data.extension;


rois        = {'AG','IPS','SPL'};
%rois        = {'IPS','SPL'};
chIdx.IPS   = data.ROIid==1 & hemChans;
chIdx.SPL   = data.ROIid==2 & hemChans;
chIdx.AG    = data.ROIid==3 & hemChans;

if ~strcmp(type,'erp'), extStr = [band extStr];end

%% plot ROI differences
X = cell(numel(rois),1);
for r = 1:numel(rois)
    roistr = rois{r};
    X{r} = data.(comparisonType)(chIdx.(roistr),:);
end

figure(1); clf; %subplot(4,1,1)
ha=tight_subplot(4,1,0.02,[0.05 0.01],[0.1 0.01]); axes(ha(1));
set(gca,'yTickLabelMode','auto')
set(gcf,'position',[200 200,350,1200],'PaperPositionMode','auto')
plotNTraces(X,t,'rbg',smoother,smootherSpan);

figure(2); clf;
h = plotNTraces(X,t,'rbg',smoother,smootherSpan);
if strcmp(opts.lockType,'RT'),set(gca,'YAXisLocation','right'),end
set(h.f,'position',[200 200,500,300],'PaperPositionMode','auto')

if strcmp(type,'erp'),
    plotPath = [savePath 'group/'];
elseif strcmp(type,'ITC')
    plotPath = [savePath 'group/ITC/' opts.band '/'];
elseif strcmp(type,'power')
    plotPath = [savePath 'group/' opts.band '/'];
end

if ~exist(plotPath,'dir'),mkdir(plotPath),end
filename = [plotPath '/' opts.hems comparisonType 'ROIs_H-CR_' extStr];
%print(h.f,'-dtiff','-loose','-opengl','-r100',[filename '_2']);
print(h.f,'-dtiff','-loose','-opengl','-r300',filename);
set(gca,'yTickLabel',[]); set(gca,'xTickLabel',[]);
plot2svg([filename '.svg'],h.f,'tiff')


%% plot hits & CRs
fig_cnt = 3;
for r = 1:numel(rois)
    roistr = rois{r};
    chns = chIdx.(roistr);
    
    X    = [];
    X{1} = data.([measType 'Hits'])(chns,:);
    X{2} = data.([measType 'CRs'])(chns,:);
    
    figure(1);
    axes(ha(r+1)); set(gca,'yTickLabelMode','auto')
    plotNTraces(X,t,'oc',smoother,smootherSpan);
    if (r+1)==4
        %set(gca,'xTickLabel',get(gca,'xTick'));
        set(gca,'xTickLabelMode','auto');
    end
    
    figure(fig_cnt); clf;
    set(gcf,'position',[200 200, opts.aRatio],'PaperPositionMode','auto')
    h = plotNTraces(X,t,'oc',smoother,smootherSpan,'mean',yLimits);
    if strcmp(opts.lockType,'RT'),set(gca,'YAXisLocation','right'),end
    
    if strcmp(type,'erp'),
        plotPath = [savePath roistr '/'];
    elseif strcmp(type,'ITC')
        plotPath = [savePath roistr '/' opts.band '/'];
    elseif strcmp(type,'power')
        plotPath = [savePath roistr '/' opts.band '/'];
    end
    if ~exist(plotPath,'dir'),mkdir(plotPath),end
    filename = [plotPath '/' opts.hems measType 'H-CR_' roistr extStr];
    %    print(h.f,'-dtiff','-loose','-opengl','-r100',[filename '2']);
    print(h.f,'-dtiff','-loose','-opengl','-r300',filename);
    set(gca,'yTickLabel',[]); set(gca,'xTickLabel',[]);
    plot2svg([filename '.svg'],h.f,'tiff')
    
    
    fig_cnt = fig_cnt + 1;
    
    
    %     h=figure(); clf;
    %     set(h,'position',[200 200,1000,60],'PaperPositionMode','auto','color',[1 1 1])
    %     [~,p]=ttest(data.BinZStat(chns,:));
    %     imagesc(tb,1,-log10(p),[2 4]); colormap hot;
    %     set(gca,'YTick',[]),set(gca,'XTick',xTics); set(gca,'xTickLabel',[]);
    %     set(gca,'linewidth',2),set(gca,'fontweight','bold'),set(gca,'fontsize',15);
    %     xlim(xLim)
    %     set(gca,'Color',[0 0 0]);set(gcf, 'InvertHardCopy', 'off')
    %     filename = [plotPath '/' opts.hems measType 'sigBarERPsH-CR_' roistr extStr];
    %     print(h,'-dtiff','-loose','-opengl','-r200',filename);
    
end
if strcmp(type,'erp'),
    plotPath = [savePath 'group/'];
elseif strcmp(type,'ITC')
    plotPath = [savePath 'group/ITC/' opts.band '/'];
elseif strcmp(type,'power')
    plotPath = [savePath 'group/' opts.band '/'];
end

filename = [plotPath '/' opts.hems 'Comp' comparisonType 'Meas' measType 'groupROIs_H-CR_' extStr];
print(1,'-dtiff','-loose','-opengl','-r300',filename);


%% plot hits / crs for all channels/ LPC

roistr = 'LPC';
chns = (chIdx.AG+chIdx.IPS+chIdx.SPL)==1;

X    = [];
X{1} = data.([measType 'Hits'])(chns,:);
X{2} = data.([measType 'CRs'])(chns,:);

figure(6); clf
set(gcf,'position',[200 200, opts.aRatio],'PaperPositionMode','auto')
h = plotNTraces(X,t,'oc',smoother,smootherSpan);
if strcmp(opts.lockType,'RT'),set(gca,'YAXisLocation','right'),end

if strcmp(type,'erp'),
    plotPath = [savePath roistr '/'];
elseif strcmp(type,'ITC')
    plotPath = [savePath roistr '/' opts.band '/'];
elseif strcmp(type,'power')
    plotPath = [savePath roistr '/' opts.band '/'];
end
if ~exist('plotPath','dir'), mkdir(plotPath); end
filename = [plotPath '/' opts.hems measType 'H-CR_' roistr extStr];
%    print(h.f,'-dtiff','-loose','-opengl','-r100',[filename '2']);
print(h.f,'-dtiff','-loose','-opengl','-r400',filename);
set(gca,'yTickLabel',[]); set(gca,'xTickLabel',[]);
plot2svg([filename '.svg'],h.f,'tiff')


