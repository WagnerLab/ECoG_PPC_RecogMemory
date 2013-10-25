function plotERPs(data,opts)
% plots ERPs for hits CRs for every channel
%
% dependencies: plotNTraces.m
%               plot2svg.m
savePath    = opts.plotPath;
type        = opts.type;
smoother    = opts.smoother;
smootherSpan = opts.smootherSpan;

t = data.trialTime;

H=data.Hits;
CR=data.CRs;

extStr =  [data.lockType data.baselineType data.analysisType data.reReferencing num2str(data.nRefChans)];
if strcmp(type,'power'), extStr = [data.band extStr];end

nChans = data.nChans;

if strcmp(data.baselineType,'rel')
    yOffset = 1;
elseif strcmp(data.baselineType,'sub')
    yOffset = 0;
end

for c = 1:nChans   
    x = squeeze(data.erp(c,:,:));    
    X{1} = x(H,:)-yOffset;
    X{2} = x(CR,:)-yOffset;
    figure(1); clf;
    h = plotNTraces(X,t,'oc',smoother,smootherSpan);
    if strcmp(opts.lockType,'RT'),set(gca,'YAXisLocation','right'),end
    
    roistr = 'other';
    for r = {'AG','IPS','SPL'}
        if ismember(c,data.chanInfo.(r{1}))
            roistr = r{1};
            break
        end
    end
    if strcmp(type,'power'), 
        plotPath = [savePath roistr '/' data.band '/Chan/'];    
    else
        plotPath = [savePath roistr '/Chan/'];
    end    
    if ~exist(plotPath,'dir'),mkdir(plotPath),end    
    filename = [plotPath '/subj' data.subjnum 'ERPsH-CR_Chan' num2str(c) extStr];    
    print(h.f,'-dtiff','-r100',filename);
    plot2svg([filename '.svg'],h.f,'tiff')        
end