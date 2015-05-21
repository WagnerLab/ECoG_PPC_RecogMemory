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
dataStruct.col1  = [0.5 0.1 0.1];%[0.8 0.6 0.2];
dataStruct.col2  = [0.3 0.1 0.6];%[0.2 0.6 0.8];
dataStruct.freqs = stimData.Freqs;
dataStruct.Zlims = [-1.5 1.5];

figure(1); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[-1000,-400,1000,800]);

yPos        = [0.8 0.6 0.3 0.1];
height      = 0.19;
text_yPos   = yPos;

ha = [];

% data subplots
dataStruct.ylabel = ' Hits (dB) ';
dataStruct.data1 = squeeze(stimData.meanROIHits(1,1,:,:));
dataStruct.data2 = squeeze(RTData.meanROIHits(1,1,:,:));
ha{1} = subSpecPlot(dataStruct,[0.1 yPos(1) 0.85 height]);

dataStruct.ylabel = ' CRs (dB) ';
dataStruct.data1 = squeeze(stimData.meanROICRs(1,1,:,:));
dataStruct.data2 = squeeze(RTData.meanROICRs(1,1,:,:));
ha{2} = subSpecPlot(dataStruct,[0.1 yPos(2) 0.85 height]);

% colorbar
axes('position',[0.95 yPos(2) 0.05 height])
cb=colorbar;
set(cb,'position',[0.93 0.7 0.02 0.15])
set(cb,'CLim',[dataStruct.Zlims])
set(cb,'ytick',[1 50 102],'yticklabel',[dataStruct.Zlims(1) 0 dataStruct.Zlims(2)])
axis off

% save figure 1
SupPlotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ', 'Manuscript Figures/supplement/SpectogramPlots/'];
print(gcf, '-dtiff','-r500', [SupPlotPath 'IPS_Spectrogram1'])

% matlab doesn't accept different colormaps int the 
% same figure as of R2014a. using a different figure 
% the statisic.
figure(2); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[-1000,-400,1000,800]);

dataStruct.Zlims = [-5 5];
dataStruct.col1  = [0.8 0.6 0.2];
dataStruct.col2  = [0.2 0.6 0.8];
dataStruct.ylabel = ' T-Stat ';
dataStruct.data1 = squeeze(stimData.mainEfTvalROIs(1,1,:,:));
dataStruct.data2 = squeeze(RTData.mainEfTvalROIs(1,1,:,:));
% statistic subplot
ha{3} = subSpecPlot(dataStruct,[0.1 yPos(3) 0.85 height]);

% colorbar
axes('position',[0.95 yPos(1) 0.05 height])
cb=colorbar;
set(cb,'position',[0.93 0.32 0.02 0.15])
set(cb,'CLim',[dataStruct.Zlims])
set(cb,'ytick',[1 50 102],'yticklabel',[dataStruct.Zlims(1) 0 dataStruct.Zlims(2)])
axis off

% pvalue subplot
% get signs of 
Xsign = ones(size(dataStruct.data1));
Xsign(dataStruct.data1<0)=-1;
Ysign = ones(size(dataStruct.data2));
Ysign(dataStruct.data2<0)=-1;

dataStruct.Zlims = [-1 1];
dataStruct.col1  = [0.8 0.6 0.2];
dataStruct.col2  = [0.2 0.6 0.8];
dataStruct.ylabel = ' p-val < 0.05* ';

pValThr  = 0.05;
se          = [0 0 0; 0 1 0; 0 0 0];
% create mask for fdr correction
f = dataStruct.freqs; maskF = f<=180;
t1 = dataStruct.time1; maskT1 = t1>0;
t2 = dataStruct.time1; maskT2 = true(size(t2));

X = squeeze(stimData.mainEfpValROIs(1,1,:,:));
X(~maskF,:) = 0; X(:,~maskT1) = 0;
X2 = X(maskF,maskT1);
X(maskF,maskT1) = reshape(mafdr(X2(:)),size(X2))<pValThr;
X = imerode(X,se);
X = X.*Xsign;


