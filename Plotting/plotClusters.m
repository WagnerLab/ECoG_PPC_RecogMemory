

function [f1 f2] = plotClusters(data,nDC,CDB,chans)

cL1col = [0.9 0.95 0.1];
cL2col = [0.1 0.95 0.8];

gp1col = [0.9 0.2 0.2];
gp2col = [0.1 0.5 0.8];

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
set(gca, 'linewidth',2,'xtick',0:0.2:1,'ytick',0:0.2:1,'fontsize',14)

%%

f2 = figure(2); clf;
set(f2,'Position',[200 200 800 800]);
tight_subplot(1,1,0.001,0.001,0.001);
temp = load('../Results/ERP_Data/group/allERPsGroupstimLocksubAmpnonLPCleasL1TvalCh10.mat');
chanLocs    =  temp.data.MNILocs;
cortex{1}   =  temp.data.lMNIcortex;
cortex{2}   =  temp.data.rMNIcortex;
view{1}     = [310,30];
view{2}     = [50,30];

cols  = [ cL2col ; 1 1 1; cL1col];
nL      = size(CDB,1); nL2 = ceil(nL/2);
cm      = [ linspace(cols(1,1),cols(2,1),nL2)' linspace(cols(1,2),cols(2,2),nL2)' linspace(cols(1,3),cols(2,3),nL2)' ;
    linspace(cols(2,1),cols(3,1),nL2)' linspace(cols(2,2),cols(3,2),nL2)' linspace(cols(2,3),cols(3,3),nL2)' ];

ctmr_gauss_plot(gca,cortex{1},[0 0 0],0,'l');

[~,Sidx]=sort(CDB(:,2));
chanNums = find(chans);
el_add(chanLocs(chans,:),[0 0 0],30);
for i = 1:numel(chanNums)    
    color_id    = find(Sidx==i);
    el_color    = cm(color_id,:);
    el_add(chanLocs(chanNums(i),:),el_color,25);
end
loc_view(view{1}(1),view{1}(2))

