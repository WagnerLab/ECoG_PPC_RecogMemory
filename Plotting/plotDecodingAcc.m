function plotDecodingAcc(data,opts)

colors      = [];
colors.c    = [0.1 0.8 0.9];
colors.cl   = [0.2 0.9 1];
colors.o    = [0.9 0.5 0.1];
colors.ol   = [1 0.65 0.2];
colors.IPS  = [0.9 0.2 0.2];
colors.SPL  = [0.1 0.5 0.8];
colors.AG   = [0.2 0.6 0.3];
colors.Bdots= ones(1,3)*0.4;
nBoot = data.classificationParams.nBoots;

%% load data to obtain cortex and channel locations
temp = load('../Results/ERP_Data/group/allERPsGroupstimLocksubAmpnonLPCleasL1TvalCh10.mat');
chanLocs    =  temp.data.MNILocs;
cortex{1}   =  temp.data.lMNIcortex;
cortex{2}   =  temp.data.rMNIcortex;
hem_str     = {'l','r'};
view{1}     = [310,30];
view{2}     = [50,30];

temp        = load ('loc_colormap3.mat');
clmap       = temp.cm;

mainPath    = '../Results/Plots/Classification/channel/';

%%
Y       = data.(opts.scoreType);
Yp      = data.pBAC;
Ysd     = data.sdBAC;
threshold = 1e-3;
switch opts.timeFeatures
    case 'trial'
        for hem = 1
            %% scatter plot by ROI
            
            if opts.accPlots
                ROIs = [1 2]; nROIs = numel(ROIs);
                figure(); clf;hold on;
                set(gcf,'paperpositionmode','auto','position',[100 100 opts.accPlotsOpts.aspectRatio])                
                for r = ROIs
                    chans   = data.ROIid.*(data.hemChanId == hem ) == r;
                    nChans  = sum(chans);
                    
                    %yMe = median(y);
                    yM  = nanmean(Y(chans));
                    yS  = nanstd(Y(chans))/sqrt(nChans-1);
                    
                    %scatter(r+randn(nChans,1)*0.03,Y(chans),'k','filled')
                    %plot([r-0.2 r+0.2],[yM yM],'r','linewidth',5)
                    %handle=bar(r,yM,1);
                    %set(handle,'color',colors.(data.ROIs{r}));
                    bar(r,yM,0.8,'FaceColor',colors.(data.ROIs{r}),'edgeColor', 'none', 'basevalue', 0.5,'ShowBaseLine','off')
                    plot([r r],[yM-yS  yM+yS],'color',[0 0 0],'linewidth',4)
                    
                end
                plot([0 nROIs] + 0.5,[opts.baseLineY opts.baseLineY],'--',...
                    'color',[0 0 0],'linewidth',2)
                set(gca,'LineWidth',2,'FontSize',14,'XTick',1:nROIs,'XTickLabel',data.ROIs)
                set(gca,'ytick',[0.5:0.05:0.9])                
                ylim(opts.accPlotsOpts.yLimits)
                xlim([0 nROIs]+0.5)
                
                if opts.accPlotsOpts.indPoints;
                    for r = 1:2
                        chans   = data.ROIid.*(data.hemChanId == hem ) == r;
                        nChans  = sum(chans);
                        y  = Y(chans);
                        ysd= Ysd(chans)/sqrt(nBoot-1);
                        for ch = 1:nChans
                            xLoc = unifrnd(r-0.15,r+0.15);
                            handle = scatter(xLoc, y(ch),'filled');
                            set(handle,'CData',colors.Bdots)
                            plot([xLoc xLoc], [-ysd(ch) ysd(ch)]+y(ch),'color',colors.Bdots)
                        end
                    end
                end
                savePath    = [mainPath opts.dataType '/' opts.lockType '/'];
                if ~exist(savePath,'dir'), mkdir(savePath), end;
                
                fileName = [hem_str{hem} 'ROIchan_ACC' opts.scoreType opts.fileName];
                print(gcf,'-depsc2',[savePath fileName])
            end
            %% RT - logit correlations
            
            if opts.RTcorrPlots
                
                % RT - Logit correlation
                Y2 = data.RTsLogitCorr;
                figure;clf;hold on;
                plot([0.5 3.5],[0 0],'--','color',[0.6 0.6 0.6],'linewidth',2)
                set(gca,'LineWidth',2,'FontSize',14,'XTick',1:3,'XTickLabel',data.ROIs)
                for r = 1:3
                    chans   = data.ROIid.*(data.hemChanId == hem ) == r;
                    nChans  = sum(chans);
                    
                    y   = Y2(chans);
                    yM  = nanmean(y);
                    yS  = nanstd(y)/sqrt(nChans-1);
                    
                    scatter(r+randn(nChans,1)*0.03,y,'k','filled')
                    plot([r-0.2 r+0.2],[yM yM],'r','linewidth',5)
                    plot([r r],[yM-yS  yM+yS],'color',[0.7 0.3 0.3],'linewidth',4)
                    
                end
                savePath    = [mainPath opts.dataType '/' opts.lockType '/'];
                if ~exist(savePath,'dir'), mkdir(savePath), end;
                fileName = [hem_str{hem} 'ROIchan_RTLogitCorr' opts.fileName];
                print(gcf,'-depsc2',[savePath fileName])
                
                % RT - Logit correlation by condition
                Y1 = data.RTsLogitCorrH; Y2 = data.RTsLogitCorrCRs;
                figure;clf;hold on;
                plot([0.5 3.5],[0 0],'--','color',[0.6 0.6 0.6],'linewidth',2)
                set(gca,'LineWidth',2,'FontSize',14,'XTick',1:3,'XTickLabel',data.ROIs)
                for r = 1:3
                    chans   = data.ROIid.*(data.hemChanId == hem ) == r;
                    nChans  = sum(chans);
                    
                    y1   = Y1(chans);
                    yM1  = nanmean(y1);
                    yS1  = nanstd(y1)/sqrt(nChans-1);
                    
                    y2   = Y2(chans);
                    yM2  = nanmean(y2);
                    yS2  = nanstd(y2)/sqrt(nChans-1);
                    
                    h1=scatter(r-0.2 + randn(nChans,1)*0.02, y1,'filled');set(h1,'CData',colors.ol)
                    h1=scatter(r+0.2 + randn(nChans,1)*0.02, y2,'filled');set(h1,'CData',colors.cl)
                    
                    plot([r-0.4 r],[yM1 yM1],'color',colors.o,'linewidth',5)
                    plot([r-0.2 r-0.2],[yM1-yS1  yM1+yS1],'color','k','linewidth',4)
                    
                    plot([r r+0.4],[yM2 yM2],'color',colors.c,'linewidth',5)
                    plot([r+0.2 r+0.2],[yM2-yS2  yM2+yS2],'color','k','linewidth',4)
                    
                end
                savePath    = [mainPath opts.dataType '/' opts.lockType '/'];
                if ~exist(savePath,'dir'), mkdir(savePath), end;
                fileName = [hem_str{hem} 'ROIchan_ROIchan_RTLogitCorrByCond' opts.scoreType opts.fileName];
                print(gcf,'-depsc2',[savePath fileName])
                
                
                % RT Logit Correlation by Accuracy
                chans   = data.hemChanId == hem ;
                x   = data.mBAC(chans);
                y   = data.RTsLogitCorr(chans);
                
                figure(); clf; hold on;
                scatter(x,y,'k','filled')
                h1=lsline; set(h1,'LineWidth',2,'Color',[1 0 0]);
                scatter(x,y,'k','filled')
                set(gca,'FontSize',12,'LineWidth',2)
                
                fileName = [hem_str{hem} 'RT-Logit_ACC_Corr' opts.fileName];
                print(gcf,'-depsc2',[savePath fileName])
                
                % RT Logit Correlation by Accuracy; by condition
                figure(); clf; hold on;
                
                x   = data.mH_AC(chans);
                y   = data.RTsLogitCorrH(chans);
                p1  = polyfit(x,y,1);
                h1  = scatter(x,y,'filled'); set(h1,'CData',colors.ol)
                
                x   = data.mCRs_AC(chans);
                y   = -data.RTsLogitCorrCRs(chans);
                p2  = polyfit(x,y,1);
                h1=scatter(x,y,'filled'); set(h1,'CData',colors.cl)
                
                h1  = refline(p1); set(h1,'LineWidth',3,'Color',colors.o);
                h2  = refline(p2); set(h2,'LineWidth',3,'Color',colors.c);
                
                set(gca,'FontSize',12,'LineWidth',2)
                fileName = [hem_str{hem} 'RT-Logit_ACC_CorrByCond' opts.fileName];
                print(gcf,'-depsc2',[savePath fileName])
                
                %                 % RT Logit Correlation by Accuracy; transformed
                %                 x   = data.mZBAC(chans);
                %                 y   = atanh(data.RTsLogitCorr(chans));
                %
                %                 figure(); clf; hold on;
                %                 scatter(x,y,'k','filled')
                %                 h1=lsline; set(h1,'LineWidth',2,'Color',[1 0 0]);
                %                 scatter(x,y,'k','filled')
                %                 set(gca,'FontSize',12,'LineWidth',2)
                %
                %                 fileName = [hem_str{hem} 'Z_RT-Logit_ACC_Corr' opts.fileName];
                %                 print(gcf,'-depsc2',[savePath fileName])
                
                
            end
            %xlabel(' Accuracy ','FontSize',14)
            %ylabel(' RT-Logit Correlation ','FontSize',14)
            %text(0.6,0.1,[ 'R = ' num2str(corr(x,y))],'FontSize',12)
            
            %% plot weights
            
            if opts.weigthsPlots
                X = cell(2,1);
                Y = data.chModel;
                t = mean(data.Bins,2);
                for r = 1:2
                    chans   = data.ROIid.*(data.hemChanId == hem ) == r;
                    X{r}    = Y(chans & (data.pBAC < 0.001),:);
                end
                figure(); clf;
                set(gcf,'position',[200 200,500,300],'PaperPositionMode','auto')
                
                h = plotNTraces(X,t,'rb','loess',1,'median');
                if strcmp(opts.lockType,'RT'),set(gca,'YAXisLocation','right'),end
                
                savePath    = [mainPath opts.dataType '/' opts.lockType '/'];
                if ~exist(savePath,'dir'), mkdir(savePath), end;
                fileName = [hem_str{hem} 'ROIweightsTC' opts.fileName];
                
                print(h.f,'-dtiff','-loose','-r300',[ savePath fileName]);
                set(gca,'yTickLabel',[]); set(gca,'xTickLabel',[]);
                plot2svg([savePath fileName '.svg'],h.f,'tiff')
                
            end
            
            %% rendering
            
            if opts.renderPlot
                chans   = data.hemChanId == hem ;                
                limits = opts.rendLimits-opts.baseLineY;
                opts.limitDw = limits(1);
                opts.limitUp = limits(2);
                opts.absLevel = 0.03;
                opts.renderType = 'SmoothCh';
                opts.hem        = hem_str{hem};
                
                h=figure(1);clf;
                set(h,'Position',[200 200 800 800]);
                ha = tight_subplot(1,1,0.001,0.001,0.001);
                %ctmr_gauss_plot2(gca,cortex{hem},chanLocs(chans,:),Y(chans)-0.5,hem_str{hem},clmap);
                plotSurfaceChanWeights(ha, cortex{hem}, chanLocs(chans,:), Y(chans)-0.5,opts)
                %el_add(chanLocs(chans,:),'k',10);
                loc_view(view{hem}(1),view{hem}(2))
                set(gca,'clim',limits);
                %colorbar;
                savePath    = [mainPath opts.dataType '/' opts.lockType '/'];
                fileName = [hem_str{hem} 'rendROIchan_ACC' opts.scoreType opts.renderType opts.fileName];
                print(h,'-dtiff',['-r' num2str(opts.resolution)],[savePath fileName])
            end
            
            %% stats
            
            if opts.stats
                y =[];
                for r = 1:3
                    fprintf('stats for roi %s ', data.ROIs{r})
                    chans   = data.ROIid.*(data.hemChanId == hem ) == r;
                    y{r}       = Y(chans);
                    yp{r}      = Yp(chans)*2; % converting to two sided test
                    fprintf(' \n mean = %g \n' ,mean(y{r}))
                    fprintf('number of chans with p < %g  = %g \n' , threshold ,sum(yp{r} <threshold) )
                    [~,p,~,t]=ttest(y{r},0.5,0.05)
                    
                    % hard-coded for left subjects for now.
                    fprintf('\n break down by subject \n')
                    temp = cell(5,2);
                    temp(1,:) = {'# p<0.001','total'};
                    for ss= 1:4
                        ch_s = chans&data.subjChans==ss;
                        temp(ss+1,:) = {sum(Yp(ch_s)*2 < threshold), sum(ch_s)};
                    end
                    temp
                end 
            end
        end
end