Y = squeeze(RTData.mainEfpValROIs(1,1,:,:));
Y(~maskF,:) = 0; Y(:,~maskT2) = 0;
Y2 = Y(maskF,maskT2);
Y(maskF,maskT2) = reshape(mafdr(Y2(:)),size(Y2))<pValThr;
Y = imerode(Y,se);
Y = Y.*Ysign;

dataStruct.data1 = X;
dataStruct.data2 = Y;
% statistic subplot
ha{4} = subSpecPlot(dataStruct,[0.1 yPos(4) 0.85 height]);
set(ha{4}(1),'xticklabel',{'','stim','','0.4','','0.8',''})
set(ha{4}(2),'xticklabel',{'','-0.8','','-0.4','','resp',''})
axes('position', [0.1 0 0.85 0.1])
text(0.46,0.5, ' Time(s) '  ,'fontsize',16,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
 set(gca,'visible','off')
print(gcf, '-dtiff','-r500', [SupPlotPath 'IPS_Spectrogram2'])

%% SPL pltos

dataStruct = [];
dataStruct.time1 = stimData.epochTime;
dataStruct.time2 = RTData.epochTime;
dataStruct.col1  = [0.5 0.1 0.1];%[0.8 0.6 0.2];
dataStruct.col2  = [0.3 0.1 0.6];%[0.2 0.6 0.8];
dataStruct.freqs = stimData.Freqs;
dataStruct.Zlims = [-1.5 1.5];

figure(1); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[-1000,-400,1000,800]);

yPos        = [0.8 0.6 0.3 0.1];
height      = 0.19;
text_yPos   = yPos;

ha = [];

% data subplots
dataStruct.ylabel = ' Hits (dB) ';
dataStruct.data1 = squeeze(stimData.meanROIHits(1,2,:,:));
dataStruct.data2 = squeeze(RTData.meanROIHits(1,2,:,:));
ha{1} = subSpecPlot(dataStruct,[0.1 yPos(1) 0.85 height]);

dataStruct.ylabel = ' CRs (dB) ';
dataStruct.data1 = squeeze(stimData.meanROICRs(1,2,:,:));
dataStruct.data2 = squeeze(RTData.meanROICRs(1,2,:,:));
ha{2} = subSpecPlot(dataStruct,[0.1 yPos(2) 0.85 height]);

% colorbar
axes('position',[0.95 yPos(2) 0.05 height])
cb=colorbar;
set(cb,'position',[0.93 0.7 0.02 0.15])
set(cb,'CLim',[dataStruct.Zlims])
set(cb,'ytick',[1 50 102],'yticklabel',[dataStruct.Zlims(1) 0 dataStruct.Zlims(2)])
axis off

% save figure 1
SupPlotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ', 'Manuscript Figures/supplement/SpectogramPlots/'];
print(gcf, '-dtiff','-r500', [SupPlotPath 'SPL_Spectrogram1'])

% matlab doesn't accept different colormaps int the 
% same figure as of R2014a. using a different figure 
% the statisic.
figure(2); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[-1000,-400,1000,800]);

dataStruct.Zlims = [-5 5];
dataStruct.col1  = [0.8 0.6 0.2];
dataStruct.col2  = [0.2 0.6 0.8];
dataStruct.ylabel = ' T-Stat ';
dataStruct.data1 = squeeze(stimData.mainEfTvalROIs(1,2,:,:));
dataStruct.data2 = squeeze(RTData.mainEfTvalROIs(1,2,:,:));
% statistic subplot
ha{3} = subSpecPlot(dataStruct,[0.1 yPos(3) 0.85 height]);

% colorbar
axes('position',[0.95 yPos(1) 0.05 height])
cb=colorbar;
set(cb,'position',[0.93 0.32 0.02 0.15])
set(cb,'CLim',[dataStruct.Zlims])
set(cb,'ytick',[1 50 102],'yticklabel',[dataStruct.Zlims(1) 0 dataStruct.Zlims(2)])
axis off

% pvalue subplot
% get signs of 
Xsign = ones(size(dataStruct.data1));
Xsign(dataStruct.data1<0)=-1;
Ysign = ones(size(dataStruct.data2));
Ysign(dataStruct.data2<0)=-1;

