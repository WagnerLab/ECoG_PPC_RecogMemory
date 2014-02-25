function out = clusterWrapper(data, opts)
% wrapper function for clustering channel data
inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';

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

chansIds=find(chans);
for jj = 1:out.nClusters
    ClChans = chansIds(out.index==jj);
    out.nSubjChansCl(jj,:) = hist(data.subjChans(ClChans),4);
end

out.CL_Nums = hist(out.index,out.nClusters);


if opts.findSubCluster && (out.nClusters==2)
        [out subF] = findSubClusters(data, out,opts);    
end
%% plot clusters
if opts.plotting
    [clF] = plotClusters(data,out,chans,X);
    
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
    
    filenameSuf = [plotPath '/' opts.hems dtype 'K' num2str(out.nClusters)];
    
    if ~isempty(clF(1))
        filename = [filenameSuf 'ClustererdChans' extStr];
        print(clF(1),'-dtiff','-loose','-r500',filename);
    end
    %plot2svg([filename '.svg'],f1,'tiff')
    if ~isempty(clF(2))
        filename = [filenameSuf 'RendClustererdChans' extStr];
        print(clF(2),'-dtiff','-loose',['-r' num2str(opts.resolution)],filename);
    end
    
    figure(clF(3));
    filename = [filenameSuf 'ClustersTC' extStr];
    if strcmp(opts.lockType,'RT'),set(gca,'YAXisLocation','right'),end
    print(clF(3),'-dtiff','-loose',['-r' num2str(opts.resolution)],filename);
    set(gca,'xticklabel',[],'yticklabel',[]);set(clF,'position',[200 200, opts.aRatio])
    plot2svg([filename '.svg'],clF(3))
    eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
    
    % sub-clusters
    if opts.findSubCluster && (out.nClusters==2)
        subSuclstersPlotNames = {'sub1','sub2','sub3', 'subsClDiffs','SubsClRender'};
        
        for jj = 1:4
            figure(subF(jj));
            filename = [filenameSuf subSuclstersPlotNames{jj} extStr];
            if strcmp(opts.lockType,'RT'),set(gca,'YAXisLocation','right'),end
            set(gcf,'position',[200 200, opts.aRatio])            
            plot2svg([filename '.svg'],gcf)
            eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
        end
        
        figure(subF(5))
        filename = [filenameSuf subSuclstersPlotNames{5} extStr];
        print(gcf,'-dtiff','-loose',['-r' num2str(opts.resolution)],filename);
        
    end   
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


