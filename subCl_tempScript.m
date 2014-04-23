cd ~/Documents/ECOG/scripts/
dataPath= '../Results/Spectral_Data/group/';
pre     = 'allERSPshgamGroup';
post    = 'LocksublogPowernonLPCleasL1TvalCh10.mat';

load([dataPath 'clusters/K2Clusters' pre 'stim' post]);
clusterSet1 = out;
load([dataPath 'clusters/K2Clusters' pre 'RT' post]);
clusterSet2 = out;

load([dataPath pre 'stim' post]);
data1       = data;
load([dataPath pre 'RT' post]);
data2       = data;



%%
for jj=1:3
    ch = clusterSet1.subCLChans{jj};
    X    = cell(2,1);
    X{1} = data1.BincHits(ch,:);
    X{2} = data1.BincCRs (ch,:);
    
    figure();clf; hold on;
    set(gcf,'position',[200 200,500,300],'PaperPositionMode','auto');
    plotNTraces(X,mean(data1.Bins,2),'oc','loess',0.15)
    
end

%%
cPath = pwd;
savePath = '/Users/alexg8/Google Drive/Research/ECoG Manuscript/ECoG Manuscript Figures/individualPlotsPDFs/stimHGPcluster/';
for jj=1:2
    ch = UsubCl{jj};
    X    = cell(2,1);
    X{1} = data1.BincHits(ch,:);
    X{2} = data1.BincCRs (ch,:);
    
    figure();clf; hold on;
    set(gcf,'position',[200 200,500,300],'PaperPositionMode','auto');
    plotNTraces(X,mean(data1.Bins,2),'oc','loess',0.15)
    
    cd(savePath)
    addpath(cPath)
    addpath([cPath '/Plotting/'])

    filename = ['stimHGP-RTcorrmergedSub-Clusters' num2str(jj)];
    plot2svg([filename '.svg'],gcf)
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    cd(cPath)
end

%%
for jj=1:3
    ch = clusterSet2.subCLChans{jj};
    X    = cell(2,1);
    X{1} = data2.BincHits(ch,:);
    X{2} = data2.BincCRs (ch,:);
    
    figure();clf; hold on;
    set(gcf,'position',[200 200,500,300],'PaperPositionMode','auto');
    plotNTraces(X,mean(data2.Bins,2),'oc','loess',0.15)
    
end


%%
savePath = '/Users/alexg8/Google Drive/Research/ECoG Manuscript/ECoG Manuscript Figures/individualPlotsPDFs/rtHGPcluster/';
for jj=1:2
    ch =  UsubCl{jj};
    X    = cell(2,1);
    X{1} = data2.BincHits(ch,:);
    X{2} = data2.BincCRs (ch,:);
    
    figure();clf; hold on;
    set(gcf,'position',[200 200,500,300],'PaperPositionMode','auto');
    plotNTraces(X,mean(data2.Bins,2),'oc','loess',0.15)
    set(gca,'yaxis','right')
     
    cd(savePath)
    addpath(cPath)
    addpath([cPath '/Plotting/'])
    
    filename = ['rtHGP-RTmergedSub-Clusters' num2str(jj)];
    plot2svg([filename '.svg'],gcf)
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    cd(cPath)
    
end
