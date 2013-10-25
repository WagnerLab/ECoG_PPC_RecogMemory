
%
h=figure(3); clf; set(gcf,'position',[50 50 800 700],'paperPositionMode','auto')

ids = (S.hemChanId==1);
ha = tight_subplot(2,2,[0.1 0.1],[0.05 0.05],[0.05 0.05]);
axes(ha(1)); hold on;
xlim([0.5 3.5]);
plot(xlim,[0.5 0.5],'--','color',[0.7 0.7 0.7],'linewidth',2); ylim([0 1])
for r = 1:3
    chans   = S.ROIid.*(ids) == r;
    nChans  = sum(chans);
    
    y   = S.FAmBAC(chans);
    yM  = nanmean(y);
    yS  = nanstd(y)/sqrt(nChans-1);
    
    scatter(r+randn(nChans,1)*0.03,y,'k','filled')
    plot([r-0.2 r+0.2],[yM yM],'r','linewidth',5)
    plot([r r],[yM-yS  yM+yS],'color',[0.7 0.3 0.3],'linewidth',4)
    
end
set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',{'new' 0.25 0.50 0.75 'old'},'fontSize',12)
set(gca,'XTick',1:3,'XTickLabel', S.ROIs)
set(gca,'FontSize',12,'LineWidth',2)
set(gca,'Box','off')
title( 'All left channels FA')

axes(ha(2))
%gscatter(S.mBAC(ids),S.FAmBAC(ids),S.ROIid(ids),'rbg','.',20,'off');
scatter(S.mBAC(ids),S.FAmBAC(ids),'k','filled');
h1=lsline;set(h1,'linewidth',2,'color','r'); hold on; plot(xlim,[0.5 0.5],'--','color',[0.7 0.7 0.7],'linewidth',2); ylim([0 1])
set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',[],'fontSize',12)
%set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',{'new' 0.25 0.50 0.75 'old'},'fontSize',12)
set(gca,'FontSize',12,'LineWidth',2)
title( 'All left channels FA')

axes(ha(3));hold on
xlim([0.5 3.5]);
plot(xlim,[0.5 0.5],'--','color',[0.7 0.7 0.7],'linewidth',2); ylim([0 1])
for r = 1:3
    chans   = S.ROIid.*(ids) == r;
    nChans  = sum(chans);
    
    y   = S.MISSmBAC(chans);
    yM  = nanmean(y);
    yS  = nanstd(y)/sqrt(nChans-1);
    
    scatter(r+randn(nChans,1)*0.03,y,'k','filled')
    plot([r-0.2 r+0.2],[yM yM],'r','linewidth',5)
    plot([r r],[yM-yS  yM+yS],'color',[0.7 0.3 0.3],'linewidth',4)
    
end
set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',{'new' 0.25 0.50 0.75 'old'},'fontSize',12)
set(gca,'XTick',1:3,'XTickLabel', S.ROIs)
set(gca,'FontSize',12,'LineWidth',2)
set(gca,'Box','off')
title( 'All left channels MISS')

axes(ha(4))
%gscatter(S.mBAC(ids),S.MISSmBAC(ids),S.ROIid(ids),'rbg','.',20,'off');
scatter(S.mBAC(ids),S.MISSmBAC(ids),'k','filled');
h1=lsline;set(h1,'linewidth',2,'color','r'); hold on; plot(xlim,[0.5 0.5],'--','color',[0.7 0.7 0.7],'linewidth',2); ylim([0 1])
%set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',{'new' 0.25 0.50 0.75 'old'},'fontSize',12)
set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',[],'fontSize',12)
set(gca,'FontSize',12,'LineWidth',2)
title( 'All left channels MISS')

% axes(ha(3))
% imagesc(corr([S.mBAC(ids) S.FAmBAC(ids) S.MISSmBAC(ids)]),[-1 1]); colormap(CMRmap(1000)); colorbar
% set(gca,'YTick',1:3,'YTicklabel',{'ACC' 'FA' 'MISS'},'xTick',1:3,'xTicklabel',{'ACC' 'FA' 'MISS'})
% set(gca,'FontSize',14)
% pos = get(gca,'position');
% set(gca,'position',[pos(1) pos(2)-0.25 pos(3)*1.25 pos(4)])
%
% set(ha(6),'Visible','off')

