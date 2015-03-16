function plotHGPclustersFig2(data1,clusterSet1,data2,clusterSet2,opts)
inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';
SupPlotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ', 'Manuscript Figures/supplement/'];

fontSize  = 16;
CDB{1}    = clusterSet1.CDB(:,1);
CDB{2}    = clusterSet2.CDB(:,1);

nDC{1}      = clusterSet1.nDC;
nDC{2}      = clusterSet2.nDC;

ClCol{1} = [0.9  0.95 0.2];
ClCol{2} = [0.2 0.95 0.6];
ClCol{3} = [0.6 0.1 0.6];
ClCol{4} = [0 0 0];
ClCol{5} = [1 0 0];

GpCol{1} = [0.9 0.2 0.2];
GpCol{2} = [0.1 0.5 0.8];

thrLines(1)       = clusterSet1.SubClthr;
thrLines(2)       = clusterSet2.SubClthr;
TwoClCol = [ ClCol{2} ; 0.99 0.99 0.99; ClCol{1}];
chanIDs = clusterSet1.ROI_ids;

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

%% figure 2 all

chanLocs    =  data1.MNILocs;
cortex{1}   =  data1.lMNIcortex;
cortex{2}   =  data1.rMNIcortex;
view{1}     = [310,30];
view{2}     = [50,30];
chanNums    = find(clusterSet1.chans);

%temporary hack for channel that doesn't appear
chanLocs(13,:) = chanLocs(13,:)*1.1;

