
function f = plotFigure2(data1,data2,opts)
inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';

hemChans    = ismember(data1.subjChans,find(strcmp(opts.hemId,opts.hem)))';
smoother    = opts.smoother;
smootherSpan= opts.smootherSpan;

rois        = {'IPS','SPL'};
chIdx{1}   = data1.ROIid==1 & hemChans;
chIdx{2}   = data1.ROIid==2 & hemChans;

f(1) = figure(1); clf;
set(gcf,'position',[200 200,1000,600],'PaperPositionMode','auto')
ha = tight_subplot(2,2,[0.02 0.02],0.06,[0.1 0.06]);


t{1}   = data1.trialTime;
t{2}   = data2.trialTime;
Xh{1}  = data1.mHits;
Xcr{1} = data1.mCRs;
Xh{2}  = data2.mHits;
Xcr{2} = data2.mCRs;


cnt = 1;
for c = 1:2
    for r = 1:2
        axes(ha(cnt));
        
        X = cell(2,1);
        X{1} = Xh{r}(chIdx{c},:);
        X{2} = Xcr{r}(chIdx{c},:);
        h(cnt)=plotNTraces(X,t{r},'oc', smoother, smootherSpan,'mean',opts.yLimits);
        
        if (cnt==1)
            ylabel('IPS','fontsize',24,'fontWeight','normal')
        end
        if (cnt==2 || cnt==4)
            set(gca,'YAXisLocation','right')
        end
        if (cnt==3 )
            set(gca,'xtick',-0.2:0.2:1)
            set(gca,'XtickLabel',{'','stim','','0.4','','0.8',''})
            ylabel('SPL','fontsize',24,'fontWeight','normal')
        end
        if (cnt==4)
            set(gca,'xtick',-1:0.2:0.2)
            set(gca,'XtickLabel',{'','-0.8','','-0.4','','resp',''})
        end
        set(gca,'fontsize',18,'fontWeight','normal')
        set(gca,'ytick',[0 0.75 1.5])
        set(gca,'yticklabel',{'0','','1.5'})
        
        cnt = cnt +1;
    end
end

cPath = pwd;
cd(opts.plotPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

filename = 'Fig2aHGPTraces';
plot2svg([filename '.svg'],f(1))
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])

cd(cPath)

%% plot renderings

hem         = opts.hem;
chanCoords  = data1.MNILocs(hemChans,:);

cortex      = data1.([hem 'MNIcortex']);
view.l      = [310,30];

binsId{1} = [7,10];
binsId{2} = [7,10];

f(2) = figure(2); clf;
set(gcf,'position',[200 200,1000,600],'PaperPositionMode','auto')
ha = tight_subplot(2,2,[0.1 0.02],[0.01 0.1],[0.1 0.06]);

t{1}   = data1.Bins;
t{2}   = data2.Bins;

X     = cell(2,1);
X{1}  = data1.BinZStat;
X{2}  = data2.BinZStat;

lockType = {'stim','resp'};
cnt = 1;
for r = 1:2
    for c = 1:2
        axes(ha(cnt));
        
        x = X{c}(hemChans,binsId{c}(r));
        plotSurfaceChanWeights(gca, cortex, chanCoords,x,opts)
        loc_view(view.(hem)(1),view.(hem)(2))
        set(gca, 'CameraViewAngle',6)
        h =  title(sprintf('%s-locked  %g to %gms',lockType{c},t{c}(binsId{c}(r),1)*1000,t{c}(binsId{c}(r),2)*1000));
        set(h,'units','normalized','position',[0.5 0.85 0],'fontSize',18)
        set(gca,'clim',[-opts.limitUp opts.limitUp])
        cnt = cnt +1;
    end
end
filename = [opts.plotPath 'Fig2bHGP_Renderings'];
print(f(2),'-dtiff',['-r' num2str(opts.resolution)],filename)

%% plot colorbar

cm = colormap;
f(3)=figure(3); clf;
set(f(3),'position',[-400,100,110,200])
set(f(3),'colormap',cm)
h=colorbar;
set(gca,'visible','off')
set(h,'position',[0.25 0.1 0.5 0.8])
set(h,'yTick',[1 1001 2000],'ytickLabel',[-4 0 4],'box','off','fontSize',20)
set(h,'fontweight','bold')
text(0.95,0.48,'Z','fontsize',24,'fontweight','bold')
set(gcf,'paperSize',[2 3])
set(gcf,'paperPositionMode','auto')
filename = [opts.plotPath 'Fig2bHGP_CM'];
print(f(3),'-dpdf',filename)




