

function [f1 f2 f3] = plotClusters(data,out,chans,X)

% a bit hard-coded right now, need to clean up this code. Nov 25, 2013

nDC    = out.nDC;
CDB    = out.CDB;

cL1col = [0.6  0.65 0.1];
cL2col = [0.1 0.65 0.6];

gp1col = [0.9 0.2 0.2];
gp2col = [0.1 0.5 0.8];

%% scatter plot of channel distances to clusters (normalized)

f1 = figure(1); clf; hold on;
set(gcf,'PaperPositionMode','auto','position',[100 100 600 600])
% plot limits
xlim([0 1]); ylim([0 1])

verts = [0 0;
    1 0;
    0 1;
    1 1;];
faces = [1 2 4; 1 3 4];

p=patch('faces',faces,'vertices', verts, 'edgecolor','none');
set(p,'facecolor','interp','facevertexcdata',[1 1 1; cL1col; cL2col; 1 1 1],'CDataMapping','direct')

h1 = scatter(nDC(data.ROIid(chans)==1,1),nDC(data.ROIid(chans)==1,2));
set(h1,'markeredgeColor',[0 0 0],'markerfacecolor',gp1col, 'sizeData',100, 'marker','o')
h2 = scatter(nDC(data.ROIid(chans)==2,1),nDC(data.ROIid(chans)==2,2));
set(h2,'markeredgeColor',[0 0 0],'markerfacecolor',gp2col,'sizeData',100, 'marker','d')

% reference line
h3 = refline(1,0);
set(h3,'linewidth',2,'linestyle','--','color','k')
set(gca, 'linewidth',4,'xtick',0:0.2:1,'ytick',0:0.2:1,'fontsize',14)

%% rendering of the clusters

f2 = figure(2); clf;
set(f2,'Position',[200 200 800 800]);
tight_subplot(1,1,0.001,0.001,0.001);
temp = load('../Results/ERP_Data/group/allERPsGroupstimLocksubAmpnonLPCleasL1TvalCh10.mat');
chanLocs    =  temp.data.MNILocs;
cortex{1}   =  temp.data.lMNIcortex;
cortex{2}   =  temp.data.rMNIcortex;
view{1}     = [310,30];
view{2}     = [50,30];

cols    = [ cL2col ; 0.99 0.99 0.99; cL1col];
chanNums = find(chans);
% unbiased colormap
if 0
    nLevels = 250;
    CDBrange=linspace(-1/sqrt(2),1/sqrt(2),2*nLevels);
    
    cm      = [ linspace(cols(1,1),cols(2,1),nLevels)' linspace(cols(1,2),cols(2,2),nLevels)' linspace(cols(1,3),cols(2,3),nLevels)' ;
        linspace(cols(2,1),cols(3,1),nLevels)' linspace(cols(2,2),cols(3,2),nLevels)' linspace(cols(2,3),cols(3,3),nLevels)' ];
    
    [~,color_ids]=histc(CDB(:,1),CDBrange);
else
    [sCDB,sIdx] = sort(CDB(:,1));
    nCL1 = sum(sCDB>=0);
    nCL2 = sum(sCDB<0);
    
    cm      = [ linspace(cols(1,1),cols(2,1),nCL2)' linspace(cols(1,2),cols(2,2),nCL2)' linspace(cols(1,3),cols(2,3),nCL2)' ;
                linspace(cols(2,1),cols(3,1),nCL1)' linspace(cols(2,2),cols(3,2),nCL1)' linspace(cols(2,3),cols(3,3),nCL1)' ];
    
    color_ids = 1:numel(sIdx);
    chanNums  = chanNums(sIdx);
end

ctmr_gauss_plot(gca,cortex{1},[0 0 0],0,'l');
el_add(chanLocs(chans,:),[0 0 0],25);

for i = 1:numel(chanNums)
    el_color    = cm(color_ids(i),:);
    el_add(chanLocs(chanNums(i),:),el_color,20);
end
loc_view(view{1}(1),view{1}(2))

%% time courses
f3=figure(3); clf; hold on;
set(f3,'position',[200 200,500,300],'PaperPositionMode','auto')
Y = cell(2,1);
Y{1} = X(out.index==1,:);
Y{2} = X(out.index==2,:);
plotNTraces(Y,data.trialTime,'yl');

