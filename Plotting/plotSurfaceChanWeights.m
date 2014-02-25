function plotSurfaceChanWeights(handle, cortex, elecs, weights,opts)


% colorbar limits
hem         = opts.hem;
limitUp     = opts.limitUp;
limitDw     = opts.limitDw;
type        = opts.renderType;

switch type
    case 'SmoothCh'
        Colors = [;
            0.1 0 1;
            0 1 1;
            0 1 0.7;
            0.7 0.7 0.7;
            0.7 0.7 0.7;
            0.7 1 0;
            1 1 0;
            1 0 0.1;];
        nLevels     = size(Colors,1)/2;
        levels      = [linspace(-limitUp,-limitDw,nLevels),linspace(limitDw,limitUp,nLevels)];
        clbar_map   = cMapGenerate(Colors,levels);
        
        ctmr_gauss_plot(handle,cortex,elecs,weights,hem,clbar_map);
        el_add(elecs,'k',10);
        
    case 'UnSmoothCh'
        Colors = [;
            0.1 0 1;
            0 1 1;
            0 1 0.7;
            1 1 1 ;
            1 1 1;
            0.7 1 0;
            1 1 0;
            1 0 0.1;];
        nLevels     = size(Colors,1)/2;
        levels      = [linspace(-limitUp,-limitDw,nLevels),linspace(limitDw,limitUp,nLevels)];
        clbar_map   = cMapGenerate(Colors,levels);
        nclbar_bins = size(clbar_map,1);
        cbar_bins = linspace(limitDw,limitUp,nclbar_bins);
        
        ctmr_gauss_plot(handle,cortex,[0 0 0],[0],hem);
        el_add(elecs,'k',24);
        for i = 1:size(elecs,1)
            w = weights(i);
            if w >= limitUp
                color_id = clbar_map(end,:);
            elseif w <= limitDw
                color_id = clbar_map(1,:);
            else
                color_id = histc(w,cbar_bins);
            end
            
            el_color = clbar_map(color_id ==1,:);
            el_add(elecs(i,:),el_color,20);
        end
        
    case 'UnSmoothChThr'
        absLimit    = opts.absLevel;
        
        Colors = [;
            0.1 0 1;
            0 1 1;
            1 1 1;
            1 1 1;
            1 0.7 0;
            1 0 0;];
        nLevels     = size(Colors,1)/2;
        levels      = [linspace(-limitUp,-limitDw,nLevels),linspace(limitDw,limitUp,nLevels)];
        clbar_map   = cMapGenerate(Colors,levels);
        nclbar_bins = size(clbar_map,1);
        cbar_bins1 = linspace(absLimit,limitUp,nclbar_bins/2);
        cbar_bins2 = linspace(limitDw,-absLimit,nclbar_bins/2);
        
        ctmr_gauss_plot(handle,cortex,[0 0 0],[0],hem);
        el_add(elecs,'k',24);
        for i = 1:size(elecs,1)
            w = weights(i);
            if w >= limitUp
                color_id = nclbar_bins;
                el_color = clbar_map(color_id,:);
            elseif w <= limitDw
                color_id = 1;
                el_color = clbar_map(color_id,:);
            elseif w >= absLimit
                color_id = find(histc(w,cbar_bins1))+ nclbar_bins/2;
                el_color = clbar_map(color_id,:);
            elseif w <= -absLimit
                color_id = find(histc(w,cbar_bins2));
                el_color = clbar_map(color_id,:);
            else
                el_color = [0 0 0];
            end
            el_add(elecs(i,:),el_color,20);
        end  
    otherwise
        error('rendering type not supported')
end