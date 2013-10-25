
function plotSubROI_ERPs(data,opts)

close all;

savePath        = opts.plotPath;
type            = opts.type;
band            = opts.band;
measType        = opts.measType ;
smoother        = opts.smoother;
smootherSpan    = opts.smootherSpan;
hemChans        = ismember(data.subjChans,find(strcmp(opts.hemId,opts.hems)))';
t               = data.trialTime;
extStr          = data.extension;

subROIs         = {'pIPS','aIPS','pSPL','aSPL'};
nRois           = numel(subROIs);
chIdx           = [];

for r = 1:nRois
    chIdx.(subROIs{r}) = data.subROIid==r & hemChans; 
end

if ~strcmp(type,'erp'), extStr = [band extStr];end

%% plot hits & CRs
close all;
figure(1); clf; ha=tight_subplot(4,1,0.02,[0.05 0.01],[0.1 0.01]); axes(ha(1));
set(gca,'yTickLabelMode','auto')
set(gcf,'position',[200 200,300,2000],'PaperPositionMode','auto')
for r = 1:numel(subROIs)
    roistr = subROIs{r};
    chns = chIdx.(roistr);
    
    X{1} = data.([measType 'Hits'])(chns,:);
    X{2} = data.([measType 'CRs'])(chns,:);
    
    figure(1);
    axes(ha(r)); set(gca,'yTickLabelMode','auto')
    plotNTraces(X,t,'oc',smoother,smootherSpan);   
    if (r)==4
        set(gca,'xTickLabelMode','auto');
    end
    
    figure(r+1); clf;
    set(gcf,'position',[200 200,300,200],'PaperPositionMode','auto')   
    h = plotNTraces(X,t,'oc',smoother,smootherSpan);     
    xTics = get(gca,'XTick');
    xLim = xlim;
    if strcmp(type,'erp'),
        plotPath = [savePath roistr '/'];
    elseif strcmp(type,'ITC')
        plotPath = [savePath roistr '/' opts.band '/'];
    elseif strcmp(type,'power')
        plotPath = [savePath roistr '/' opts.band '/'];
    end
    if ~exist(plotPath,'dir'),mkdir(plotPath),end
    filename = [plotPath '/' opts.hems measType 'H-CR_' roistr extStr];
    %print(h.f,'-dtiff','-loose','-opengl','-r100',[filename '2']);
    set(gca,'yTickLabel',[]); set(gca,'xTickLabel',[]);
    print(h.f,'-dtiff','-loose','-opengl','-r400',filename);
    
    
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

filename = [plotPath '/' opts.hems 'Meas' measType 'groupSubROIs_H-CR_' extStr];
print(1,'-dtiff','-loose','-opengl','-r300',filename);



