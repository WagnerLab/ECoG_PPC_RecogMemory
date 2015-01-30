

colMapFun = @(bot,top,N)([ linspace(top(1),bot(1),N)', ...
    linspace(top(2),bot(2),N)', linspace(top(3),bot(3),N)']);

col1 = [0.8 0.5 0.2];
col2 = [1 1 1];
col3 = [0.2 0.4 0.8];
nLevels = 50;

colMap = [colMapFun(col2,col3,nLevels);
                col2;
                colMapFun(col1,col2,nLevels)];

colormap(colMap)
colorbar

%%
figure(1);
imagesc(data.epochTime,1:data.nFreqs,squeeze(stimData.meanROIHits(1,1,:,:)),[-1 1]);
axis xy; set(gca,'yticklabel',data.Freqs(get(gca,'ytick')))
colormap(colMap)
colorbar

figure(2);
imagesc(data.epochTime,1:data.nFreqs,squeeze(stimData.meanROICRs(1,1,:,:)),[-1 1]);
axis xy; set(gca,'yticklabel',data.Freqs(get(gca,'ytick')))
colormap(colMap)
colorbar


figure(3);
imagesc(data.epochTime,1:data.nFreqs,abs(squeeze(stimData.mainEfTvalROIs(1,1,:,:))>3));
axis xy; set(gca,'yticklabel',data.Freqs(get(gca,'ytick')))
colormap(colMap)
colorbar
%% load data
dataPath = '../Results/Spectral_Data/group/';
fileName = 'stimGroupSpectrumData.mat';
stimData = load([dataPath,fileName]); stimData = stimData.data;

fileName = 'RTGroupSpectrumData.mat';
RTData = load([dataPath,fileName]); RTData = RTData.data;

%% IPS Plots 
dataStruct = [];
dataStruct.time1 = stimData.epochTime;
dataStruct.time2 = RTData.epochTime;
dataStruct.col1  = [0.8 0.5 0.2];
dataStruct.col2  = [0.2 0.4 0.8];
dataStruct.freqs = stimData.Freqs;
dataStruct.Zlims = [-1 1];

figure(1); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[200,200,1000,500]);

yPos        = [0.68 0.39 0.1];
height      = 0.265;
text_yPos   = yPos;

ha = [];

dataStruct.data1 = squeeze(stimData.meanROIHits(1,1,:,:));
dataStruct.data2 = squeeze(RTData.meanROIHits(1,1,:,:));
ha{1} = subSpecPlot(dataStruct,[0.1 yPos(1) 0.85 height]);

dataStruct.data1 = squeeze(stimData.meanROICRs(1,1,:,:));
dataStruct.data2 = squeeze(RTData.meanROICRs(1,1,:,:));
ha{2} = subSpecPlot(dataStruct,[0.1 yPos(2) 0.85 height]);

dataStruct.data1 = squeeze(stimData.mainEfTvalROIs(1,1,:,:));
dataStruct.data2 = squeeze(RTData.mainEfTvalROIs(1,1,:,:));
ha{2} = subSpecPlot(dataStruct,[0.1 yPos(2) 0.85 height]);
