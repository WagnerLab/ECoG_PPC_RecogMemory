function ha = subSpecPlot(dataStruct,axesCoords)

%% set colormap
colMapFun = @(bot,top,N)([ linspace(top(1),bot(1),N)', ...
    linspace(top(2),bot(2),N)', linspace(top(3),bot(3),N)']);

col1 = dataStruct.col1;%[0.8 0.5 0.2];
col2 = [1 1 1];
col3 = dataStruct.col2;%[0.2 0.4 0.8];
nLevels = 50;

colMap = [colMapFun(col2,col3,nLevels);
                col2;
                colMapFun(col1,col2,nLevels)];

%% set axes location
raw_tcW = 0.46;
tcW 	= raw_tcW*axesCoords(3);
raw_sp 	= 0.01;
sp 		= raw_sp*axesCoords(3);
raw_tcH = 0.98;
tcH 	= raw_tcH*axesCoords(4);

xPos 		= [0 tcW+sp] + axesCoords(1);
yPos 		= axesCoords(2);

ha(1)=axes('position',[xPos(1) yPos tcW tcH]);
ha(2)=axes('position',[xPos(2) yPos tcW  tcH]);

%% parameters
freqs 	= dataStruct.freqs; 
nFreqs 	= numel(freqs);

time1 	= dataStruct.time1;
time2 	= dataStruct.time2;
X1 		= dataStruct.data1;
X2  	= dataStruct.data2;
Zlimits = dataStruct.Zlims;
timeTicks = {-0.2:0.2:1, -1:0.2:0.2};

% first spectrogram
axes(ha(1))
imagesc(time1,1:nFreqs,X1,Zlimits);
hold on;
plot([0 0],ylim,'--k','linewidth',2)

set(gca,'ytick',1:6:nFreqs)
set(gca,'yticklabel',freqs(get(gca,'ytick')))
set(gca,'fontsize',14,'fontWeight','normal')
set(gca,'xtick',timeTicks{1},'xticklabel',[])
set(gca,'lineWidth',0.5)
axis xy
colormap(gca,colMap)

if isfield(dataStruct,'ylabel')
	ylabel(dataStruct.ylabel)
end

% second spectrogram
axes(ha(2))
imagesc(time2,1:nFreqs,X2,Zlimits);
hold on;
plot([0 0],ylim,'--k','linewidth',2)

set(gca,'ytick',1:6:nFreqs)
set(gca,'yticklabel',freqs(get(gca,'ytick')))
set(gca,'fontsize',14,'fontWeight','normal')
set(gca,'xtick',timeTicks{2},'xticklabel',[])
set(gca,'yAxisLocation','right')
axis xy
colormap(gca,colMap)