function h = plotNTraces(X,t,cols,smoother,smootherSpan,centerType, yLimits)
% h = plotNTraces(X,t,cols,smoother,smootherSpan)
% function that plots traces with mean and cells
% takes a cell X: number of cells indicate the number of traces; each
% cell should be a matrix with:
% 1st dim = observations
% 2nd dim = time
% t = time units
% colors for each trace
% smoother: {'loess','lowess','moving'}
% smootherSpan: 0-1 for loess, nsamps for moving
% centerType indicates if it should use the mean or the median


N = numel(X);
nSamps = size(X{1},2);

o = [0.9 0.5 0.1]; % orange
c = [0.1 0.8 0.9]; % cyan
g = [0.2 0.6 0.3]; % green
b = [0.1 0.5 0.8]; % blue
r = [0.9 0.2 0.2]; % red
k = [0.05 0.05 0.05]; % black
y = [0.6  0.65 0.1]; % cluster1
l = [0.1 0.65 0.6]; % cluster2

colors = zeros(N,3);

n   = zeros(N,1);
m   = zeros(N,nSamps);
se  = zeros(N,nSamps);

if ~exist('centerType','var')
    centerType = 'mean';
end
for i = 1:N
    colors(i,:) = eval(cols(i));
    x = X{i};
    
    m(i,:)  = eval([centerType '(x)']);
    n(i)    = size(x,1);
    se(i,:) = std(x)/sqrt(n(i)-1);
    if exist('smoother','var')
        m(i,:)  = smooth(m(i,:),smootherSpan,smoother);
        se(i,:) = smooth(se(i,:),smootherSpan,smoother);
    end
end

h.f=figure(gcf);cla;hold on;

if exist('yLimits','var')
    minY = yLimits(1);
    maxY = yLimits(2);
else
    minY = min(min(m-se));
    minY = minY - 0.25*abs(minY);
    maxY = max(max(m+se));
    maxY = maxY + 0.2*abs(maxY);    
end

ylim([minY maxY])

for c = 1:N
    plot(t,m(c,:)+se(c,:),'color',colors(c,:));
    plot(t,m(c,:)-se(c,:),'color',colors(c,:));
end

xlim([t(1)-0.01 t(end)+0.01])
plot(xlim,[0 0],'--k','linewidth',2)
plot([0 0],ylim,'--k','linewidth',2)

for c = 1:N
    h.(['h' num2str(c)]) = shadedErrorBar(t,m(c,:),se(c,:),{'color', colors(c,:),'linewidth',3},1);
    set(h.(['h' num2str(c)]).mainLine,'marker','.','MarkerSize',11)
end
set(gca,'linewidth',2)
set(gca,'fontweight','bold')
set(gca,'fontsize',15);
minY = minY + 0.05*abs(minY);
ylim([minY maxY])

x=get(gca,'YTick');
if (max(x)==-min(x))
    set(gca,'YTick',[min(x) 0  max(x)])
elseif (max(x) > -min(x)) && ( min(x) < 0)
    set(gca,'YTick',[min(x) 0 max(x)/2 max(x)])
elseif (max(x) > -min(x))
    set(gca,'YTick',[0 max(x)/2 max(x)])
elseif (min(x) < -max(x)) && ( max(x) > 0)
    set(gca,'YTick',[min(x) min(x)/2 0 max(x)])
elseif (min(x) < -max(x))
    set(gca,'YTick',[min(x) min(x)/2 0])
end
set(gca,'yTickLabel',get(gca,'yTick'));
hold off;