figW = 800;
figH = 600;
if 0
    f(3) = figure(3); clf;
    figW = 800;
    figH = 600;
    set(gcf,'position',[-800 200,figW,figH],'PaperPositionMode','auto','color','w')
    ha = tight_subplot(2,3);
    
    xPos= [0.13  0.46 0.65];
    yPos= [0.51 0.06];
    barW = 0.3;  barH = 0.43;
    
    set(ha(1),'position',[xPos(1) yPos(1) barW barH])
    set(ha(2),'position',[xPos(3) yPos(1) barW barH])
    set(ha(3),'position',[xPos(1) yPos(2) barW barH])
    set(ha(4),'position',[xPos(3) yPos(2) barW barH])
    set(ha(5),'position',[xPos(2) yPos(1) 0.12 barH])
    set(ha(6),'position',[xPos(2) yPos(2) 0.12 barH])
    
    % legend
    axes('position',[0.9 0.48 0.03 0.06]); hold on;
    plot(0.4,2,'o','color',ClCol{1},'markersize',15,'markerfacecolor',ClCol{1})
    plot(0.4,1,'o','color',ClCol{2},'markersize',15,'markerfacecolor',ClCol{2})
    xlim([0 0.8]); ylim([0.75 2.25])
    text(0.9,2,'CL 1','fontsize',fontSize)
    text(0.9,1,'CL 2','fontsize',fontSize)
    set(gca,'visible','off')
    
    % axis on scatters
    axes('position',[0 0 xPos(1) 1]); hold on;
    text(0.9,yPos(2)-0.01,'0','fontsize',fontSize)
    text(0.9,yPos(1)-0.03,'1','fontsize',fontSize)
    text(0.9,yPos(1)+0.01,'0','fontsize',fontSize)
    text(0.9,yPos(1)+barH-0.01,'1','fontsize',fontSize)
    
    text(0.85,yPos(2)+barH/2,' CL 2 (au) ','fontsize',fontSize,'rotation',90, ...
        'VerticalAlignment','middle','horizontalAlignment','center')
    text(0.08,yPos(2)+barH/2,' resp ','fontsize',20, ...
        'VerticalAlignment','middle')
    text(0.85,yPos(1)+barH/2,' CL 2 (au) ','fontsize',fontSize,'rotation',90, ...
        'VerticalAlignment','middle','horizontalAlignment','center')
    text(0.08,yPos(1)+barH/2,' stim ','fontsize',20, ...
        'VerticalAlignment','middle')
    set(gca,'visible','off')
    axes('position',[xPos(1) 0.03 barW yPos(2)-0.03]); hold on;
    text(0.98,0.45,'1','fontsize',fontSize)
    text(0.5,0.1,' CL 1 (au) ', 'fontsize',fontSize, 'horizontalAlignment','center')
    set(gca,'visible','off')
    
    % panel ID
    axes('position', [0.001 0.95 0.3 0.05]); xlim([0 1]); ylim([0 1])
    text(0.05,0.45,' a ','fontsize',28)
    set(gca,'visible','off')
    
    axes('position', [xPos(3) 0.95 0.3 0.05]); xlim([0 1]); ylim([0 1])
    text(0.05,0.45,' b ','fontsize',28)
    set(gca,'visible','off')
    
    % middle panels / bar graphs
    opts2 = opts;
    opts2.colors(1,:) = GpCol{1};
    opts2.colors(2,:) = GpCol{2};
    opts2.baseLine    = 0;
    opts2.yLimits     = [-0.2 0.2];
    
    barIDs = [5 6];
    for row = 1:2
        [sCDB,sIdx] = sort(CDB{row});
        nCL1 = sum(sCDB>=0);
        nCL2 = sum(sCDB<0);
        
        cm      = [ linspace(TwoClCol(1,1),TwoClCol(2,1),nCL2)' linspace(TwoClCol(1,2),TwoClCol(2,2),nCL2)' linspace(TwoClCol(1,3),TwoClCol(2,3),nCL2)' ;
            linspace(TwoClCol(2,1),TwoClCol(3,1),nCL1)' linspace(TwoClCol(2,2),TwoClCol(3,2),nCL1)' linspace(TwoClCol(2,3),TwoClCol(3,3),nCL1)' ];
        
        sChanIDs  = chanIDs(sIdx);
        
        axes(ha(barIDs(row)))
        opts2.thrLine = thrLines(row);
        opts2.cm      = cm;
        scatterClustersByROI(sCDB,sChanIDs,opts2)
        
        set(gca,'ytick',[-0.4 0 0.4],'yticklabel', {'CL2','0','CL1'},'fontsize',fontSize)
        set(gca,'box','off')
        set(gca,'YAXisLocation','right','YDir','reverse')
        if row==2
            axes('position',[xPos(2) 0.01 0.12 0.05]);  xlim([0 1]); ylim([0 1]);
            text(0.08,0.5,'IPS','fontsize',fontSize)
            text(0.58,0.5,'SPL','fontsize',fontSize)
            axis off
        end
        axes('position',[xPos(2)+0.16 yPos(row) 0.02 barH])
        text(0.1,0.5,' DCB (au) ','fontsize',fontSize,'rotation',-90, ...
            'VerticalAlignment','middle','horizontalAlignment','center')
        axis off
    end
    
    for ii=1:4
        axes(ha(ii))
        axis off
    end
    
    % ROI legend
    axes('position',[0.33 .15 0.03 0.06]); hold on;
    plot([0.4],[2],'o','color',GpCol{1},'markersize',10,'markerfacecolor',GpCol{1})
    plot([0.4],[1],'o','color',GpCol{2},'markersize',10,'markerfacecolor',GpCol{2})

    xlim([0 0.8]); ylim([0.5 2.5])
    text(0.9,2,'IPS','fontsize',12)
    text(0.9,1,'SPL','fontsize',12)    
    set(gca,'visible','off')
    % 
    
    cPath = pwd;
    cd(opts.plotPath)
    addpath(cPath)
    addpath([cPath '/Plotting/'])
    
    filename = 'Fig2HGPClusters';
    plot2svg([filename '.svg'],gcf)
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    cd(cPath)
    
    f(3) = figure(3); clf;
    figW = 800;
    figH = 600;
    set(gcf,'position',[-800 200,figW,figH],'PaperPositionMode','auto','color','w')
    ha = tight_subplot(2,3);
    set(ha(1),'position',[xPos(1) yPos(1) barW barH])
    set(ha(2),'position',[xPos(3) yPos(1) barW barH])
    set(ha(3),'position',[xPos(1) yPos(2) barW barH])
    set(ha(4),'position',[xPos(3) yPos(2) barW barH])
    set(ha(5),'position',[xPos(2) yPos(1) 0.12 barH])
    set(ha(6),'position',[xPos(2) yPos(2) 0.12 barH])
    
    cnt = 0;
    for row = 1:2
        cnt = cnt+1;
        
        % scatter plot
        axes(ha(cnt))
        scatterCluster(nDC{row},chanIDs, thrLines(row)*sqrt(2))
        
        % renderings
        cnt = cnt + 1;
        axes(ha(cnt))
        
        [sCDB,sIdx] = sort(CDB{row});
        nCL1 = sum(sCDB>=0);
        nCL2 = sum(sCDB<0);
        
        cm      = [ linspace(TwoClCol(1,1),TwoClCol(2,1),nCL2)' linspace(TwoClCol(1,2),TwoClCol(2,2),nCL2)' linspace(TwoClCol(1,3),TwoClCol(2,3),nCL2)' ;
            linspace(TwoClCol(2,1),TwoClCol(3,1),nCL1)' linspace(TwoClCol(2,2),TwoClCol(3,2),nCL1)' linspace(TwoClCol(2,3),TwoClCol(3,3),nCL1)' ];
        
        sChanIDs  = chanNums(sIdx);
        
        ctmr_gauss_plot(gca,cortex{1},[0 0 0],0,'l');
        el_add(chanLocs(chanNums,:),[0 0 0],15);
        % scaled renderings
        %     for i = 1:numel(chanNums)
        %         el_add(chanLocs(sChanIDs(i),:),cm(i,:),25);
        %     end
        
        % thresholded renderings
        for i = 1:numel(chanNums)
            if sCDB(i) >= thrLines(row)
                el_add(chanLocs(sChanIDs(i),:),[0 0 0],30)
                el_add(chanLocs(sChanIDs(i),:),ClCol{1},25);
            elseif sCDB(i) <= -thrLines(row)
                el_add(chanLocs(sChanIDs(i),:),[0 0 0],30)
                el_add(chanLocs(sChanIDs(i),:),ClCol{2},25);
            end
        end
        loc_view(view{1}(1),view{1}(2))
        set(gca, 'CameraViewAngle',7)
    end
    
    for ii = 5:6
        axes(ha(ii))
        axis off
    end
    
    print(gcf,'-dtiff',['-r' num2str(opts.resolution)],[opts.plotPath filename])
end
%% time courses
if 1
    f = figure(4); clf;
    figW = 1000;
    set(gcf,'position',[-1000 200,figW,figH],'PaperPositionMode','auto','color','w')
    ha = tight_subplot(2,2);
    
    leftMargin = 0.1;
    tcH = 0.44; tcW = 0.415;
    xPos = [leftMargin tcW+leftMargin+0.02];
    yPos = [0.54 0.08];
    
    set(ha(1),'position',[xPos(1) yPos(1) tcW tcH])
    set(ha(2),'position',[xPos(2) yPos(1) tcW tcH])
    set(ha(3),'position',[xPos(1) yPos(2) tcW tcH])
    set(ha(4),'position',[xPos(2) yPos(2) tcW tcH])
    
    % get cluster channels
    CLChans = cell(2,1);
    for ii = 1:2
        CLChans{ii}=union(clusterSet1.subCLChans{ii},clusterSet2.subCLChans{ii});
    end
    %unique(data1.subjChans(CLChans{1}))
    smoother    = opts.smoother;
    smootherSpan= opts.smootherSpan;
    
    yLimits = [-1 3];
    yRefLims= [yLimits(1)*0.3 yLimits(2)*0.3];
    
    cnt = 1;
    for row = 1:2
        for col = 1:2
            axes(ha(cnt));
            
            X = cell(2,1);
            X{1} = Xh{col}(CLChans{row},:);
            X{2} = Xcr{col}(CLChans{row},:);
            h(cnt)=plotNTraces(X,t{col},'oc', smoother, smootherSpan,'mean',yLimits);
            yy=get(gca,'children');
            %set(yy(9),'YData',[-ref0LineLims ref0LineLims],'color',0.3*ones(3,1))
            set(yy(9),'YData',yRefLims,'color',0.3*ones(3,1))
            set(yy(10),'color',0.3*ones(3,1))
            
            [~,pp]  = ttest(Xz{col}(CLChans{row},:));
            sigBins = Bins{col}(pp<opts.Pthr,:);
            hold on;
            for ii = 1:size(sigBins,1)
                if sigBins(ii,1) >= timeLims(col,1) && sigBins(ii,2) <= timeLims(col,2)
                    if row==1
                        plot(sigBins(ii,:),[2 2],'linewidth',2,'color',0.3*ones(3,1))
                        plot(mean(sigBins(ii,:)),2,'*','linewidth',2,'color',0.1*ones(3,1))
                    elseif row==2
                        plot(sigBins(ii,:),[2.8 2.8],'linewidth',2,'color',0.3*ones(3,1))
                        plot(mean(sigBins(ii,:)),2.8,'*','linewidth',2,'color',0.1*ones(3,1))
                    end
                end
            end
            
            set(gca,'xtick',timeTicks(col,:),'XtickLabel',[])
            if (cnt==1)
                ylabel(' CL1  HGP (dB) ','fontsize',fontSize,'fontWeight','normal')
                text(-0.18,-0.8, sprintf('n=%d',numel(CLChans{row})),'fontsize',fontSize)
                xx=legend([h(1).h1.mainLine,h(1).h2.mainLine],'hits','CRs');
                set(xx,'box','off','location','northwest')
            end
            if (cnt==2 || cnt==4)
                set(gca,'YAXisLocation','right')
            end
            if (cnt==3 )
                set(gca,'xtick',-0.2:0.2:1)
                set(gca,'XtickLabel',{'','stim','','0.4','','0.8',''})
                ylabel(' CL2  HGP (dB) ','fontsize',fontSize,'fontWeight','normal')
                text(-0.18,-0.8, sprintf('n=%d',numel(CLChans{row})),'fontsize',fontSize)
            end
            if (cnt==4)
                set(gca,'xtick',-1:0.2:0.2)
                set(gca,'XtickLabel',{'','-0.8','','-0.4','','resp',''})
            end
            set(gca,'fontsize',18,'fontWeight','normal')
            set(gca,'ytick',[0 1.25 2.5])
            set(gca,'yticklabel',{'0','','2.5'})            
            
            cnt = cnt +1;
        end
    end
    
    axes('position', [0.001 0.95 0.3 0.05]); xlim([0 1]); ylim([0 1])
    text(0.05,0.45,' c ','fontsize',28)
    set(gca,'visible','off')
    
    axes('position',[xPos(1) 0 xPos(2)+tcW-xPos(1) 0.08])
    text(0.5,0.25,' Time(s) ','fontsize',20,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
    set(gca,'visible','off')
    
    cPath = pwd;
    cd(opts.plotPath)
    addpath(cPath)
    addpath([cPath '/Plotting/'])
    
    filename = 'Fig2HGPClusterTraces';
    plot2svg([filename '.svg'],gcf)
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    cd(cPath)
    
end
%% stim cluster TC (supplement)
if 1
    f(6) = figure(6); clf;
    figW = 900;
    figH = 600;
    set(gcf,'position',[-1000 200,figW,figH],'PaperPositionMode','auto')
    
    lMargin = 0.1;
    bMargin = 0.06;
    
    subAxH      = 0.42;
    subAxW      = 0.42;
    betweenColSpace = 0.01;
    betweenRowSpace  = 0.05;
    
    ha = tight_subplot(2,2);
    
    set(ha(1),'position',[lMargin bMargin+subAxH+betweenRowSpace subAxW subAxH])
    set(ha(2),'position',[lMargin+subAxW+betweenColSpace bMargin+subAxH+betweenRowSpace subAxW subAxH])
    set(ha(3),'position',[lMargin bMargin subAxW subAxH])
    set(ha(4),'position',[lMargin+subAxW+betweenColSpace bMargin subAxW subAxH])
    
    smoother    = opts.smoother;
    smootherSpan= opts.smootherSpan;
    
    
    yLimits = [-1 3];
    yRefLims= [yLimits(1)*0.3 yLimits(2)*0.3];
    
    yTicks = [0 1.5 3];
    yTickStr = {'0','','3'};
    
    cnt=1;
    for row = 1:2
        for colB = 1:2
            
            axes(ha(cnt)); hold on;
            
            X = cell(2,1);
            chans = clusterSet1.subCLChans{row};
            X{1} = Xh{colB}(chans,:);
            X{2} = Xcr{colB}(chans,:);
            
            h(cnt)=plotNTraces(X,t{colB},'oc', smoother, smootherSpan,'mean',yLimits);
            yy=get(gca,'children');
            set(yy(9),'YData',[yRefLims],'color',0.3*ones(3,1))
            set(yy(10),'color',0.3*ones(3,1))
            
            [~,pp,~,tt] = ttest(Xz{colB}(chans,:));
            sigBins = Bins{colB}(pp<opts.Pthr,:);
            hold on;
            for ii = 1:size(sigBins,1)
                if sigBins(ii,1) >= timeLims(colB,1) && sigBins(ii,2) <= timeLims(colB,2)
                    plot(sigBins(ii,:),[2.8 2.8],'linewidth',2,'color',0.3*ones(3,1))
                    plot(mean(sigBins(ii,:)),2.8,'*','linewidth',2,'color',0.1*ones(3,1))                    
                end
            end
            
            if colB==2
                set(gca,'YAXisLocation','right','yticklabel',[])
            end
            
            set(gca,'fontsize',18,'fontWeight','normal')
            set(gca,'ytick',yTicks)
            set(gca,'yticklabel',yTickStr)
            set(gca,'xtick',timeTicks(colB,:),'XtickLabel',[])
            
            if (cnt==1)
                ylabel(' CL1  HGP (dB) ','fontsize',fontSize,'fontWeight','normal')
                text(-0.18,-0.8, sprintf('n=%d',numel(chans)),'fontsize',fontSize)
                xx=legend([h(1).h1.mainLine,h(1).h2.mainLine],'hits','CRs');
                set(xx,'box','off','location','northwest')
            end
            if (cnt==2 || cnt==4)
                set(gca,'YAXisLocation','right')
            end
            if (cnt==3 )
                set(gca,'xtick',-0.2:0.2:1)
                set(gca,'XtickLabel',{'','stim','','0.4','','0.8',''})
                ylabel(' CL2  HGP (dB) ','fontsize',fontSize,'fontWeight','normal')
                text(-0.18,-0.8, sprintf('n=%d',numel(chans)),'fontsize',fontSize)
            end
            if (cnt==4)
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
    
    filename = 'sFig6_stimCL-HGP-TC';
    plot2svg([filename '.svg'],gcf)
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    cd(cPath)
    
    %%
    f(7) = figure(7); clf;
    figW = 900;
    figH = 600;
    set(gcf,'position',[-1000 200,figW,figH],'PaperPositionMode','auto')
    
    lMargin = 0.1;
    bMargin = 0.06;
    
    subAxH      = 0.42;
    subAxW      = 0.42;
    betweenColSpace = 0.01;
    betweenRowSpace  = 0.05;
    
    ha = tight_subplot(2,2);
    
    set(ha(1),'position',[lMargin bMargin+subAxH+betweenRowSpace subAxW subAxH])
    set(ha(2),'position',[lMargin+subAxW+betweenColSpace bMargin+subAxH+betweenRowSpace subAxW subAxH])
    set(ha(3),'position',[lMargin bMargin subAxW subAxH])
    set(ha(4),'position',[lMargin+subAxW+betweenColSpace bMargin subAxW subAxH])
    
    smoother    = opts.smoother;
    smootherSpan= opts.smootherSpan;
    
    yLimits    = cell(2,1);
    yLimits{1} = [-1 2];
    yLimits{2} = [-1 3.8];
    
    yRefLims    = cell(2,1);
    yRefLims{1} = [yLimits{1}(1)*0.3 yLimits{1}(2)*0.3];
    yRefLims{2} = [yLimits{2}(1)*0.3 yLimits{2}(2)*0.3];
    
    yTicks = cell(2,1);
    yTicks{1} = [0 1 2];
    yTicks{2} = [0 1.5 3];
    
    yTickStr = cell(2,1);
    yTickStr{1} = {'0','','2'};
    yTickStr{2} = {'0','','3'};
    
    cnt=1;
    for row = 1:2
        for colB = 1:2
            
            axes(ha(cnt)); hold on;
            
            X = cell(2,1);
            chans = clusterSet2.subCLChans{row};
            X{1} = Xh{colB}(chans,:);
            X{2} = Xcr{colB}(chans,:);
            
            h(cnt)=plotNTraces(X,t{colB},'oc', smoother, smootherSpan,'mean',yLimits{row});
            yy=get(gca,'children');
            set(yy(9),'YData',[yRefLims{row}],'color',0.3*ones(3,1))
            set(yy(10),'color',0.3*ones(3,1))
            
            [~,pp,~,tt] = ttest(Xz{colB}(chans,:));
            sigBins = Bins{colB}(pp<opts.Pthr,:);
            hold on;
            for ii = 1:size(sigBins,1)
                if sigBins(ii,1) >= timeLims(colB,1) && sigBins(ii,2) <= timeLims(colB,2)
                    if row==1
                        plot(sigBins(ii,:),[1.8 1.8],'linewidth',2,'color',0.3*ones(3,1))
                        plot(mean(sigBins(ii,:)),1.8,'*','linewidth',2,'color',0.1*ones(3,1))                        
                    else
                        plot(sigBins(ii,:),[3.6 3.6],'linewidth',2,'color',0.3*ones(3,1))
                        plot(mean(sigBins(ii,:)),3.6,'*','linewidth',2,'color',0.1*ones(3,1))                        
                    end
                end
            end
            
            if colB==2
                set(gca,'YAXisLocation','right','yticklabel',[])
            end
            
            set(gca,'fontsize',18,'fontWeight','normal')
            set(gca,'ytick',yTicks{row})
            set(gca,'yticklabel',yTickStr{row})
            set(gca,'xtick',timeTicks(colB,:),'XtickLabel',[])
            
            if (cnt==1)
                ylabel(' CL1  HGP (dB) ','fontsize',fontSize,'fontWeight','normal')
                text(-0.18,-0.8, sprintf('n=%d',numel(chans)),'fontsize',fontSize)
                xx=legend([h(1).h1.mainLine,h(1).h2.mainLine],'hits','CRs');
                set(xx,'box','off','location','northwest')
            end
            if (cnt==2 || cnt==4)
                set(gca,'YAXisLocation','right')
            end
            if (cnt==3 )
                set(gca,'xtick',-0.2:0.2:1)
                set(gca,'XtickLabel',{'','stim','','0.4','','0.8',''})
                ylabel(' CL2  HGP (dB) ','fontsize',fontSize,'fontWeight','normal')
                text(-0.18,-0.8, sprintf('n=%d',numel(chans)),'fontsize',fontSize)
            end
            if (cnt==4)
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
    
    filename = 'sFig7_respCL-HGP-TC';
    plot2svg([filename '.svg'],gcf)
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    cd(cPath)
    
end
%% internal functions

    function scatterClustersByROI(sCDB,sChanIDs,opts)
        
        xLims = [0.5 2.5];
        plot(xLims,[opts.baseLine opts.baseLine],'color','k','linewidth',2)
        hold on;
        ylim([-0.45 0.45])
        plot(xLims,[opts.thrLine opts.thrLine],'color',0.4*ones(3,1),'linewidth',2)
        plot(xLims,[-opts.thrLine -opts.thrLine],'color',0.4*ones(3,1),'linewidth',2)
        
        nChans = size(sCDB,1);
        for jj = 1:nChans
            if sChanIDs(jj)==1
                scatter(1+0.05*randn,sCDB(jj),'markerfacecolor',opts.cm(jj,:), ...
                    'SizeData',100,'markeredgecolor',0.6*ones(3,1))
            elseif sChanIDs(jj)==2
                scatter(2+0.05*randn,sCDB(jj),'markerfacecolor',opts.cm(jj,:), ...
                    'SizeData',100,'markeredgecolor',0.6*ones(3,1))
            end
        end
        
        xlim(xLims)
        
        if isfield(opts,'xTicks')
            set(gca,'XTick',opts.xTicks)
        else
            set(gca,'XTick',[])
        end
        
        if isfield(opts,'yTicks')
            set(gca,'YTick',opts.yTicks)
        else
            set(gca,'yTick',[])
        end
        
        set(gca,'LineWidth',2,'FontSize',fontSize,'XTickLabel','')
    end

    function scatterCluster(nDC,chanIDs,thr)
        
        hold on;
        
        verts = [0 0;
            1 0;
            0 1;
            1 1;];
        faces = [1 2 4; 1 3 4];
        
        % reference lines
        rl = refline(1,0);
        set(rl,'linewidth',2,'linestyle','-','color','k')
        rl = refline(1,thr);
        set(rl,'linewidth',2,'linestyle','-','color',0.3*ones(3,1))
        rl = refline(1,-thr);
        set(rl,'linewidth',2,'linestyle','-','color',0.3*ones(3,1))
        xlim([0 1]); ylim([0 1])
        
        p=patch('faces',faces,'vertices', verts, 'edgecolor','none');
        set(p,'facecolor','interp','facevertexcdata',[1 1 1; ClCol{1}; ClCol{2}; 1 1 1],'CDataMapping','direct')
        
        h1 = scatter(nDC(chanIDs==1,1),nDC(chanIDs==1,2));
        set(h1,'markeredgeColor',[0 0 0],'markerfacecolor',GpCol{1}, 'sizeData',100, 'marker','o')
        h2 = scatter(nDC(chanIDs==2,1),nDC(chanIDs==2,2));
        set(h2,'markeredgeColor',[0 0 0],'markerfacecolor',GpCol{2},'sizeData',100, 'marker','o')
        
        set(gca, 'linewidth',4,'xtick',0:0.2:1,'ytick',0:0.2:1,'fontsize',fontSize)
        axis off
        %set(gca,'box','on')
    end

%function renderClusters(sCDB,sChanIDs,opts)

end