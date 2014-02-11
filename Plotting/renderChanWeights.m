
function renderChanWeights(data)

% to do make defaults.
chanCoords  = data.chanCoords;
weights     = data.weights;
cortex      = data.cortex;
hem         = data.hemisphere;
renderType  = data.renderType;
limits      = data.limits;

switch renderType
    case 'SmoothCh'
        ctmr_gauss_plot(gca,cortex,chanCoords,weights,hem);
        el_add(chanCoords,'k',10);
        
    case 'UnSmoothCh'
        ctmr_gauss_plot(gca,cortex,[0 0 0],[0],hem);
        el_add(chanCoords,'k',24)
        cm = colormap;
        cmS = size(colormap,1);
        cbar_bins = linspace(limits(1),limits(2),cmS);
        for i = 1:nChans
            w = weights(ii);
            color_id = histc(w,cbar_bins);
            el_color = cm(color_id ==1,:);
            el_add(chanCoords(i,:),el_color,20);
        end
%     case 'SigChans'
%         ctmr_gauss_plot(gca,cortex,[0 0 0],[0],hem);
%         for i = 1:nChans
%             if ismember(i,find(abs(binStat)>=1))
%                 el_size = 20;
%                 if roiIds(i)==1
%                     el_color = [0.9 0.2 0.2];
%                 elseif roiIds(i)==2
%                     el_color = [0.1 0.5 0.8];
%                 elseif roiIds(i)==3
%                     el_color = [0.2 0.6 0.3];
%                 end
%                 el_add(chanCoords(i,:),[0 0 0],25);
%             else
%                 el_size = 12;
%                 el_color = [0 0 0];
%             end
%             el_add(chanCoords(i,:),el_color,el_size);
%         end
%     case 'SignChans'
%         ctmr_gauss_plot(gca,cortex,[0 0 0],[0],hem);
%         posChans = binStat>=1;
%         negChans = binStat<=-1;
%         
%         el_add(chanCoords,[0 0 0],12);
%         el_add(chanCoords(posChans|negChans,:),[0 0 0],25);
%         el_add(chanCoords(posChans,:),[0.9 0.2 0.2],20);
%         el_add(chanCoords(negChans,:),[0.2 0.2 0.9],20);
end

