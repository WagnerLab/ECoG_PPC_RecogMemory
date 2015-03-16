function ha = subPlotsForSubjectFigures(dataStruct,axesCoords)
% fields of data:
% struct.time 	-> 2 x cell array; one for stim, one for RT
% struct.data1 	-> data for first plot, 
% 				cell array containing the condition types
%				each row of the cell must be a channel with length of time
% struct.data2 	-> the same for the second plot
% struct.bar1 	-> 2 x cell array containing the data for the
%				  first barplot. each row is a channel (1d)
% struct.bar1_label -> label for bar 1
% struct.bar2 	-> same for the second bar plot
% struct.bar2_label -> label for bar 2
% struct.xTicks 	-> 2 x cell array containing the xticks
% struct.xTickLabels-> 2 x cell array containing the xticklabels
%
% axesCoords = [x1,y1,W,H];

smoother       	= 'loess';
smootherSpan   	= 0.15;
if ~isfield(dataStruct,'yLimits')
    yLimits 		= [-1.2 2.2];
else
    yLimits         = dataStruct.yLimits;
end

if ~isfield(dataStruct,'yTick')
    yTicks = [0 0.75 1.5];
    yTickLabel = {'0','','1.5'};
else
    yTicks = dataStruct.yTick;
    yTickLabel = {};
    for ii =1:2:numel(yTicks)
        yTickLabel{ii} = num2str(yTicks(ii));
        yTickLabel{ii+1} = '';
    end
end
yRefLims    = [yLimits(1)*0.3 yLimits(2)*0.3];    
timeTicks   	= {-0.2:0.2:1, -1:0.2:0.2};

opts 			= [];
opts.colors(1,:) = [0.9 0.5 0.1];
opts.colors(2,:) = [0.1 0.8 0.9];
opts.yLimits    = yLimits;

raw_tcW = 0.36;
tcW 	= raw_tcW*axesCoords(3);
raw_bW 	= 0.1;
bW 		= raw_bW*axesCoords(3);
raw_sp 	= 0.01;
sp 		= raw_sp*axesCoords(3);
raw_tcH = 0.98;
tcH 	= raw_tcH*axesCoords(4);

x0 		= [0, tcW+sp, bW+sp, bW+sp];
xPos	= cumsum(x0)+axesCoords(1);
yPos 	= axesCoords(2);

linePos = 0.89;

ha(1)=axes('position',[xPos(1) yPos tcW tcH]);
ha(2)=axes('position',[xPos(2) yPos bW  tcH]);
ha(3)=axes('position',[xPos(3) yPos bW  tcH]);
ha(4)=axes('position',[xPos(4) yPos tcW tcH]);

% first plot
axes(ha(1))
time 	= dataStruct.time{1};
X 		= dataStruct.data1;

hh = plotNTraces(X,time,'oc', smoother, smootherSpan,'mean',yLimits);
yy=get(gca,'children');
set(yy(9),'YData',[yRefLims],'color',0.3*ones(3,1))
set(yy(10),'color',0.3*ones(3,1))

set(gca,'fontsize',14,'fontWeight','normal')
set(gca,'ytick',yTicks)
set(gca,'yticklabel',yTickLabel)
set(gca,'xtick',timeTicks{1},'XtickLabel',[])

% first bar plot
axes(ha(2))
X = [];
X{1} = mean(dataStruct.data1{1}(:,dataStruct.barPlotLims{1}),2);
X{2} = mean(dataStruct.data1{2}(:,dataStruct.barPlotLims{1}),2);
barPlotWithErrors(ha(2),X,opts);

% second bar plot
axes(ha(3))
X = [];
X{1} = mean(dataStruct.data2{1}(:,dataStruct.barPlotLims{2}),2);
X{2} = mean(dataStruct.data2{2}(:,dataStruct.barPlotLims{2}),2);
barPlotWithErrors(ha(3),X,opts);
set(gca,'YAXisLocation','right')

% second plot
axes(ha(4))
time 	= dataStruct.time{2};
X 		= dataStruct.data2;

hh = plotNTraces(X,time,'oc', smoother, smootherSpan,'mean',yLimits);
yy=get(gca,'children');
set(yy(9),'YData',[yRefLims],'color',0.3*ones(3,1))
set(yy(10),'color',0.3*ones(3,1))

set(gca,'fontsize',14,'fontWeight','normal')
set(gca,'ytick',yTicks)
set(gca,'yticklabel',yTickLabel)
set(gca,'xtick',timeTicks{2},'XtickLabel',[])
set(gca,'YAXisLocation','right')
