% additional analysis that loads stim and RT lock level clusters to
% understand the relationship between these.
inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';

cd ~/Documents/ECOG/scripts/
dataPath= '../Results/Spectral_Data/group/';
pre     = 'allERSPshgamGroup';
post    = 'LocksublogPowernonLPCleasL1TvalCh10.mat';

clusterSet1 = load([dataPath 'clusters/K2Clusters' pre 'stim' post]);
clusterSet2 = load([dataPath 'clusters/K2Clusters' pre 'RT' post]);

data1       = load([dataPath pre 'stim' post]);
data2       = load([dataPath pre 'RT' post]);

% unions for origional clusters
UorigCl = cell(2,1);
for ii =1:2
    x1 = find(clusterSet1.out.index==ii);
    x2 = find(clusterSet2.out.index==ii);
    
    UorigCl{ii} = union(x1,x2);
end


% unions of sub clusters
UsubCl = cell(3,1);
for ii =1:3
    x1 = clusterSet1.out.subCLChans{ii};
    x2 = clusterSet2.out.subCLChans{ii};
    
    UsubCl{ii} = union(x1,x2);
end

% do clusters union overlap ??
intersect(UsubCl{1},UsubCl{2})

%%
% cluster union for stims
X       = cell(2,1);
X{1}    = data1.data.ZStat(UsubCl{1},:);
X{2}    = data1.data.ZStat(UsubCl{2},:);

figure();clf; hold on;
set(gcf,'position',[200 200,500,300],'PaperPositionMode','auto')
plotNTraces(X,data1.data.trialTime,'yl','loess',0.15);

cPath = pwd;
savePath = '/Users/alexg8/Google Drive/Research/ECoG Manuscript/ECoG Manuscript Figures/individualPlotsPDFs/stimHGPcluster/';
for jj=1:2
    X       = cell(2,1);
    X{1} = data1.data.mHits(UsubCl{jj},:);
    X{2} = data1.data.mCRs (UsubCl{jj},:);
    
    figure();clf; hold on;
    set(gcf,'position',[200 200,500,300],'PaperPositionMode','auto');
    plotNTraces(X,data1.data.trialTime,'oc','loess',0.15)
    
    
    cd(savePath)
    addpath(cPath)
    addpath([cPath '/Plotting/'])

    filename = ['stimHGPmergedSub-Clusters' num2str(jj)];
    plot2svg([filename '.svg'],gcf)
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    cd(cPath)
end

%%
% cluster union for RTs
X       = cell(2,1);
X{1}    = data2.data.ZStat(UsubCl{1},:);
X{2}    = data2.data.ZStat(UsubCl{2},:);

figure();clf; hold on;
set(gcf,'position',[200 200,500,300],'PaperPositionMode','auto')
plotNTraces(X,data2.data.trialTime,'yl','loess',0.15);

savePath = '/Users/alexg8/Google Drive/Research/ECoG Manuscript/ECoG Manuscript Figures/individualPlotsPDFs/rtHGPcluster/';
for jj=1:2
    X       = cell(2,1);
    X{1} = data2.data.mHits(UsubCl{jj},:);
    X{2} = data2.data.mCRs (UsubCl{jj},:);
    
    figure();clf; hold on;
    set(gcf,'position',[200 200,500,300],'PaperPositionMode','auto');
    plotNTraces(X,data2.data.trialTime,'oc','loess',0.15)
    set(gca,'yaxis','right')
     
    cd(savePath)
    addpath(cPath)
    addpath([cPath '/Plotting/'])
    
    filename = ['rtHGPmergedSub-Clusters' num2str(jj)];
    plot2svg([filename '.svg'],gcf)
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    cd(cPath)
end

%% render union
f = figure; clf;
set(f,'Position',[200 200 800 800]);
tight_subplot(1,1,0.001,0.001,0.001);
temp = load('../Results/ERP_Data/group/allERPsGroupstimLocksubAmpnonLPCleasL1TvalCh10.mat');
chanLocs    =  temp.data.MNILocs;
cortex{1}   =  temp.data.lMNIcortex;
cortex{2}   =  temp.data.rMNIcortex;
view{1}     = [310,30];
view{2}     = [50,30];
IPSch = (data1.data.hemChanId==1).*data1.data.ROIid==1;
SPLch = (data1.data.hemChanId==1).*data1.data.ROIid==2;
chans = find(IPSch +SPLch);

ctmr_gauss_plot(gca,cortex{1},[0 0 0],0,'l');
el_add(chanLocs(chans,:),[0 0 0],25);

gpcol{1} = [0.6  0.65 0.1];
gpcol{2} = [0.1 0.65 0.6];

for ii = 1:2
    el_color    = gpcol{ii};
    el_add(chanLocs(UsubCl{ii},:),el_color,20);
end
loc_view(view{1}(1),view{1}(2))

savePath = '/Users/alexg8/Google Drive/Research/ECoG Manuscript/ECoG Manuscript Figures/individualPlotsPDFs/';
filename = [savePath 'HGPmergedSub-Clusters'];
print(f,'-dtiff',['-r400'],filename)


