function renderChansFig1(data,opts)
%
% dependencies:
%   ctmr_gauss_plot
%   loc_view
%   el_add
%   label_add

inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';

HEMS = {'l','r'};
nSubjs = numel(data.options.subjects);

extStr = [];
if opts.ROIColor
    extStr = [extStr 'ROIid'];
end
if opts.subROIColor
    extStr = [extStr 'subROIid'];
end
if opts.chanNumLabel
    extStr = [extStr 'chanLabel'];
end

hem = 1;

ChIds = data.hemChanId==hem;

opts.hem = HEMS{hem};
opts.cortex = data.([opts.hem 'MNIcortex']);
opts.chans = data.MNILocs(ChIds,:)*1.02;

opts.ROIid = data.ROIid(ChIds);
opts.subROIid = data.subROIid(ChIds);
opts.labels = data.LPCchanId(ChIds);

h=figure(1);clf;
set(h,'Position',[200 200 600 600],'PaperPositionMode','auto');

axes('position',[0.001 0.95 0.3 0.05]);xlim([0 1]); ylim([0 1])
text(0.05,0.45,' a ','fontsize',28)
set(gca,'visible','off')

axes('position',[0.120 .25 0.03 0.1]); hold on;
plot([0.4],[3],'o','color',opts.ROIColors(1,:),'markersize',15,'markerfacecolor',opts.ROIColors(1,:))
plot([0.4],[2],'o','color',opts.ROIColors(2,:),'markersize',15,'markerfacecolor',opts.ROIColors(2,:))
plot([0.4],[1],'o','color',opts.ROIColors(3,:),'markersize',15,'markerfacecolor',opts.ROIColors(3,:))

xlim([0 0.8]); ylim([0.5 3.5])
text(0.9,3,'IPS','fontsize',16)
text(0.9,2,'SPL','fontsize',16)
text(0.9,1,'AG ','fontsize',16)
set(gca,'visible','off')

cPath = pwd;
cd(opts.plotPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

filename = ['Fig1alROIChannelRender' extStr];
plot2svg([filename '.svg'],gcf)
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
cd(cPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

h=figure(2);clf;
set(h,'Position',[200 200 600 600],'PaperPositionMode','auto');
render(opts)
print(h,'-dtiff',['-r' num2str(opts.resolution)],[opts.plotPath filename])


function h = render(opts)

cortex = opts.cortex;
hem = opts.hem;
chans = opts.chans;

%temporary hack for channel that doesn't appear
chans(13,:) = chans(13,:)*1.1;

view.l      = [310,30];
view.r      = [50,30];

axes('position',[0.1 0.1 0.8 0.8])
ctmr_gauss_plot(gca,cortex,[0 0 0],0,hem)
loc_view(view.(hem)(1),view.(hem)(2))
set(gca, 'CameraViewAngle',7)

if ~opts.chanNumLabel
    el_add(chans,'k',30)
end

if opts.ROIColor
    cols = opts.ROIColors;
    for r = 1:3
        roiId = opts.ROIid==r;
        el_add(chans(roiId,:),cols(r,:),25)
    end
end

if opts.subROIColor
    cols = opts.subROIColors;
    for r = 1:4
        subroiId = opts.subROIid==r;
        el_add(chans(subroiId,:),cols(r,:),20)
    end
end


if opts.chanNumLabel
    label_add(chans,opts.labels)
end

