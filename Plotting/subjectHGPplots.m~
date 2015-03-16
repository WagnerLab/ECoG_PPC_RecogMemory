% load  hgam data
dataPath ='../Results/Spectral_Data/group/';
fileName = 'allERSPshgamGroupstimLocksublogPowernonLPCleasL1TvalCh10';
load([dataPath fileName])
dataStim = data;

fileName = 'allERSPshgamGroupRTLocksublogPowernonLPCleasL1TvalCh10';
load([dataPath fileName])
dataRT = data;

%% analysis 1
% plotting by subject.
IPSch = dataStim.hemChanId==1 & dataStim.ROIid==1;
SPLch = dataStim.hemChanId==1 & dataStim.ROIid==2;

subjectsIds = 1:5; nSubjs = numel(subjectsIds);
IPS_subjCh = false(numel(IPSch),nSubjs);
SPL_subjCh = false(numel(SPLch),nSubjs);

% get subject channels
for ii = 1:nSubjs
    IPS_subjCh(:,ii) = IPSch & (dataStim.subjChans==subjectsIds(ii))';
    SPL_subjCh(:,ii) = SPLch & (dataStim.subjChans==subjectsIds(ii))';
end

% get subject level statititcs
IPS_Data = cell(nSubjs,2,2); % subj, stim/RT, hit/CR
SPL_Data = cell(nSubjs,2,2);


for ii = 1:nSubjs
    IPS_Data{ii,1,1} = dataStim.mHits(IPS_subjCh(:,ii),:);
    IPS_Data{ii,2,1} = dataRT.mHits(IPS_subjCh(:,ii),:);
    IPS_Data{ii,1,2} = dataStim.mCRs(IPS_subjCh(:,ii),:);
    IPS_Data{ii,2,2} = dataRT.mCRs(IPS_subjCh(:,ii),:);
    
    SPL_Data{ii,1,1} = dataStim.mHits(SPL_subjCh(:,ii),:);
    SPL_Data{ii,2,1} = dataRT.mHits(SPL_subjCh(:,ii),:);
    SPL_Data{ii,1,2} = dataStim.mCRs(SPL_subjCh(:,ii),:);
    SPL_Data{ii,2,2} = dataRT.mCRs(SPL_subjCh(:,ii),:);
end

%%
% IPS plots
figure(1); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[-1000,200,1000,750]);

yPos         = [0.78 0.61 0.44 0.27 0.1];
height       = 0.16;
text_yPos   = yPos;

dataStruct = [];
dataStruct.time{1}    = dataStim.trialTime;
dataStruct.time{2}    = dataRT.trialTime;
dataStruct.barPlotLims{1} = dataStim.trialTime>=0.4     & dataStim.trialTime<=0.7;
dataStruct.barPlotLims{2} = dataRT.trialTime>=-0.5     & dataRT.trialTime<=-0.2;
dataStruct.yLimits = [-1.2 2.5];