dataStruct.Zlims = [-1 1];
dataStruct.col1  = [0.8 0.6 0.2];
dataStruct.col2  = [0.2 0.6 0.8];
dataStruct.ylabel = ' p-val < 0.05* ';

pValThr  = 0.05;
se          = [0 0 0; 0 1 0; 0 0 0]; % correction cluster kernel.
% create mask for fdr correction
f = dataStruct.freqs; maskF = f<=180;
t1 = dataStruct.time1; maskT1 = t1>0;
t2 = dataStruct.time1; maskT2 = true(size(t2));

X = squeeze(stimData.mainEfpValROIs(1,2,:,:));
X(~maskF,:) = 0; X(:,~maskT1) = 0;
X2 = X(maskF,maskT1);
X(maskF,maskT1) = reshape(mafdr(X2(:)),size(X2))<pValThr;
X = imerode(X,se);
X = X.*Xsign;

Y = squeeze(RTData.mainEfpValROIs(1,2,:,:));
Y(~maskF,:) = 0; Y(:,~maskT2) = 0;
Y2 = Y(maskF,maskT2);
Y(maskF,maskT2) = reshape(mafdr(Y2(:)),size(Y2))<pValThr;
Y = imerode(Y,se);
Y = Y.*Ysign;

dataStruct.data1 = X;
dataStruct.data2 = Y;
% statistic subplot
ha{4} = subSpecPlot(dataStruct,[0.1 yPos(4) 0.85 height]);
set(ha{4}(1),'xticklabel',{'','stim','','0.4','','0.8',''})
set(ha{4}(2),'xticklabel',{'','-0.8','','-0.4','','resp',''})
axes('position', [0.1 0 0.85 0.1])
text(0.46,0.5, ' Time(s) '  ,'fontsize',16,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
 set(gca,'visible','off')
print(gcf, '-dtiff','-r500', [SupPlotPath 'SPL_Spectrogram2'])

%% CL1 spectrograms
Cluster1Chans = [1,3,27,28,29,33,44,50,52,53,57,58];

dataStruct = [];
dataStruct.time1 = stimData.epochTime;
dataStruct.time2 = RTData.epochTime;
dataStruct.col1  = [0.5 0.1 0.1];%[0.8 0.6 0.2];
dataStruct.col2  = [0.3 0.1 0.6];%[0.2 0.6 0.8];
dataStruct.freqs = stimData.Freqs;
dataStruct.Zlims = [-1.5 1.5];

figure(1); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[-1000,-400,1000,800]);

yPos        = [0.8 0.6 0.3 0.1];
height      = 0.19;
text_yPos   = yPos;

ha = [];

% data subplots
dataStruct.ylabel = ' Hits (dB) ';
X1H = squeeze(stimData.meanHits(Cluster1Chans,:,:));
X2H = squeeze(RTData.meanHits(Cluster1Chans,:,:));
dataStruct.data1 = squeeze(mean(X1H));
dataStruct.data2 = squeeze(mean(X2H));
ha{1} = subSpecPlot(dataStruct,[0.1 yPos(1) 0.85 height]);

dataStruct.ylabel = ' CRs (dB) ';
X1CRs = squeeze(stimData.meanCRs(Cluster1Chans,:,:));
X2CRs = squeeze(RTData.meanCRs(Cluster1Chans,:,:));
dataStruct.data1 = squeeze(mean(X1CRs));
dataStruct.data2 = squeeze(mean(X2CRs));
ha{2} = subSpecPlot(dataStruct,[0.1 yPos(2) 0.85 height]);

% colorbar
axes('position',[0.95 yPos(2) 0.05 height])
cb=colorbar;
set(cb,'position',[0.93 0.7 0.02 0.15])
set(cb,'CLim',[dataStruct.Zlims])
set(cb,'ytick',[1 50 102],'yticklabel',[dataStruct.Zlims(1) 0 dataStruct.Zlims(2)])
axis off

% save figure 1
SupPlotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ', 'Manuscript Figures/supplement/SpectogramPlots/'];
print(gcf, '-dtiff','-r500', [SupPlotPath 'CL1_Spectrogram1'])

% matlab doesn't accept different colormaps int the 
% same figure as of R2014a. using a different figure 
% the statisic.
figure(2); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[-1000,-400,1000,800]);

