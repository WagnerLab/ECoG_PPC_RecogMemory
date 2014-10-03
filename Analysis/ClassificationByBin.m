% channel wise analysis for temporal classification

inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';


what = 'stimChannel'


%%
opts                        = [];
opts.reference              = 'nonLPCleasL1TvalCh';
opts.dataType               = 'power';
opts.bands                  = {'hgam'};
opts.toolboxNum             = 1;
opts.timeType               = 'Bin';
opts.timeFeatures           = 'window';
opts.extStr                 = 'liblinearS0';


%% stimulus channel
% Options
switch what
    case 'stimChannel'
        opts.lockType               = 'stim';
        opts.channelGroupingType    = 'channel';
        opts.timeLims               = [0 1];
        opts.timeStr                = '0msTo1000ms';
        
        % load data
        dataPath = ['~/Documents/ECOG/Results/Classification/group/' opts.dataType ...
            '/' opts.channelGroupingType '/'];
        fileName = ['SumallSubjsClassXVB' opts.lockType 'Lock' opts.timeStr opts.dataType cell2mat(opts.bands) '_tF' opts.timeFeatures '_tT' ...
            opts.timeType '_gT' opts.channelGroupingType '_Solver' opts.extStr];
        load([dataPath fileName])
        
        PlotPath = ['~/Documents/ECOG/Results/Plots/Classification/channel/power/'];
        PlotPath = [PlotPath opts.lockType '/'];
        
        % get appropiate channel groupings for left Subjects
        IPSch   = (S.hemChanId==1)&S.ROIid==1;
        SPLch   = (S.hemChanId==1)&S.ROIid==2;
        AGch    = (S.hemChanId==1)&S.ROIid==3;
        
        % data structure
        X       = [];
        X{1}    = S.mBAC(IPSch,:);
        X{2}    = S.mBAC(SPLch,:);
        %X{3}    = S.mBAC(AGch,:);
        
        t       = mean(S.Bins,2);
        
        % plot accuracy for channels across time divided by region
        h       = plotNTraces(X,t,'rbg');
        ylim([0.48 0.60])
        hold on;
        plot(xlim,[0.5 0.5],'--k','linewidth',2)
        set(gca,'ytick',[0.5 0.55 0.60])
        set(gca,'XtickLabel',{'stim','','0.4','','0.8',''})
        hold off;
        %xlabel(' Time (s) ')
        %ylabel(' ACC ')
        
        cPath = pwd;
        cd(PlotPath)
        addpath(cPath)
        addpath([cPath '/Plotting/'])
        
        filename = [opts.lockType 'ACC_ChannelsByROI'];
        plot2svg([filename '.svg'],gcf)
        eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
        eval(['!rm ' filename '.svg'])
        cd(cPath)
        
        printStats(S,opts,'mBAC',0.5)
        
    case 'RTchannel'
        
        % Options        
        opts.lockType               = 'RT';
        opts.channelGroupingType    = 'channel';
        opts.timeLims               = [-0.8 0.2];
        opts.timeStr                = 'n800msTo200ms';
        
        % load data
        dataPath = ['~/Documents/ECOG/Results/Classification/group/' opts.dataType ...
            '/' opts.channelGroupingType '/'];
        fileName = ['SumallSubjsClassXVB' opts.lockType 'Lock' opts.timeStr opts.dataType cell2mat(opts.bands) '_tF' opts.timeFeatures '_tT' ...
            opts.timeType '_gT' opts.channelGroupingType '_Solver' opts.extStr];
        load([dataPath fileName])
        
        PlotPath = ['~/Documents/ECOG/Results/Plots/Classification/channel/power/'];
        PlotPath = [PlotPath opts.lockType '/'];
        
        % get appropiate channel groupings for left Subjects
        IPSch   = (S.hemChanId==1)&S.ROIid==1;
        SPLch   = (S.hemChanId==1)&S.ROIid==2;
        AGch    = (S.hemChanId==1)&S.ROIid==3;
        
        % data structure
        X       = [];
        X{1}    = S.mBAC(IPSch,:);
        X{2}    = S.mBAC(SPLch,:);
        %X{3}    = S.mBAC(AGch,:);
        
        t       = mean(S.Bins,2);
        % plot accuracy for channels across time divided by region
        h       = plotNTraces(X,t,'rbg');
        ylim([0.48 0.60])
        hold on;
        plot(xlim,[0.5 0.5],'--k','linewidth',2)
        set(gca,'ytick',[0.5 0.55 0.60])
        set(gca,'YAXisLocation','right')
        set(gca,'XtickLabel',{'-0.8','','-0.4','','resp',''})
        
        cPath = pwd;
        cd(PlotPath)
        addpath(cPath)
        addpath([cPath '/Plotting/'])
        
        filename = [opts.lockType 'ACC_ChannelsByROI'];
        plot2svg([filename '.svg'],gcf)
        eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
        eval(['!rm ' filename '.svg'])
        cd(cPath)
        
        printStats(S,opts,'mBAC',0.5)
        
    case 'stimROI'
        %%
         % Options        
        opts.lockType               = 'stim';
        opts.channelGroupingType    = 'ROI';
        opts.timeLims               = [0 1];
        opts.timeStr                = '0msTo1000ms';
        
        % load data
        dataPath = ['~/Documents/ECOG/Results/Classification/group/' opts.dataType ...
            '/' opts.channelGroupingType '/'];
        fileName = ['allSubjsClassXVB' opts.lockType 'Lock' opts.timeStr opts.dataType cell2mat(opts.bands) '_tF' opts.timeFeatures '_tT' ...
            opts.timeType '_gT' opts.channelGroupingType '_Solver' opts.extStr];
        load([dataPath fileName])
        
        PlotPath = ['~/Documents/ECOG/Results/Plots/Classification/ROI/power/'];
        PlotPath = [PlotPath opts.lockType '/'];
        
        % data structure
        X       = [];        
        X{1}    = squeeze(nanmean(S.perf(1:4,1,:,:),4)); 
        X{2}    = squeeze(nanmean(S.perf(1:4,2,:,:),4));
        
        
        %X{3}    = S.mBAC(AGch,:);
        t       = mean(S.Bins,2);
        % plot accuracy for channels across time divided by region
        h       = plotNTraces(X,t,'rbg');
        ylim([0.45 0.70])
        hold on;
        plot(xlim,[0.5 0.5],'--k','linewidth',2)
        set(gca,'ytick',[0.5 0.6 0.7])
        set(gca,'XtickLabel',{'stim','','0.4','','0.8',''})
        hold off;
        %xlabel(' Time (s) ')
        %ylabel(' ACC ')
        
        cPath = pwd;
        cd(PlotPath)
        addpath(cPath)
        addpath([cPath '/Plotting/'])
        
        filename = [opts.lockType 'ACC_ROI_Subjs'];
        plot2svg([filename '.svg'],gcf)
        eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
        eval(['!rm ' filename '.svg'])
        cd(cPath)
        
    case 'RTROI'
        %%
        % Options        
        opts.lockType               = 'RT';
        opts.channelGroupingType    = 'ROI';
        opts.timeLims               = [-0.8 0.2];
        opts.timeStr                = 'n800msTo200ms';
        
        % load data
        dataPath = ['~/Documents/ECOG/Results/Classification/group/' opts.dataType ...
            '/' opts.channelGroupingType '/'];
        fileName = ['allSubjsClassXVB' opts.lockType 'Lock' opts.timeStr opts.dataType cell2mat(opts.bands) '_tF' opts.timeFeatures '_tT' ...
            opts.timeType '_gT' opts.channelGroupingType '_Solver' opts.extStr];
        load([dataPath fileName])
        
        PlotPath = ['~/Documents/ECOG/Results/Plots/Classification/ROI/power/'];
        PlotPath = [PlotPath opts.lockType '/'];
        
        % data structure
        X       = [];        
        X{1}    = squeeze(nanmean(S.perf(1:4,1,:,:),4)); 
        X{2}    = squeeze(nanmean(S.perf(1:4,2,:,:),4));
        
        
        %X{3}    = S.mBAC(AGch,:);
        t       = mean(S.Bins,2);
        % plot accuracy for channels across time divided by region
        h       = plotNTraces(X,t,'rbg');
        ylim([0.45 0.70])
        hold on;
        plot(xlim,[0.5 0.5],'--k','linewidth',2)
        set(gca,'YAXisLocation','right')
        set(gca,'XtickLabel',{'-0.8','','-0.4','','resp',''})
        set(gca,'ytick',[0.5 0.6 0.7])
        
        hold off;
        %xlabel(' Time (s) ')
        %ylabel(' ACC ')
        
        cPath = pwd;
        cd(PlotPath)
        addpath(cPath)
        addpath([cPath '/Plotting/'])
        
        filename = [opts.lockType 'ACC_ROI_Subjs'];
        plot2svg([filename '.svg'],gcf)
        eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
        eval(['!rm ' filename '.svg'])
        cd(cPath)
        
end