mainPath    = '~/Documents/ECOG/Results/Plots/Classification/channel/';
savePath    = [mainPath opts.dataType '/' opts.lockType '/'];
fileName = ['lFA-MISS_RelationToACC' opts.fileName];
print(gcf,'-depsc2',[savePath fileName])

%% render objective channels

hemNum  = 1;
res     = 500;


addpath '/Users/alexg8/Documents/ECOG/scripts/Doras_rendering_scripts/render_brains/'
temp = load('/Users/alexg8/Documents/ECOG/Results/ERP_Data/group/allERPsGroupstimLocksubAmpnonLPCleasL1TvalCh10.mat');
chanLocs    =  temp.data.MNILocs;
cortex{1}   =  temp.data.lMNIcortex;
cortex{2}   =  temp.data.rMNIcortex; clear temp;
hem_str     = {'l','r'};
view{1}     = [310,30];
view{2}     = [50,30];


ids         = (S.hemChanId==hemNum);
sigChans    = S.meBAC.*ids      >= 0.55;
objFAch     = S.FAmBAC.*ids     <= 0.50;
objMIch     = S.MISSmBAC.*ids   >= 0.50;

cols        = [ 0.9 0.2 0.2;
                0.1 0.5 0.8;
                0.2 0.6 0.3];

sCh(:,1)     = sigChans&(S.ROIid==1); nsIPS       = sum(sCh(:,1));
sCh(:,2)     = sigChans&(S.ROIid==2); nsSPL       = sum(sCh(:,2));
sCh(:,3)     = sigChans&(S.ROIid==3); nsAG        = sum(sCh(:,3));

h=figure();clf;
limitUp     = 0.5;
%limitDw     = 0;

Colors = [;
    0.1 0 1;
    0 1 1;
    0 1 0.7;
    0.7 0.7 0.7;
    0.7 0.7 0.7;
    0.7 1 0;
    1 1 0;
    1 0 0.1;];

nLevels = size(Colors,1)/2;
levels = [linspace(-limitUp,0,nLevels),linspace(0,limitUp,nLevels)];
clbar_map = cMapGenerate(Colors,levels);

set(h,'Position',[200 200 800 800]);
ctmr_gauss_plot(gca,cortex{hemNum},chanLocs(sigChans,:),S.FAmBAC(sigChans)-0.5,hem_str{hemNum},clbar_map)
loc_view(view{hemNum}(1),view{hemNum}(2))
el_add(chanLocs(ids,:),'k',12)
set(gca,'clim',[-0.5 0.5]);  colorbar

% %ctmr_gauss_plot(gca,cortex{hemNum},[0 0 0],0,hem_str{hemNum})
% loc_view(view{hemNum}(1),view{hemNum}(2))
% %el_add(chanLocs(ids,:),'k',12)
% 
% for r = 1:3    
%     el_add(chanLocs(sCh(:,r)&objFAch,:),cols(r,:),24)
% end

mainPath    = '~/Documents/ECOG/Results/Plots/Classification/channel/';
savePath    = [mainPath opts.dataType '/' opts.lockType '/'];
fileName    = [hem_str{hemNum} 'RenObjFAchAC' opts.fileName];
print(h,'-dtiff',['-r' num2str(res)],[savePath fileName])

h=figure();clf;
% colorbar limits

set(h,'Position',[200 200 800 800]);
%ctmr_gauss_plot(gca,cortex{hemNum},[0 0 0],0,hem_str{hemNum})
ctmr_gauss_plot(gca,cortex{hemNum},chanLocs(sigChans,:),S.MISSmBAC(sigChans)-0.5,hem_str{hemNum},clbar_map)
loc_view(view{hemNum}(1),view{hemNum}(2))
el_add(chanLocs(ids,:),'k',12)
set(gca,'clim',[-0.5 0.5]);  colorbar
% 
% for r = 1:3    
%     el_add(chanLocs(sCh(:,r)&objMIch,:),cols(r,:),24)
% end

