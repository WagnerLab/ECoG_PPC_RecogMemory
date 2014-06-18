function plotERPsByChan(data1,data2, opts) 
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

f(1) = figure(2); clf;
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
yLimits     = [-20 20];
yRefLims    = [yLimits(1)*0.3 yLimits(2)*0.3];
yTicks      = [-15 0 15];

sigBar = 19;
for row = 1:3
    for colB = 1:2
        
        axes(ha(cnt));
        
        X = cell(2,1);
        X{1} = Xh{colB}(chIdx{row},:);
        X{2} = Xcr{colB}(chIdx{row},:);
        hh=plotNTraces(X,t{colB},'oc', smoother, smootherSpan,'mean',yLimits);
        yy=get(gca,'children');
        set(yy(9),'YData',yRefLims,'color',0.3*ones(3,1))
        set(yy(10),'color',0.3*ones(3,1))
        
        [~,p] = ttest(Xz{colB}(chIdx{row},:));
        sigBins = Bins{colB}(p<opts.Pthr,:);
        hold on;
        for ii = 1:size(sigBins,1)
            if sigBins(ii,1) >= timeLims(colB,1) & sigBins(ii,2) <= timeLims(colB,2)
                plot(sigBins(ii,:),[sigBar sigBar],'linewidth',2,'color',0.3*ones(3,1))
                plot(mean(sigBins(ii,:)),[sigBar sigBar],'*','linewidth',2,'color',0.1*ones(3,1))
            end
        end
        
        if colB==2 % second column block, for RTs
            set(gca,'YAXisLocation','right','yticklabel',[])
        end
        
        set(gca,'fontsize',18,'fontWeight','normal')
        set(gca,'ytick',yTicks)
        set(gca,'yticklabel',{num2str(yTicks(1)),'',num2str(yTicks(3))})
        set(gca,'xtick',timeTicks(colB,:),'XtickLabel',[])
        
        if (cnt==1) % left upper plot
            ylabel(' IPS (\muV) ','fontsize',20,'fontWeight','normal')
            xx=legend([hh.h1.mainLine,hh.h2.mainLine],'hits','CRs');
            set(xx,'box','off','location','best')
        end
        if (cnt==3) % left middle plot
            ylabel(' SPL (\muV) ','fontsize',20,'fontWeight','normal')
        end
        
        if (cnt==5) % left lower plot
            set(gca,'xtick',-0.2:0.2:1)
            set(gca,'XtickLabel',{'','stim','','0.4','','0.8',''})
            ylabel(' AG (\muV) ','fontsize',20,'fontWeight','normal')
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

filename = 'sFig10_ERPs-TC';
plot2svg([filename '.svg'],gcf)
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
cd(cPath)