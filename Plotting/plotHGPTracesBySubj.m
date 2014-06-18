
function f = plotHGPTracesBySubj(data1,data2,opts)
inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';

plotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ',... '
    'Manuscript Figures/supplement/'];
Pthr     = 0.05;

hemChans    = ismember(data1.subjChans,find(strcmp(opts.hemId,opts.hem)))';
smoother    = opts.smoother;
smootherSpan= opts.smootherSpan;

rois        = {'IPS','SPL'};
subjs       = find(strcmp(opts.hemId,'l'));

for ii=[1 2]
    chIdx{ii}   = data1.ROIid==ii & hemChans;
end

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

timeLims = opts.timeLims;
yLimits     = opts.yLimits;
timeTicks   = [-0.2:0.2:1; -1:0.2:0.2];
yRefLims    = [yLimits(1)*0.3 yLimits(2)*0.3]; 

f(1) = figure(1); clf;
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

cnt = 1;

for row = 1:2
    for colB = 1:2
        
        axes(ha(cnt)); hold on;
        
        X = cell(2,1);
        XX = [];
        for ii=1:numel(subjs)
            chans = chIdx{row}&(data1.subjChans'==subjs(ii));
            X{1}(ii,:) = nanmean(Xh{colB}(chans,:));
            X{2}(ii,:) = nanmean(Xcr{colB}(chans,:));
            XX(ii,:)    = nanmean(Xz{colB}(chans,:));
        end
        
        hh=plotNTraces(X,t{colB},'oc', smoother, smootherSpan,'mean',yLimits);
        yy=get(gca,'children');
        set(yy(9),'YData',[yRefLims],'color',0.3*ones(3,1))
        set(yy(10),'color',0.3*ones(3,1))
        
        [~,p,~,tt] = ttest(XX);
        sigBins = Bins{colB}(p<Pthr,:);
        hold on;
        for ii = 1:size(sigBins,1)
            if sigBins(ii,1) >= timeLims(colB,1) & sigBins(ii,2) <= timeLims(colB,2)
                plot(sigBins(ii,:),[1.4 1.4],'linewidth',2,'color',0.3*ones(3,1))
                plot(mean(sigBins(ii,:)),1.4,'*','linewidth',2,'color',0.1*ones(3,1))
            end
        end
        
        if colB==2
            set(gca,'YAXisLocation','right','yticklabel',[])
        end
        
        set(gca,'fontsize',18,'fontWeight','normal')
        set(gca,'ytick',[0 0.75 1.5])
        set(gca,'yticklabel',{'0','','1.5'})
        set(gca,'xtick',timeTicks(colB,:),'XtickLabel',[])
        
        if (cnt==1)
            ylabel(' IPS HGP(dB) ','fontsize',20,'fontWeight','normal')
            xx=legend([hh.h1.mainLine,hh.h2.mainLine],'hits','CRs');
            set(xx,'box','off','location','northwest')
        end
        if (cnt==3)
            set(gca,'xtick',-0.2:0.2:1)
            set(gca,'XtickLabel',{'','stim','','0.4','','0.8',''})
            ylabel(' SPL HGP(dB) ','fontsize',20,'fontWeight','normal')
        end
        if (cnt==4)
            set(gca,'xtick',-1:0.2:0.2)
            set(gca,'XtickLabel',{'','-0.8','','-0.4','','resp',''})
        end
        
        cnt = cnt+1;
        
    end
end

cPath = pwd;
cd(plotPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

filename = 'FigHGPallBySubj';
plot2svg([filename '.svg'],gcf)
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
cd(cPath)


