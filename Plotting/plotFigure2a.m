
function f = plotFigure2a(data1,data2,opts)

hemChans    = ismember(data1.subjChans,find(strcmp(opts.hemId,opts.hems)))';
smoother    = opts.smoother;
smootherSpan= opts.smootherSpan;

rois        = {'IPS','SPL'};
chIdx{1}   = data1.ROIid==1 & hemChans;
chIdx{2}   = data1.ROIid==2 & hemChans;

f = figure(); clf;
set(gcf,'position',[200 200,1200,800],'PaperPositionMode','auto')
ha = tight_subplot(2,2,[0.02 0.04],0.06,0.06);


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
        
        if (cnt ==1)
            ylabel('IPS','fontsize',20)
        end
        if (cnt==2 || cnt==4)
            set(gca,'YAXisLocation','right')
        end
        if (cnt==3 )
            set(gca,'XtickLabel',{'-0.2','stim','0.2','0.4','0.6','0.8','1.0'})
            ylabel('SPL','fontsize',20)
        end
        if (cnt==4)
            set(gca,'XtickLabel',{'-1.0','-0.8','-0.6','-0.4','-0.2','resp','0.2'})
        end
        set(gca,'fontsize',18)
        set(gca,'ytick',[-0.5 0 0.7 1.5])
        set(gca,'yticklabel',get(gca,'ytick'))
        
        cnt = cnt +1;
    end
end