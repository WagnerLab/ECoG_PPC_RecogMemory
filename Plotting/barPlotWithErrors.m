function barPlotWithErrors(ha,M,opts)
% ha = barPlotWithErrors(M)
%
% M -> cell array with the data. Each cell entry becomes a column in the
% bargraph
% opts -> options: 
%   aspectRatio
%   colors
%   baseLine
%   yLimits 
%   xPositions

axes(ha); cla; hold on;

nBars   = numel(M);
m       = zeros(nBars,1);
se      = zeros(nBars,1);

if ~isfield(opts,'aspectRatio')
    opts.aspectRatio = [200 600];
end

if ~isfield(opts,'colors')
    opts.colors = zeros(nBars,3);
end

if ~isfield(opts,'baseLine')
    opts.baseLine =0;
end

if ~isfield(opts,'xPositions')
    opts.xPositions = 1:nBars;
end

if isfield(opts,'xLimits')
    xlim(opts.xLimits)
else
    xlim([0 nBars]+0.5)
end

plot(xlim,[opts.baseLine opts.baseLine],'-',...
    'color',ones(3,1)*0.3,'linewidth',2)

for ba = 1:nBars
    
    X = M{ba};
    n = sum(~isnan(X));
    m(ba)   = nanmean(X);
    se(ba)  = nanstd(X)/sqrt(n-1);
        
    bar(opts.xPositions(ba),m(ba),0.90,'FaceColor',opts.colors(ba,:),'edgeColor', 'none', 'basevalue',opts.baseLine,'ShowBaseLine','off')
    plot([1 1]*opts.xPositions(ba), [-se(ba) se(ba)]+m(ba), 'color',[0 0 0],'linewidth',4)
    
end    

if isfield(opts,'yLimits')
    ylim(opts.yLimits)
end

if isfield(opts,'xTicks')
   set(gca,'XTick',opts.xTicks)
else
    set(gca,'XTick',[])
end

if isfield(opts,'yTicks')
   set(gca,'YTick',opts.yTicks)
else
    set(gca,'yTick',[])
end

set(gca,'LineWidth',2,'FontSize',18,'XTickLabel','')

