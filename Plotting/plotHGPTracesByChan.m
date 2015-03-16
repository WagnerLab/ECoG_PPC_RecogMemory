
function f = plotHGPTracesByChan(data1,data2,opts)
inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';

SupPlotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ', 'Manuscript Figures/supplement/'];
    
hemChans    = ismember(data1.subjChans,find(strcmp(opts.hemId,opts.hem)))';
smoother    = opts.smoother;
smootherSpan= opts.smootherSpan;

rois        = {'IPS','SPL', 'AG'};
chIdx{1}   = data1.ROIid==1 & hemChans;
chIdx{2}   = data1.ROIid==2 & hemChans;
chIdx{3}   = data1.ROIid==3 & hemChans;

% rights
chIdx{4}   = data1.ROIid==1 & ~hemChans;
chIdx{5}   = data1.ROIid==2 & ~hemChans;
chIdx{6}   = data1.ROIid==3 & ~hemChans;

t{1}   = data1.trialTime;
t{2}   = data2.trialTime;
Xh{1}  = data1.mHits;
Xcr{1} = data1.mCRs;
Xh{2}  = data2.mHits;
Xcr{2} = data2.mCRs;
Xz{1}  = data1.BinZStat;
Xz{2}  = data2.BinZStat;
Bins{1}= data1.Bins;
Bins{2}= data2.Bins;

timeLims    = opts.timeLims;
timeTicks   = [-0.2:0.2:1; -1:0.2:0.2];
yLimits     = opts.yLimits;

%% plot traces
if 0
    f(1) = figure(1); clf;
    set(gcf,'position',[200 200,1000,600],'PaperPositionMode','auto')
    ha = tight_subplot(2,2,[0.02 0.02],0.06,[0.1 0.06]);
    
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
    
    filename = 'FigHGPTracesByChan';
    plot2svg([filename '.svg'],f(1))
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    
    cd(cPath)
end

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
end

%% plot barplots

if 0
    f(4) = figure(4); clf;
    set(gcf,'position',[200 200,200,600],'PaperPositionMode','auto')
    ha = tight_subplot(2,2,[0.02 0.02],[0.06 0.06],[0.20 0.06]);
    
    rHandles = [1 3];
    opts.timeLims   = [0 1];
    opts.t  = t{1};
    for r = 1:2
        chans = chIdx{r};
        X = cell(2,1);
        X{1} = Xh{1}(chans,:);
        X{2} = Xcr{1}(chans,:);
        
        conditionBarPlots (ha(rHandles(r)),X, opts)
    end
    
    rHandles = [2 4];
    opts.Bins  = t{2};
    opts.timeLims   = [-0.6 0.1];
    for r = 1:2
        X = cell(2,1);
        chans = chIdx{r};
        X{1} = Xh{2}(chans,:);
        X{2} = Xcr{2}(chans,:);
        
        conditionBarPlots (ha(rHandles(r)),X, opts)
        set(gca,'YAXisLocation','right','yticklabel',[])
        set(gca, 'yTick',[0 0.75 1.5],'yticklabel',{'0','','1.5'})
    end
    
    cPath = pwd;
    cd(opts.plotPath)
    addpath(cPath)
    addpath([cPath '/Plotting/'])
    
    filename = 'FigHGPbarPlotsByChan';
    plot2svg([filename '.svg'],gcf)
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    cd(cPath)
end

%% bar graphs and time courses