dataStruct.Zlims = [-5 5];
dataStruct.col1  = [0.8 0.6 0.2];
dataStruct.col2  = [0.2 0.6 0.8];
dataStruct.ylabel = ' T-Stat ';
[~,p1,~,t1]=ttest(X1H,X1CRs);
dataStruct.data1 = squeeze(t1.tstat);
[~,p2,~,t2]=ttest(X2H,X2CRs);
dataStruct.data2 = squeeze(t2.tstat);
% statistic subplot
ha{3} = subSpecPlot(dataStruct,[0.1 yPos(3) 0.85 height]);

% colorbar
axes('position',[0.95 yPos(1) 0.05 height])
cb=colorbar;
set(cb,'position',[0.93 0.32 0.02 0.15])
set(cb,'CLim',[dataStruct.Zlims])
set(cb,'ytick',[1 50 102],'yticklabel',[dataStruct.Zlims(1) 0 dataStruct.Zlims(2)])
axis off

% pvalue subplot
% get signs of 
Xsign = ones(size(dataStruct.data1));
Xsign(dataStruct.data1<0)=-1;
Ysign = ones(size(dataStruct.data2));
Ysign(dataStruct.data2<0)=-1;

dataStruct.Zlims = [-1 1];
dataStruct.col1  = [0.8 0.6 0.2];
dataStruct.col2  = [0.2 0.6 0.8];
dataStruct.ylabel = ' p-val < 0.05* ';

pValThr  = 0.15;
se          = [0 0 0; 1 1 1; 0 0 0];
% create mask for fdr correction
f = dataStruct.freqs; maskF = f<=180;
t1 = dataStruct.time1; maskT1 = t1>0;
t2 = dataStruct.time1; maskT2 = true(size(t2));

X = squeeze(p1);
X(~maskF,:) = 0; X(:,~maskT1) = 0;
X2 = X(maskF,maskT1);
X(maskF,maskT1) = reshape(mafdr(X2(:)),size(X2))<pValThr;
X = imerode(X,se);
X = X.*Xsign;

Y = squeeze(p2);
Y(~maskF,:) = 0; Y(:,~maskT2) = 0;
Y2 = Y(maskF,maskT2);
Y(maskF,maskT2) = reshape(mafdr(Y2(:)),size(Y2))<pValThr;
Y = imerode(Y,se);
Y = Y.*Ysign;

dataStruct.data1 = X;
dataStruct.data2 = Y;
% statistic subplot
ha{4} = subSpecPlot(dataStruct,[0.1 yPos(4) 0.85 height]);
set(ha{4}(1),'xticklabel',{'','stim','','0.4','','0.8',''})
set(ha{4}(2),'xticklabel',{'','-0.8','','-0.4','','resp',''})
axes('position', [0.1 0 0.85 0.1])
text(0.46,0.5, ' Time(s) '  ,'fontsize',16,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
 set(gca,'visible','off')
print(gcf, '-dtiff','-r500', [SupPlotPath 'CL1_Spectrogram2'])

%% CL2 spectrograms
Cluster2Chans = [13,17,43,45,56,60,61,63];

dataStruct = [];
dataStruct.time1 = stimData.epochTime;
dataStruct.time2 = RTData.epochTime;
dataStruct.col1  = [0.5 0.1 0.1];%[0.8 0.6 0.2];
dataStruct.col2  = [0.3 0.1 0.6];%[0.2 0.6 0.8];
dataStruct.freqs = stimData.Freqs;
dataStruct.Zlims = [-1.5 1.5];

figure(1); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[-1000,-400,1000,800]);

yPos        = [0.8 0.6 0.3 0.1];
height      = 0.19;
text_yPos   = yPos;

ha = [];

% data subplots
dataStruct.ylabel = ' Hits (dB) ';
X1H = squeeze(stimData.meanHits(Cluster2Chans,:,:));
X2H = squeeze(RTData.meanHits(Cluster2Chans,:,:));
dataStruct.data1 = squeeze(mean(X1H));
dataStruct.data2 = squeeze(mean(X2H));
ha{1} = subSpecPlot(dataStruct,[0.1 yPos(1) 0.85 height]);

