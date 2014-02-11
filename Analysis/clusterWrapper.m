

function out = clusterWrapper(data, opts)
% wrapper function for clustering channel data

chans = ismember(data.ROIid,opts.ROIs) & ismember(data.hemChanId,opts.hemNum);

% get data
dtype   = opts.dtype;
X       =   data.(dtype)(chans,:);

% smooth data
if opts.smoothData
    filtOrd     = 10;
    movAvg      = 1/filtOrd*ones(1,filtOrd);
    X           = applyFilter(movAvg,X);
end

% settings for clustering:
opts.method     = 'kmeans';
%opts.nClusters  = numel(opts.ROIs);
opts.nReplicates= 100;

%% cluster
out = clusterChannels(X,opts);
CM  = confusionmat(data.ROIid(chans),out.index);

if opts.nClusters ==2
    if CM(1,1)+CM(2,2) <= CM(1,2)+CM(2,1);
        temp = out.index;
        out.index(temp==1) = 2;
        out.index(temp==2) = 1;
        out.D = [out.D(:,2) out.D(:,1)];
        out.centers = [out.centers(2,:) ;out.centers(1,:)];
    end
end

out.CM      = confusionmat(data.ROIid(chans),out.index);
out.ROI_ids = data.ROIid(chans);

% change coordinates of the distances to clusters to unity line
DC      = out.D;
nCl     = size(DC,2); % number of clusters
nV      = 1/sqrt(nCl)*ones(1,nCl);
nDC     = 1-DC/max(DC(:)); out.nDC = nDC;
out.CDB     = nDC-(nDC*nV')*nV; %cluster desicion boundary

out.chans = chans;
out.nClusters = opts.nClusters;

out.CL_Nums = hist(out.index,out.nClusters);

%% plot clusters
if opts.plotting
    [f1 f2 f3] = plotClusters(data,out,chans,X);
    
    savePath        = opts.plotPath;
    extStr          = data.extension;
    if strcmp(opts.type,'erp'),
        plotPath = [savePath 'group/Clusters/'];
    elseif strcmp(opts.type,'ITC')
        plotPath = [savePath 'group/ITC/' opts.band '/Clusters/'];
    elseif strcmp(opts.type,'power')
        plotPath = [savePath 'group/' opts.band '/Clusters/'];
    end
    
    if ~exist(plotPath,'dir'),mkdir(plotPath),end
    if ~isempty(f1)
        filename = [plotPath '/' opts.hems dtype 'K' num2str(out.nClusters) 'ClustererdChans' extStr];
        print(f1,'-dtiff','-loose','-r500',filename);
    end
    %plot2svg([filename '.svg'],f1,'tiff')
    if ~isempty(f2)
        filename = [plotPath '/' opts.hems dtype 'K' num2str(out.nClusters) 'RendClustererdChans' extStr];
        print(f2,'-dtiff','-loose',['-r' num2str(opts.resolution)],filename);
    end
    figure(f3);
    filename = [plotPath '/' opts.hems dtype 'K' num2str(out.nClusters) 'ClustersTC' extStr];
    if strcmp(opts.lockType,'RT'),set(gca,'YAXisLocation','right'),end
    print(f3,'-dtiff','-loose',['-r' num2str(opts.resolution)],filename);
    set(gca,'xticklabel',[],'yticklabel',[]);set(f3,'position',[200 200, opts.aRatio])
    plot2svg([filename '.svg'],f3)
    
end


%% stats

[~,p]=kstest2(abs(out.CDB(out.index==out.ROI_ids,1)),abs(out.CDB(out.index~=out.ROI_ids,1)));
out.KSPval_D = p;
p=ranksum(abs(out.CDB(out.index==out.ROI_ids,1)),abs(out.CDB(out.index~=out.ROI_ids,1)));
out.RSPval_D = p;
[~,p,~,t]=ttest2(abs(out.CDB(out.index==out.ROI_ids,1)),abs(out.CDB(out.index~=out.ROI_ids,1)));
out.TPval_D = p;
out.Tstats = t;

out.CorrectClDist = mean(abs(out.CDB(out.index==out.ROI_ids,1)));
out.inCorrectClDist = mean(abs(out.CDB(out.index~=out.ROI_ids,1)));


