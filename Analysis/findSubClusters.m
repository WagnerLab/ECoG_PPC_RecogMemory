
function [out f] = findSubClusters(data,out, opts)

% for now this is hardocded to work for k=2, and finding 3 subclusters,
% separating by cluster width and using that width to measure distance from
% the decision boundary,

% sig1 = std(out.nDC(out.index==1,1));
% sig2 = std(out.nDC(out.index==2,2));
% out.SubClthr  = mean([sig1 sig2]);
out.SubClthr = std(out.CDB(:,1));

cLcol=[];
cLcol(1,:)=[0.6  0.65 0.1];
cLcol(2,:)=[0.1  0.65 0.6];
cLcol(3,:)=[0.6  0.1 0.6];

IPSch = (data.hemChanId==1).*data.ROIid==1;
SPLch = (data.hemChanId==1).*data.ROIid==2;

chans = find(IPSch|SPLch);

out.subCLChans{1}= chans(find(out.CDB>=out.SubClthr));
out.subCLChans{2}= chans(find(out.CDB<=-out.SubClthr));
out.subCLChans{3}= chans(find(abs(out.CDB)<out.SubClthr));

if opts.plotting
    X = cell(3,1);
    cnt = 1;
    for jj = 1:3
        X{jj}=data.ZStat(out.subCLChans{jj},:);
        
        Y = cell(2,1);
        Y{1}=data.mHits(out.subCLChans{jj},:);
        Y{2}=data.mCRs(out.subCLChans{jj},:);
        
        f(cnt)=figure; clf; cnt=cnt+1;
        plotNTraces(Y,data.trialTime,'oc','loess',0.15)
    end
    
    f(cnt)=figure; clf; cnt=cnt+1;
    plotNTraces(X,data.trialTime,'ylm','loess',0.15)
    
    
    cortex = data.lMNIcortex;
    chanLocs = data.MNILocs(chans,:);
    
    f(cnt) = figure(); clf;
    set(f(cnt),'Position',[200 200 800 800]);
    tight_subplot(1,1,0.001,0.001,0.001);
    ctmr_gauss_plot(gca,cortex,[0 0 0],0,'l');
    
    el_add(chanLocs,[0 0 0],25);
    
    for jj = 1:3
        el_color    = cLcol(jj,:);
        for i = 1:numel(out.subCLChans{jj})
            el_add(data.MNILocs(out.subCLChans{jj}(i),:),el_color,20);
        end
    end
    loc_view(310,30)
    
    for jj = 1:3
        out.nSubjChansSubCl = hist(data.subjChans(out.subCLChans{jj}),4);
    end
else 
    f=[]
end