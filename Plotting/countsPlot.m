% load  hgam data
dataPath ='../Results/Spectral_Data/group/';
fileName = 'allERSPshgamGroupstimLocksublogPowernonLPCleasL1TvalCh10';
load([dataPath fileName])
dataStim = data;

fileName = 'allERSPshgamGroupRTLocksublogPowernonLPCleasL1TvalCh10';
load([dataPath fileName])
dataRT = data;

%% analysis 1
% Channel counts
IPSch = dataStim.hemChanId==1 & dataStim.ROIid==1;
SPLch = dataStim.hemChanId==1 & dataStim.ROIid==2;

IPS_stimdata    = dataStim.BinZStat(IPSch,:);
IPS_RTdata      = dataRT.BinZStat(IPSch,:);
SPL_stimdata    = dataStim.BinZStat(SPLch,:);
SPL_RTdata      = dataRT.BinZStat(SPLch,:);

% count statistcs:
nBoot           = 1000;

IPS_stimMeans    = mean(IPS_stimdata>0);
IPS_stimCI           = bootci(nBoot,@mean,IPS_stimdata>0);

IPS_RTMeans    = mean(IPS_RTdata>0);
IPS_RTCI           = bootci(nBoot,@mean,IPS_RTdata>0);

SPL_stimMeans = mean(SPL_stimdata>0);
SPL_stimCI           = bootci(nBoot,@mean,SPL_stimdata>0);

SPL_RTMeans    = mean(SPL_RTdata>0);
SPL_RTCI           = bootci(nBoot,@mean,SPL_RTdata>0);

%%
stim_time   = mean(dataStim.Bins,2);
RT_time     = mean(dataRT.Bins,2);

figure(1); clf; hold on;
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[100 200 900 300])
axis off

ha = tight_subplot(1,2);
lMargin = 0.1;
bMargin = 0.1;

subAxH      = 0.85;
subAxW      = 0.4;
betweenColSpace = 0.01;

set(ha(1),'position',[lMargin bMargin subAxW subAxH])
set(ha(2),'position',[lMargin+subAxW+betweenColSpace bMargin subAxW subAxH])

% stim lock
axes(ha(1)); hold on;
ylim([0 1])
xlim([-0.2 1.0])
plot(xlim,[.5 0.5],'--k','linewidth',2)
plot([0 0],ylim,'--k','linewidth',2)

h.h1=shadedErrorBar2(stim_time,IPS_stimMeans,IPS_stimCI,{'color', [0.9 0.2 0.2],'linewidth',3},1);
h.h2=shadedErrorBar2(stim_time,SPL_stimMeans,SPL_stimCI,{'color', [0.1 0.5 0.8],'linewidth',3},1);
set(h.h1.mainLine,'marker','.','MarkerSize',11)
set(h.h2.mainLine,'marker','.','MarkerSize',11)
set(gca,'linewidth',2)
set(gca,'fontweight','bold')
set(gca,'fontsize',15);

set(gca,'xticklabel',{ '' , 'stim', '' , 0.4, '', 0.8})
set(gca,'ytick',[0 0.25 0.5 0.75 1.0])
set(gca,'yticklabel',{'0.0', '0.25', '0.5' ,'0.75' , '1.0'})

axes('position', [0 bMargin 0.06 0.85])
text(0.3,0.5,' Proportion of channels (Hits>CRs) ' , 'fontsize',16,'rotation',90, ...
        'VerticalAlignment','middle','horizontalAlignment','center')
set(gca,'visible','off')

% rt lock
axes(ha(2)); hold on;
ylim([0 1])
xlim([-1 0.2])
plot(xlim,[.5 0.5],'--k','linewidth',2)
plot([0 0],ylim,'--k','linewidth',2)

    
h.h1=shadedErrorBar2(RT_time,IPS_RTMeans,IPS_RTCI,{'color', [0.9 0.2 0.2],'linewidth',3},1);
h.h2=shadedErrorBar2(RT_time,SPL_RTMeans,SPL_RTCI,{'color', [0.1 0.5 0.8],'linewidth',3},1);
set(h.h1.mainLine,'marker','.','MarkerSize',11)
set(h.h2.mainLine,'marker','.','MarkerSize',11)
set(gca,'linewidth',2)
set(gca,'fontweight','bold')
set(gca,'fontsize',15);

set(gca,'xticklabel',{ '' , '-0.8', '' , '-0.4', '', 'resp', ''})
set(gca,'ytick',[0 0.25 0.5 0.75 1.0])


