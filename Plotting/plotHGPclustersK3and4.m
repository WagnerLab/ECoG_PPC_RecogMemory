function plotHGPclustersK3and4(ClusterSet,opts)

inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';
SupPlotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ', ...
    'Manuscript Figures/supplement/channelRenderings/'];

fontSize  = 16;

ClCol{1} = [0.9  0.95 0.2];
ClCol{2} = [0.2 0.95 0.6];
ClCol{3} = [0.6 0.1 0.6];
ClCol{4} = [0.8 0.8 0.8];
ClCol{5} = [0 0 0];

%% render frame
f = figure(1); clf;
figW = 600;
figH = 600;
set(gcf,'position',[-1000 200,figW,figH],'PaperPositionMode','auto','color','w')


lMargin = 0.1;
bMargin = 0.06;

subAxH      = 0.42;
subAxW      = 0.42;
betweenColSpace = 0.01;
betweenRowSpace  = 0.05;

% a
axes('position', [0.05 0.95 0.2 0.05 ])
text(0.05,0.45,' a ','fontsize',28)
set(gca, 'visible', 'off')

% b
axes('position', [0.52 0.95 0.2 0.05 ])
text(0.05,0.45,' b ','fontsize',28)
set(gca, 'visible', 'off')

% c
axes('position', [0.05 0.48 0.2 0.05 ])
text(0.05,0.45,' c ','fontsize',28)
set(gca, 'visible', 'off')

% d
axes('position', [0.52 0.48 0.2 0.05 ])
text(0.05,0.45,' d ','fontsize',28)
set(gca, 'visible', 'off')

% stim & RT labels
axes('position', [0.31 0.05 0.2 0.05])
text(0.05,0.45,' stim ','fontsize',20, 'horizontalAlignment','center')
set(gca, 'visible', 'off')

axes('position', [0.74 0.05 0.2 0.05])
text(0.05,0.45,' resp ','fontsize',20,'horizontalAlignment','center')
set(gca, 'visible', 'off')

% K=3,4 
axes('position', [0 0.74 0.1 0.05])
text(0.,0.45,' K=3 ','fontsize',20)
set(gca, 'visible', 'off')

axes('position', [0 0.27 0.1 0.05])
text(0,0.45,' K=4 ','fontsize',20)
set(gca, 'visible', 'off')

% legend
axes('position',[0.88 0.4 0.03 0.2]); hold on;
plot(0.4,4,'o','color','k','markersize',15,'markerfacecolor',ClCol{1})
plot(0.4,3,'o','color','k','markersize',15,'markerfacecolor',ClCol{2})
plot(0.4,2,'o','color','k','markersize',15,'markerfacecolor',ClCol{3})
plot(0.4,1,'o','color','k','markersize',15,'markerfacecolor',ClCol{4})

xlim([0 0.8]); ylim([0.5 4.5])
text(0.9,4,'CL 1','fontsize',fontSize)
text(0.9,3,'CL 2','fontsize',fontSize)
text(0.9,2,'CL 3','fontsize',fontSize)
text(0.9,1,'CL 4','fontsize',fontSize)
set(gca,'visible','off')

cPath = pwd;
cd(SupPlotPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

filename = 'K3K4Clusters';
plot2svg([filename '.svg'],gcf)
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
cd(cPath)

%% renderings

load('../Results/Spectral_Data/group/allERSPshgamGroupstimLocksublogPowernonLPCleasL1TvalCh10.mat');
view      = [310,30];

chanLocs    =  data.MNILocs;
% fix for bad channel location for subject 1
chanLocs(13,:)    = 1.1*chanLocs(13,:);
cortex   =  data.lMNIcortex;

f = figure(2); clf;
figW = 600;
figH = 600;
set(gcf,'position',[-1000 200,figW,figH],'PaperPositionMode','auto','color','w')

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

chanIDs     = find(ClusterSet{1}.chans);
Ks          = [3 3 4 4];

ClColorId   = cell(4,1);
ClColorId{1}= [1 2 3];
ClColorId{2}= [1 3 2];
ClColorId{3}= [4 3 1 2];
ClColorId{4}= [2 3 1 4];

for ii = 1:4
    axes(ha(ii))
    ctmr_gauss_plot(gca,cortex,[0 0 0],0,'l')
    loc_view(view(1),view(2))
    set(gca, 'CameraViewAngle',8)
    
    CLId = ClusterSet{ii}.index;
    for jj = 1:Ks(ii)
        el_add(chanLocs(chanIDs(CLId==jj),:),'k',30);
        el_add(chanLocs(chanIDs(CLId==jj),:),ClCol{ClColorId{ii}(jj)},25);
    end
    
end

print(gcf,'-dtiff',['-r' num2str(opts.resolution)],[SupPlotPath filename])