fileName = [hem_str{hemNum} 'RenObjMIchAC' opts.fileName];
print(h,'-dtiff',['-r' num2str(res)],[savePath fileName])
%% false alarms

% ids = (S.mBAC>0.55).*(S.hemChanId==1) == 1;
%
% figure(1); clf; set(gcf,'position',[50 50 700 700])
% ha = tight_subplot(2,2,0.1,0.1);
%
% axes(ha(1))
% gscatter(S.mBAC(S.hemChanId==1),S.FAmBAC(S.hemChanId==1),S.ROIid(S.hemChanId==1),'rbg','.',20,'off');
% lsline; hold on; plot(xlim,[0.5 0.5],'k'); ylim([0 1])
% set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',{'new' 0.25 0.50 0.75 'old'},'fontSize',12)
% title( 'All left channels FA')
%
% axes(ha(2))
% boxplot(S.FAmBAC(S.hemChanId==1),S.ROIid(S.hemChanId==1));
% hold on; plot(xlim,[0.5 0.5],'k')
% set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',{'new' 0.25 0.50 0.75 'old'},'fontSize',12)
% set(gca,'XTick',1:3,'XTickLabel', S.ROIs)
% title( 'All left channels FA')
%
% axes(ha(3))
% gscatter(S.mBAC(ids),S.FAmBAC(ids),S.ROIid(ids),'rbg','.',20,'off'); ;
% lsline; hold on; plot(xlim,[0.5 0.5],'k') ; ylim([0 1])
% set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',{'new' 0.25 0.50 0.75 'old'},'fontSize',12)
% title( 'Channels with ACC > 0.55')
%
% axes(ha(4))
% boxplot(S.FAmBAC(ids),S.ROIid(ids));
% hold on; plot(xlim,[0.5 0.5],'k')
% set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',{'new' 0.25 0.50 0.75 'old'},'fontSize',12)
% set(gca,'XTick',1:3,'XTickLabel', S.ROIs)
% title( 'Channels with ACC > 0.55')
%
%
% %% misses
%
% ids = (S.mBAC>0.55).*(S.hemChanId==1) == 1;
%
% figure(2); clf; set(gcf,'position',[50 50 700 700])
% ha = tight_subplot(2,2,0.1,0.1);
%
% axes(ha(1))
% gscatter(S.mBAC(S.hemChanId==1),S.MISSmBAC(S.hemChanId==1),S.ROIid(S.hemChanId==1),'rbg','.',20,'off');
% lsline; hold on; plot(xlim,[0.5 0.5],'k'); ylim([0 1])
% set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',{'new' 0.25 0.50 0.75 'old'},'fontSize',12)
% title( 'All left channels Misses')
%
% axes(ha(2))
% boxplot(S.MISSmBAC(S.hemChanId==1),S.ROIid(S.hemChanId==1));
% hold on; plot(xlim,[0.5 0.5],'k')
% set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',{'new' 0.25 0.50 0.75 'old'},'fontSize',12)
% set(gca,'XTick',1:3,'XTickLabel', S.ROIs)
% title( 'All left channels Misses')
%
% axes(ha(3))
% gscatter(S.mBAC(ids),S.MISSmBAC(ids),S.ROIid(ids),'rbg','.',20,'off');
% lsline; hold on; plot(xlim,[0.5 0.5],'k') ; ylim([0 1])
% set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',{'new' 0.25 0.50 0.75 'old'},'fontSize',12)
% title( 'Channels with ACC > 0.55')
%
% axes(ha(4))
% boxplot(S.MISSmBAC(ids),S.ROIid(ids));
% hold on; plot(xlim,[0.5 0.5],'k')
% set(gca,'YTick',[0 0.25 0.5 0.75 1],'YTickLabel',{'new' 0.25 0.50 0.75 'old'},'fontSize',12)
% set(gca,'XTick',1:3,'XTickLabel', S.ROIs)
% title( 'Channels with ACC > 0.55')