ha =[];
for ii = 1:5
    dataStruct.data1{1} =   dataStim.mHits(IPS_subjCh(:,ii),:);
    dataStruct.data1{2} =   dataStim.mCRs(IPS_subjCh(:,ii),:);
    dataStruct.data2{1} =   dataRT.mHits(IPS_subjCh(:,ii),:);
    dataStruct.data2{2} =   dataRT.mCRs(IPS_subjCh(:,ii),:);
    ha{ii} = subPlotsForSubjectFigures(dataStruct,[0.1 yPos(ii) 0.9 height]);
    
    axes('position', [ 0,text_yPos(ii),0.1,0.21])
    text(0.6,0.5, ['s_' num2str(ii)] ,'fontsize',16,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
    set(gca,'visible','off')
end
axes('position',[0 0.5 0.1 0.1])
text(0.2,0.5, [' IPS HGP (dB)' ] ,'fontsize',18,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle','rotation',90)
    set(gca,'visible','off')

set(ha{5}(1), 'xticklabel',{'','stim','','0.4','','0.8',''})
set(get(ha{5}(2),'xlabel'),'string','  0.3 to 0.7s','fontSize',13)
set(get(ha{5}(3),'xlabel'),'string','  -0.5 to -0.3s','fontSize',13)
set(ha{5}(4), 'xticklabel',{'','-0.8','','-0.4','','resp',''})

axes('position', [ 0.44 0, 0.2 ,0.1])
    text(0.5,0.3, ' Time (s) ' ,'fontsize',16,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
set(gca,'visible','off')
drawnow 

inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';
SupPlotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ', 'Manuscript Figures/supplement/'];

cPath = pwd;
cd(SupPlotPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

filename = 'sFig_SubjectsIPS-HGP';
plot2svg([filename '.svg'],gcf)
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
eval(['! rm ' filename '.svg'])
cd(cPath)

%%
% SPL plots
figure(2); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[-1000,200,1000,600]);

yPos         = [0.77 0.55 0.33 0.1];
height       = 0.21;
text_yPos   = yPos;

dataStruct = [];
dataStruct.time{1}    = dataStim.trialTime;
dataStruct.time{2}    = dataRT.trialTime;
dataStruct.barPlotLims{1} = dataStim.trialTime>=0.6     & dataStim.trialTime<=0.9;
dataStruct.barPlotLims{2} = dataRT.trialTime>=-0.3     & dataRT.trialTime<=0;
dataStruct.yLimits = [-1.2 2.5];

ha =[];
subjs = [1 3 4 5];
for ii = 1:numel(subjs)
    dataStruct.data1{1} =   dataStim.mHits(SPL_subjCh(:,subjs(ii)),:);
    dataStruct.data1{2} =   dataStim.mCRs(SPL_subjCh(:,subjs(ii)),:);
    dataStruct.data2{1} =   dataRT.mHits(SPL_subjCh(:,subjs(ii)),:);
    dataStruct.data2{2} =   dataRT.mCRs(SPL_subjCh(:,subjs(ii)),:);
    ha{ii} = subPlotsForSubjectFigures(dataStruct,[0.1 yPos(ii) 0.9 height]);
        
    axes('position', [ 0,text_yPos(ii),0.1,0.21])
    text(0.6,0.5, ['s_' num2str(subjs(ii))] ,'fontsize',16,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
    set(gca,'visible','off')
end
axes('position',[0 0.5 0.1 0.1])
text(0.2,0.5, [' SPL HGP (dB)' ] ,'fontsize',18,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle','rotation',90)
    set(gca,'visible','off')

set(ha{4}(1), 'xticklabel',{'','stim','','0.4','','0.8',''})
set(get(ha{4}(2),'xlabel'),'string','  0.6 to 0.9s','fontSize',13)
set(get(ha{4}(3),'xlabel'),'string','  -0.3s to resp','fontSize',13)
set(ha{4}(4), 'xticklabel',{'','-0.8','','-0.4','','resp',''})

axes('position', [ 0.44 0, 0.2 ,0.1])
    text(0.5,0.3, ' Time (s) ' ,'fontsize',16,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
set(gca,'visible','off')
drawnow 

inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';
SupPlotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ', 'Manuscript Figures/supplement/'];

cPath = pwd;
cd(SupPlotPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

filename = 'sFig_SubjectsSPL-HGP';
plot2svg([filename '.svg'],gcf)
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
eval(['! rm ' filename '.svg'])
cd(cPath)
%%  find subject cluster channels for plotting
%Cluster1Chans = [1,3,27,28,29,33,44,50,52,53,57,58];
Cluster1Chans = [1,3,27,28,29,33,44,50,52,53,57,58,59,76];
%Cluster2Chans = [13,17,43,45,56,60,61,63];
Cluster2Chans = [13,17,43,45,56,60,61,63,78,79];

subjCl1Chans = [];
subjCl2Chans = [];
for ii=1:5;
    temp = intersect(find(dataStim.subjChans==ii),Cluster1Chans);
    [~,id]=intersect(find(dataStim.subjChans==ii),temp);
    subjCl1Chans{ii} = id;
    temp = intersect(find(dataStim.subjChans==ii),Cluster2Chans);
    [~,id]=intersect(find(dataStim.subjChans==ii),temp);
    subjCl2Chans{ii} = id;
end

%% Cluster1 plots by selecting one subject channel 

figure(1); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[-1000,200,1000,600]);

yPos         = [0.78 0.61 0.44 0.27 0.1];
height       = 0.16;
text_yPos   = yPos;

dataStruct = [];
dataStruct.time{1}    = dataStim.trialTime;
dataStruct.time{2}    = dataRT.trialTime;
dataStruct.barPlotLims{1} = dataStim.trialTime>=0.4     & dataStim.trialTime<=0.7;
dataStruct.barPlotLims{2} = dataRT.trialTime>=-0.5     & dataRT.trialTime<=-0.2;
dataStruct.yLimits = [-2 4];
dataStruct.yTick = [-2 -1 0 1 2 3 4];

ha =[];
chansToPlot = [1,4,1,3,1];

for ii = 1:5
   % get trials and channel ID on subject structure
    H = dataStim.Hits{ii}; CRs = dataStim.CRs{ii};
    subjChanId = subjCl1Chans{ii}(chansToPlot(ii));

    dataStruct.data1{1} =   squeeze(dataStim.ERP{ii}(subjChanId,H,:));
    dataStruct.data1{2} =   squeeze(dataStim.ERP{ii}(subjChanId,CRs,:));
    dataStruct.data2{1} =   squeeze(dataRT.ERP{ii}(subjChanId,H,:));
    dataStruct.data2{2} =   squeeze(dataRT.ERP{ii}(subjChanId,CRs,:));
    ha{ii} = subPlotsForSubjectFigures(dataStruct,[0.1 yPos(ii) 0.9 height]);
    
    axes('position', [ 0,text_yPos(ii),0.1,0.21])
    text(0.6,0.5, ['s_' num2str(ii)] ,'fontsize',16,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
    set(gca,'visible','off')
end
axes('position',[0 0.5 0.1 0.1])
text(0.2,0.5, [' CL1 HGP (dB)' ] ,'fontsize',18,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle','rotation',90)
    set(gca,'visible','off')

set(ha{5}(1), 'xticklabel',{'','stim','','0.4','','0.8',''})
set(get(ha{5}(2),'xlabel'),'string','  0.3 to 0.7s','fontSize',13)
set(get(ha{5}(3),'xlabel'),'string','  -0.5 to -0.3s','fontSize',13)
set(ha{5}(4), 'xticklabel',{'','-0.8','','-0.4','','resp',''})

axes('position', [ 0.44 0, 0.2 ,0.1])
    text(0.5,0.3, ' Time (s) ' ,'fontsize',16,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
set(gca,'visible','off')
drawnow 

inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';
SupPlotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ', 'Manuscript Figures/supplement/'];

cPath = pwd;
cd(SupPlotPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

filename = 'sFig_SubjectsCL1-HGP';
plot2svg([filename '.svg'],gcf)
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
eval(['! rm ' filename '.svg'])
cd(cPath)

%% Cluster2 plots by selecting one subject channel 

figure(2); clf; 
set(gcf,'paperpositionmode','auto','color','white')
set(gcf,'position',[-1000,200,1000,600]);

yPos         = [0.77 0.55 0.33 0.1];
height       = 0.21;
text_yPos   = yPos;


dataStruct = [];
dataStruct.time{1}    = dataStim.trialTime;
dataStruct.time{2}    = dataRT.trialTime;
dataStruct.barPlotLims{1} = dataStim.trialTime>=0.6     & dataStim.trialTime<=0.9;
dataStruct.barPlotLims{2} = dataRT.trialTime>=-0.3     & dataRT.trialTime<=0;
dataStruct.yLimits = [-2.5 6];
dataStruct.yTick = [-2 -1 0 1 2 3 4];

ha =[];
chansToPlot = [1,0,2,3,1];

subjs = [1 3 4 5];
for ii = 1:numel(subjs)
   % get trials and channel ID on subject structure
    H = dataStim.Hits{subjs(ii)}; CRs = dataStim.CRs{subjs(ii)};
    subjChanId = subjCl2Chans{subjs(ii)}(chansToPlot(subjs(ii)));

    dataStruct.data1{1} =   squeeze(dataStim.ERP{subjs(ii)}(subjChanId,H,:));
    dataStruct.data1{2} =   squeeze(dataStim.ERP{subjs(ii)}(subjChanId,CRs,:));
    dataStruct.data2{1} =   squeeze(dataRT.ERP{subjs(ii)}(subjChanId,H,:));
    dataStruct.data2{2} =   squeeze(dataRT.ERP{subjs(ii)}(subjChanId,CRs,:));
    ha{ii} = subPlotsForSubjectFigures(dataStruct,[0.1 yPos(ii) 0.9 height]);
    
    axes('position', [ 0,text_yPos(ii),0.1,0.21])
    text(0.6,0.5, ['s_' num2str(subjs(ii))] ,'fontsize',16,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
    set(gca,'visible','off')
end
axes('position',[0 0.5 0.1 0.1])
text(0.2,0.5, [' CL2 HGP (dB)' ] ,'fontsize',18,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle','rotation',90)
    set(gca,'visible','off')

set(ha{4}(1), 'xticklabel',{'','stim','','0.4','','0.8',''})
set(get(ha{4}(2),'xlabel'),'string','  0.6 to 0.9s','fontSize',13)
set(get(ha{4}(3),'xlabel'),'string','  -0.3s to resp','fontSize',13)
set(ha{4}(4), 'xticklabel',{'','-0.8','','-0.4','','resp',''})

axes('position', [ 0.44 0, 0.2 ,0.1])
    text(0.5,0.3, ' Time (s) ' ,'fontsize',16,'HorizontalAlignment','center', ...
        'VerticalAlignment','middle')
set(gca,'visible','off')
drawnow 

inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';
SupPlotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ', 'Manuscript Figures/supplement/'];

cPath = pwd;
cd(SupPlotPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

filename = 'sFig_SubjectsCL2-HGP';
plot2svg([filename '.svg'],gcf)
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
eval(['! rm ' filename '.svg'])
cd(cPath)

