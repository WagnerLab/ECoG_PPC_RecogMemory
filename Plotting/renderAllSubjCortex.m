function renderAllSubjCortex()

% supplemental figure
% renders each brain in native and mni space

resolution = 600;
plotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ',... '
    'Manuscript Figures/supplement/channelRenderings/'];
filename = 'allSubjsChannelRenderings';

inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';
load('../Results/ERP_Data/group/allERPsGroupstimLocksubAmpnonLPCleasL1TvalCh10.mat');

view{1}      = [310,30];
view{2}      = [50,30];

hemId       = {'l','r'};

MNIchanLocs    =  data.MNIlocsSubj;
% fix for bad channel location for subject 1
MNIchanLocs{1}(13,:)    = 1.1*MNIchanLocs{1}(13,:);
MNIcortex{1}   =  data.lMNIcortex;
MNIcortex{2}   =  data.rMNIcortex;

nativeCortex    = data.cortex;
nativeChanLocs  = data.OrigLocsSubj;

subjsByhem{1} = 1:4;
subjsByhem{2} = 5:7;

% ROI channel colors
colors      = [];
colors{1}  = [0.9 0.2 0.2];
colors{2}  = [0.1 0.5 0.8];
colors{3}   = [0.2 0.6 0.3];

f = figure(1); clf;
figW = 1200;
figH = 600;
set(gcf,'position',[-1200 200,figW,figH],'PaperPositionMode','auto','color','w')

% position paratemeters
lMargin     = 0.05;
rMargin     = 0.04;
tMargin     = 0.05;
bMargin     = 0.05;

subAxH      = 0.42;
subAxW      = 0.11;
betweenSubjSpace = 0.01;
betweenRowSpace  = 0.06;

% text positions
txtXPos = [lMargin+subAxW lMargin+betweenSubjSpace+3*subAxW  ...
    lMargin+2*betweenSubjSpace+5*subAxW lMargin+3*betweenSubjSpace+7*subAxW];
txtYPos = [bMargin+subAxH+betweenRowSpace+0.05 bMargin+0.05];

% subject Ids
cnt = 1;
HEMId = {'L','R'};
for hem = 1:2
    for jj = 1:4
        if ~(hem==2 & jj==4)
            axes('position',[txtXPos(jj) txtYPos(hem) 0.05 0.1])
            text(0.05,0.45,[HEMId{hem} num2str(jj)],'fontsize',24, 'horizontalAlignment','center')
            axis off
            cnt = cnt + 1;
        end
    end
end

% set legend axes
axes('position',[0.75+subAxW/2 bMargin+subAxH/3 0.03 0.1]); hold on;
plot([0.4],[3],'o','color',colors{1},'markersize',15,'markerfacecolor',colors{1})
plot([0.4],[2],'o','color',colors{2},'markersize',15,'markerfacecolor',colors{2})
plot([0.4],[1],'o','color',colors{3},'markersize',15,'markerfacecolor',colors{3})

xlim([0 0.8]); ylim([0.5 3.5])
text(0.9,3,'IPS','fontsize',16)
text(0.9,2,'SPL','fontsize',16)
text(0.9,1,'AG ','fontsize',16)
set(gca,'visible','off')

% row labels
axes('position',[0.001 0.9 0.3 0.05]);xlim([0 1]); ylim([0 1])
text(0.05,0.45,' a. Subjects with left coverage ','fontsize',24)
set(gca,'visible','off')

axes('position',[0.001 bMargin+subAxH-0.05 0.3 0.05]);xlim([0 1]); ylim([0 1])
text(0.05,0.45,' b. Subjects with right coverage ','fontsize',24)
set(gca,'visible','off')

% save frame
cPath = pwd;
cd(plotPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

plot2svg([filename '.svg'],gcf)
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
cd(cPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

%% render
clf;
ha = tight_subplot(8,2);
% set axes for first row (left subjects)
currentXPos = lMargin;
currentYPos = bMargin+subAxH+betweenRowSpace;
for jj = [1 3 5 7]
    set(ha(jj), 'position', [currentXPos currentYPos subAxW subAxH])
    currentXPos = currentXPos+subAxW;
    set(ha(jj+1), 'position', [currentXPos currentYPos subAxW subAxH])
    currentXPos = currentXPos+subAxW+betweenSubjSpace;
end

% set axes for second row (right subjects)
currentXPos = lMargin;
currentYPos = bMargin;
for jj = [9 11 13]
    set(ha(jj), 'position', [currentXPos currentYPos subAxW subAxH])
    currentXPos = currentXPos+subAxW;
    set(ha(jj+1), 'position', [currentXPos currentYPos subAxW subAxH])
    currentXPos = currentXPos+subAxW+betweenSubjSpace;
end

set(ha(15),'visible','off')
set(ha(16),'visible','off')

for hem=1:2
    % render lefts
    for jj = subjsByhem{hem}
        
        % native space
        axes(ha(2*jj-1)); hold on;
        
        cortex  = nativeCortex{jj};
        chans   = nativeChanLocs{jj};
        roiIds  = data.ROIid(data.subjChans==jj);
        
        ctmr_gauss_plot(gca,cortex,[0 0 0],0,hemId{hem})
        loc_view(view{hem}(1),view{hem}(2))
        set(gca, 'CameraViewAngle',7)
        
        % fix for subject with bigger native space head
        if jj==7
            set(gca,'cameraViewAngle',9)
            set(gca,'position',[0.53 0.025 0.11 0.42])
        end
        
        el_add(chans,'k',20)
        for rr = 1:3
            el_add(chans(roiIds==rr,:),colors{rr},18);
        end
        
        % mni space
        axes(ha(2*jj)); hold on;
        
        cortex  = MNIcortex{hem};
        chans   = MNIchanLocs{jj};
        
        ctmr_gauss_plot(gca,cortex,[0 0 0],0,hemId{hem})
        loc_view(view{hem}(1),view{hem}(2))
        set(gca, 'CameraViewAngle',7)
        
         el_add(chans,'k',20)
        for rr = 1:3
            el_add(chans(roiIds==rr,:),colors{rr},18);
        end
        
        
    end
end

print(gcf,'-dtiff',['-r' num2str(resolution)],[plotPath filename])