if 1
    f(5) = figure(5); clf;
    figW = 1200;
    figH = 600;
    set(gcf,'position',[200 200,figW,figH],'PaperPositionMode','auto')
    ha = tight_subplot(2,4);
    
    xPos= [0.1 0.43 0.52 0.61];
    yPos= [0.55 0.09];
    tcW = 0.32; bW  = 0.08; tcH = 0.44;
    
    linePos = 0.89;
    
    set(ha(1),'position',[xPos(1) yPos(1) tcW tcH])
    set(ha(2),'position',[xPos(2) yPos(1) bW  tcH])
    set(ha(3),'position',[xPos(3) yPos(1) bW  tcH])
    set(ha(4),'position',[xPos(4) yPos(1) tcW tcH])
    
    set(ha(5),'position',[xPos(1) yPos(2) tcW tcH])
    set(ha(6),'position',[xPos(2) yPos(2) bW  tcH])
    set(ha(7),'position',[xPos(3) yPos(2) bW  tcH])
    set(ha(8),'position',[xPos(4) yPos(2) tcW tcH])
        
    cnt = 1;
    AxOrdHandles = [1 2 4 3 5 6 8 7];
    
    yRefLims    = [yLimits(1)*0.3 yLimits(2)*0.3];    
    for row = 1:2
        for colB = 1:2
            
            axes(ha(AxOrdHandles(cnt)));
            
            X = cell(2,1);
            X{1} = Xh{colB}(chIdx{row},:);
            X{2} = Xcr{colB}(chIdx{row},:);
            hh=plotNTraces(X,t{colB},'oc', smoother, smootherSpan,'mean',yLimits);
            yy=get(gca,'children');
            set(yy(9),'YData',[yRefLims],'color',0.3*ones(3,1))
            set(yy(10),'color',0.3*ones(3,1))
            
            [~,p] = ttest(Xz{colB}(chIdx{row},:));
            sigBins = Bins{colB}(p<opts.Pthr,:);
            hold on;
            for ii = 1:size(sigBins,1)
                if sigBins(ii,1) >= timeLims(colB,1) & sigBins(ii,2) <= timeLims(colB,2)
                    plot(sigBins(ii,:),[1.4 1.4],'linewidth',2,'color',0.3*ones(3,1))
                    plot(mean(sigBins(ii,:)),1.4,'*','linewidth',2,'color',0.1*ones(3,1))
                end
            end
            
            if colB==2 % second column block, for RTs
                set(gca,'YAXisLocation','right','yticklabel',[])
            end
            
            set(gca,'fontsize',18,'fontWeight','normal')
            set(gca,'ytick',[0 0.75 1.5])
            set(gca,'yticklabel',{'0','','1.5'})
            set(gca,'xtick',timeTicks(colB,:),'XtickLabel',[])
            
            if (cnt==1) % left upper plot
                ylabel(' IPS HGP(dB) ','fontsize',20,'fontWeight','normal')
                xx=legend([hh.h1.mainLine,hh.h2.mainLine],'hits','CRs');
                set(xx,'box','off','location','best')
            end
            
            if (cnt==5) % left lower plot
                set(gca,'XtickLabel',{'','stim','','0.4','','0.8',''})
                ylabel(' SPL HGP(dB) ','fontsize',20,'fontWeight','normal')
            end
            
            if (cnt==7) % lower right plot
                set(gca,'XtickLabel',{'','-0.8','','-0.4','','resp',''})
            end
            
            cnt = cnt+1;
            
            % bars
            opts2           = opts;
            opts2.t         = t{colB};
            opts2.timeLims  = timeLims(colB,:);
            
            conditionBarPlots(ha(AxOrdHandles(cnt)),X, opts2)
            if colB==2
                set(gca,'YAXisLocation','right')
            end
            set(gca,'yTick',[0 0.75 1.5])
            set(gca,'yticklabel',[])
            if cnt == 6
                set(gca,'xtick',1.5,'xticklabel','stim')
            end
            if cnt == 8
                set(gca,'xtick',1.5,'xticklabel','resp')
            end
            
            cnt = cnt+1;
        end
    end
    
    axes('position', [0.001 0.95 0.3 0.05]); xlim([0 1]); ylim([0 1])
    text(0.05,0.45,' b ','fontsize',28)
    %text(0.05,0.45,'b. HGP (dB)','fontsize',24,'fontWeight','bold')
    set(gca,'visible','off')
    
    axes('position',[xPos(1) 0 tcW 0.08])
    text(0.5,0.25,' Time(s) ','fontsize',20,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
    set(gca,'visible','off')
    
    axes('position',[xPos(4) 0 tcW 0.08])
    text(0.5,0.25,' Time(s) ','fontsize',20,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
    set(gca,'visible','off')
    
    cPath = pwd;
    cd(opts.plotPath)
    addpath(cPath)
    addpath([cPath '/Plotting/'])
    
    filename = 'FigHGPallByChan';
    plot2svg([filename '.svg'],gcf)
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    cd(cPath)
end

%% plot AG trace

if 0
    f(6) = figure(6); clf;
    figW = 900;
    figH = 300;
    
    set(gcf,'position',[200 200,figW,figH],'PaperPositionMode','auto')
    ha = tight_subplot(1,2);
    
    lMargin = 0.1;
    bMargin = 0.1;
    
    subAxH      = 0.85;
    subAxW      = 0.4;
    betweenColSpace = 0.01;
    
    set(ha(1),'position',[lMargin bMargin subAxW subAxH])
    set(ha(2),'position',[lMargin+subAxW+betweenColSpace bMargin subAxW subAxH])
    
    yLimits = [-1 1];
    yRefLims    = [yLimits(1)*0.3 yLimits(2)*0.3]; 
    
    cnt = 1;    
    row=3;
    for colB = 1:2
        
        axes(ha(cnt));
        
        X = cell(2,1);
        X{1} = Xh{colB}(chIdx{row},:);
        X{2} = Xcr{colB}(chIdx{row},:);
        hh=plotNTraces(X,t{colB},'oc', smoother, smootherSpan,'mean',yLimits);
        yy=get(gca,'children');
        set(yy(9),'YData',[yRefLims],'color',0.3*ones(3,1))
        set(yy(10),'color',0.3*ones(3,1))
        
        [~,p] = ttest(Xz{colB}(chIdx{row},:));
        sigBins = Bins{colB}(p<opts.Pthr,:);
        hold on;
        for ii = 1:size(sigBins,1)
            if sigBins(ii,1) >= timeLims(colB,1) & sigBins(ii,2) <= timeLims(colB,2)
                    plot(sigBins(ii,:),[1.4 1.4],'linewidth',2,'color',0.3*ones(3,1))
                    plot(mean(sigBins(ii,:)),1.4,'*','linewidth',2,'color',0.1*ones(3,1))
            end
        end
        
        if colB==2 % second column block, for RTs
            set(gca,'YAXisLocation','right','yticklabel',[])
        end
        
        set(gca,'fontsize',18,'fontWeight','normal')
        set(gca,'ytick',[-0.5 0  0.5])
        set(gca,'yticklabel',{'-0.5','0','0.5'})
        
        if (cnt==1) % left upper plot
            %ylabel(' AG HGP(dB) ','fontsize',20,'fontWeight','normal')
            xx=legend([hh.h1.mainLine,hh.h2.mainLine],'hits','CRs');
            set(xx,'box','off','location','northwest')
            set(gca,'xtick',-0.2:0.2:1)
            set(gca,'XtickLabel',{'','stim','','0.4','','0.8',''})
        end
        
        if (cnt==2) % lower right plot
            set(gca,'xtick',-1:0.2:0.2)
            set(gca,'XtickLabel',{'','-0.8','','-0.4','','resp',''})
        end
        
        cnt = cnt+1;
    end
    
    axes('position', [0 bMargin 0.06 0.85])
    text(0.4,0.5,' AG HGP(dB) ','fontsize',20,'rotation',90, ...
        'VerticalAlignment','middle','horizontalAlignment','center')
    set(gca,'visible','off')
    
    % axes('position', [0.001 0.95 0.3 0.05]); xlim([0 1]); ylim([0 1])
    % text(0.05,0.45,' b ','fontsize',28)
    % set(gca,'visible','off')
    
    cPath = pwd;
    cd(SupPlotPath)
    addpath(cPath)
    addpath([cPath '/Plotting/'])
    
    filename = 'sFig4_AG-HGP-TC';
    plot2svg([filename '.svg'],gcf)
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    cd(cPath)
end

%% plot TC for rights

if 0
    f(7) = figure(7); clf;
    figW = 900;
    figH = 900;
    set(gcf,'position',[-1000 200,figW,figH],'PaperPositionMode','auto')
    ha = tight_subplot(3,2);
    
    lMargin = 0.1;
    bMargin = 0.05;

    subAxH      = 0.28;
    subAxW      = 0.42;
    betweenColSpace = 0.01;
    betweenRowSpace = 0.03;
    
    yPos    = zeros(3,1);
    yPos(3) = bMargin;
    yPos(2) = yPos(3)+subAxH+betweenRowSpace;
    yPos(1) = yPos(2)+subAxH+betweenRowSpace;
    
    xPos    = zeros(2,1);
    xPos(1) = lMargin;
    xPos(2) = xPos(1)+subAxW+betweenColSpace;
    
    cnt = 1;
    for jj = 1:3
        for ii =1:2
            set(ha(cnt),'position',[xPos(ii) yPos(jj) subAxW subAxH])
            cnt = cnt+1;
        end
    end
    
    cnt = 1;    
    yLimits = [-1 1.8];
    yRefLims    = [yLimits(1)*0.3 yLimits(2)*0.3]; 
    for row = 1:3
        for colB = 1:2
            
            axes(ha(cnt));
            
            X = cell(2,1);
            X{1} = Xh{colB}(chIdx{row+3},:);
            X{2} = Xcr{colB}(chIdx{row+3},:);
            hh=plotNTraces(X,t{colB},'oc', smoother, smootherSpan,'mean',yLimits);
            yy=get(gca,'children');
            set(yy(9),'YData',[yRefLims],'color',0.3*ones(3,1))
            set(yy(10),'color',0.3*ones(3,1))
            
            [~,p] = ttest(Xz{colB}(chIdx{row+3},:));
            sigBins = Bins{colB}(p<opts.Pthr,:);
            hold on;
            for ii = 1:size(sigBins,1)
                if sigBins(ii,1) >= timeLims(colB,1) & sigBins(ii,2) <= timeLims(colB,2)
                     plot(sigBins(ii,:),[1.4 1.4],'linewidth',2,'color',0.3*ones(3,1))
                    plot(mean(sigBins(ii,:)),1.4,'*','linewidth',2,'color',0.1*ones(3,1))
                end
            end
           
            if colB==2 % second column block, for RTs
                set(gca,'YAXisLocation','right','yticklabel',[])
            end
            
            set(gca,'fontsize',18,'fontWeight','normal')
            set(gca,'ytick',[0 0.75 1.5])
            set(gca,'yticklabel',{'0','','1.5'})
            set(gca,'xtick',timeTicks(colB,:),'XtickLabel',[])
            
            if (cnt==1) % left upper plot
                ylabel(' IPS HGP(dB) ','fontsize',20,'fontWeight','normal')
                xx=legend([hh.h1.mainLine,hh.h2.mainLine],'hits','CRs');
                set(xx,'box','off','location','best')
            end
            if (cnt==3) % left middle plot
                ylabel(' SPL HGP(dB) ','fontsize',20,'fontWeight','normal')                
            end
            
            if (cnt==5) % left lower plot

                set(gca,'XtickLabel',{'','stim','','0.4','','0.8',''})
                ylabel(' AG HGP(dB) ','fontsize',20,'fontWeight','normal')
            end
            
            if (cnt==6) % lower right plot
                set(gca,'xtick',-1:0.2:0.2)
                set(gca,'XtickLabel',{'','-0.8','','-0.4','','resp',''})
            end
            
            cnt = cnt+1;
        end
    end
    
    cPath = pwd;
    cd(SupPlotPath)
    addpath(cPath)
    addpath([cPath '/Plotting/'])
    
    filename = 'sFig5_Rights-HGP-TC';
    plot2svg([filename '.svg'],gcf)
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    cd(cPath)
end

%%

function conditionBarPlots (ha,X, opts)

Bins    = (opts.t >= opts.timeLims(1)) & (opts.t <= opts.timeLims(2));

opts.colors(1,:)    = [0.9 0.5 0.1]; % color for condition 1
opts.colors(2,:)  = [0.1 0.8 0.9]; % color for condition 2

M = cell(2,1);
for c = 1:2
    M{c} = mean(X{c}(:,Bins),2);
end

%opts.baseLine = -0.0225;
barPlotWithErrors(ha,M,opts);




