function renderCortex(data,opts)
%
% dependencies:
%   ctmr_gauss_plot  
%   loc_view
%   el_add
%   label_add

addpath('./Doras_rendering_scripts/render_brains/');

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

switch opts.level
    case 'subj'
        for s = 1:nSubjs;
            subj = data.options.subjects{s};
            ChIds = data.subjChans ==s;
            opts.hem = HEMS{data.hemChanId(find(data.subjChans==s,1))};
            
            switch opts.cortexType
                case 'Native'
                    opts.cortex = data.cortex{s};
                    opts.chans = data.subjLocs(ChIds,:);
                case 'MNI'
                    opts.cortex = data.([opts.hem 'MNIcortex']);
                    opts.chans = data.MNILocs(ChIds,:);
            end
            opts.ROIid = data.ROIid(ChIds);
            opts.subROIid = data.subROIid(ChIds);
            opts.labels = data.LPCchanId(ChIds);
            
            h = render(opts);
            
            fileName = [subj opts.level 'ChannelRender' opts.cortexType extStr];
            print(h,'-dtiff',['-r' num2str(opts.resolution)],[opts.mainPath '/subj/' fileName])
        end
        
    case 'group'
        
        for hem = [1 2]            
            ChIds = data.hemChanId==hem;
            
            opts.hem = HEMS{hem};
            opts.cortex = data.([opts.hem 'MNIcortex']);
            opts.chans = data.MNILocs(ChIds,:)*1.02;
            
            opts.ROIid = data.ROIid(ChIds);
            opts.subROIid = data.subROIid(ChIds);
            opts.labels = data.LPCchanId(ChIds);
            
            h = render(opts);
            
            fileName = [ opts.hem  opts.level 'ChannelRender' extStr];
            print(h,'-dtiff',['-r' num2str(opts.resolution)],[opts.mainPath fileName])
        end
        
end


function h = render(opts)

cortex = opts.cortex;
hem = opts.hem;
chans = opts.chans;

view.l      = [310,30];
view.r      = [50,30];

h=figure();clf;
set(h,'Position',[200 200 800 800]);
ctmr_gauss_plot(gca,cortex,[0 0 0],0,hem)
loc_view(view.(hem)(1),view.(hem)(2))


if ~opts.chanNumLabel
    el_add(chans,'k',24)
end

if opts.ROIColor
    cols = opts.ROIColors;
    for r = 1:3
        roiId = opts.ROIid==r;
        el_add(chans(roiId,:),cols(r,:),20)
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

