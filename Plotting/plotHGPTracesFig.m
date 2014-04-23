
function f = plotHGPTracesFig(data1,data2,opts)
inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';

hemChans    = ismember(data1.subjChans,find(strcmp(opts.hemId,opts.hem)))';
smoother    = opts.smoother;
smootherSpan= opts.smootherSpan;

rois        = {'IPS','SPL'};
subjs       = find(strcmp(opts.hemId,'l'));

for ii=[1 2]
    chIdx{ii}   = data1.ROIid==ii & hemChans;
end

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
        for ii=1:numel(subjs)
            chans = chIdx{c}&(data1.subjChans'==subjs(ii));
            X{1}(ii,:) = nanmean(Xh{r}(chans,:));
            X{2}(ii,:) = nanmean(Xcr{r}(chans,:));
        end
        
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

filename = 'FigHGPTraces';
plot2svg([filename '.svg'],f(1))
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
eval(['!rm ' filename '.svg'])

cd(cPath)

%% plot renderings

if 0
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
    
    % plot colorbar
    
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
end

%% plot barplots

f(4) = figure(4); clf;
set(gcf,'position',[200 200,200,600],'PaperPositionMode','auto')
ha = tight_subplot(2,2,[0.02 0.02],[0.06 0.06],[0.20 0.06]);

rHandles = [1 3];
opts.timeLims   = [0 1];
opts.t  = t{1};
for r = 1:2
    opts.ROInums    = [r];
    X = cell(2,1);
    for ii=1:numel(subjs)
        chans = chIdx{r}&(data1.subjChans'==subjs(ii));
        X{1}(ii,:) = nanmean(Xh{1}(chans,:));
        X{2}(ii,:) = nanmean(Xcr{1}(chans,:));
    end
    conditionBarPlots (ha(rHandles(r)),X, opts)
end

rHandles = [2 4];
opts.Bins  = t{2};
opts.timeLims   = [-0.6 0.1];
for r = 1:2
    opts.ROInums    = [r];
    X = cell(2,1);
    for ii=1:numel(subjs)
        chans = chIdx{r}&(data2.subjChans'==subjs(ii));
        X{1}(ii,:) = nanmean(Xh{2}(chans,:));
        X{2}(ii,:) = nanmean(Xcr{2}(chans,:));
    end
    conditionBarPlots (ha(rHandles(r)),X, opts)
    set(gca,'YAXisLocation','right','yticklabel',[])
end

cPath = pwd;
cd(opts.plotPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

filename = 'Fig2HGPbarPlots';
plot2svg([filename '.svg'],gcf)
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
cd(cPath)

function conditionBarPlots (ha,X, opts)

Bins    = (opts.t >= opts.timeLims(1)) & (opts.t <= opts.timeLims(2));

opts.colors(1,:)    = [0.9 0.5 0.1]; % color for condition 1
opts.colors(2,:)  = [0.1 0.8 0.9]; % color for condition 2

M = cell(2,1);
for c = 1:2
    M{c} = mean(X{c}(:,Bins),2);   
end

barPlotWithErrors(ha,M,opts);
set(gca, 'yTick',[0 0.75 1.5],'yticklabel',{'0','','1.5'})



