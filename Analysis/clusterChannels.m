function out = clusterChannels(X,opts)
% kmeansChannels(data,opts)
% this function clusters channels using the various methods. the opts
% variable must have fields that indicate the method to be used (kmeans )
% and the number of replications to be used in the case of k-means.
% a.gonzl Nov 2013


% defaults:
if ~exist('opts','var')
    opts.method     = 'kmeans';
    opts.nClusters  = 2;
    opts.nReplicates= 100;
end

% cluster
switch opts.method
    case 'kmeans'
        [out.index,out.centers, ~, out.D] = kmeans(X,opts.nClusters,'replicates',opts.nReplicates);
        % change coordinates of the distances to clusters to unity line

    case 'gm'
        gm          = gmdistribution.fit(X,opts.nClusters,'replicates',opts.nReplicates);
        out.index   = cluster(gm,X);
        out.probs   = posterior(gm,X);
        
    otherwise
        error('method is not supported')
end

end