dataStruct.ylabel = ' CRs (dB) ';
X1CRs = squeeze(stimData.meanCRs(Cluster2Chans,:,:));
X2CRs = squeeze(RTData.meanCRs(Cluster2Chans,:,:));
dataStruct.data1 = squeeze(mean(X1CRs));
dataStruct.data2 = squeeze(mean(X2CRs));
ha{2} = subSpecPlot(dataStruct,[0.1 yPos(2) 0.85 height]);

% colorbar
axes('position',[0.95 yPos(2) 0.05 height])
cb=colorbar;
set(cb,'position',[0.93 0.7 0.02 0.15])
set(cb,'CLim',[dataStruct.Zlims])
set(cb,'ytick',[1 50 102],'yticklabel',[dataStruct.Zlims(1) 0 dataStruct.Zlims(2)])
axis off

% save figure 1
SupPlotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ', 'Manuscript Figures/supplement/SpectogramPlots/'];
print(gcf, '-dtiff','-r500', [SupPlotPath 'CL2_Spectrogram1'])

% matlab doesn't accept different colormaps int the 
% same figure as of R2014a. using a different figure 
% the statisic.
figure(2); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[-1000,-400,1000,800]);

dataStruct.Zlims = [-5 5];
dataStruct.col1  = [0.8 0.6 0.2];
dataStruct.col2  = [0.2 0.6 0.8];
dataStruct.ylabel = ' T-Stat ';
[~,p1,~,t1]=ttest(X1H,X1CRs);
dataStruct.data1 = squeeze(t1.tstat);
[~,p2,~,t2]=ttest(X2H,X2CRs);
dataStruct.data2 = squeeze(t2.tstat);
% statistic subplot
ha{3} = subSpecPlot(dataStruct,[0.1 yPos(3) 0.85 height]);

% colorbar
axes('position',[0.95 yPos(1) 0.05 height])
cb=colorbar;
set(cb,'position',[0.93 0.32 0.02 0.15])
set(cb,'CLim',[dataStruct.Zlims])
set(cb,'ytick',[1 50 102],'yticklabel',[dataStruct.Zlims(1) 0 dataStruct.Zlims(2)])
axis off

% pvalue subplot
% get signs of 
Xsign = ones(size(dataStruct.data1));
Xsign(dataStruct.data1<0)=-1;
Ysign = ones(size(dataStruct.data2));
Ysign(dataStruct.data2<0)=-1;

dataStruct.Zlims = [-1 1];
dataStruct.col1  = [0.8 0.6 0.2];
dataStruct.col2  = [0.2 0.6 0.8];
dataStruct.ylabel = ' p-val < 0.05* ';

pValThr  = 0.15;
se          = [0 0 0; 1 1 1; 0 0 0];
% create mask for fdr correction
f = dataStruct.freqs; maskF = f<=180;
t1 = dataStruct.time1; maskT1 = t1>0;
t2 = dataStruct.time1; maskT2 = true(size(t2));

X = squeeze(p1);
X(~maskF,:) = 0; X(:,~maskT1) = 0;
X2 = X(maskF,maskT1);
X(maskF,maskT1) = reshape(mafdr(X2(:)),size(X2))<pValThr;
X = imerode(X,se);
X = X.*Xsign;

Y = squeeze(p2);
Y(~maskF,:) = 0; Y(:,~maskT2) = 0;
Y2 = Y(maskF,maskT2);
Y(maskF,maskT2) = reshape(mafdr(Y2(:)),size(Y2))<pValThr;
Y = imerode(Y,se);
Y = Y.*Ysign;

dataStruct.data1 = X;
dataStruct.data2 = Y;
% statistic subplot
ha{4} = subSpecPlot(dataStruct,[0.1 yPos(4) 0.85 height]);
set(ha{4}(1),'xticklabel',{'','stim','','0.4','','0.8',''})
set(ha{4}(2),'xticklabel',{'','-0.8','','-0.4','','resp',''})
axes('position', [0.1 0 0.85 0.1])
text(0.46,0.5, ' Time(s) '  ,'fontsize',16,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
 set(gca,'visible','off')
print(gcf, '-dtiff','-r500', [SupPlotPath 'CL2_Spectrogram2'])
