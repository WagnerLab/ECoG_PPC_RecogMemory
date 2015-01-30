function data = getAvgSpectrogram(data)
% function that epochs the continuous spectrograms
% and aggregates information behavioral information
% plus simple univariate statistics

% add behavioral data
behavdatapath = ['~/Documents/ECOG/Results/BehavData/Subj' data.subjnum];
load([behavdatapath 'behav_perf.mat']);
data.behavior = behav_perf;

% get bad trials:
data.nTrials    = numel(data.EventSamps);
temp 			= subjExptInfo(data.subjnum,data.expt, data.reReferencing);
badtrials 		= temp.badtrials ;

goodtrials 				= true(data.nTrials,1);
goodtrials(badtrials) 	= false;
goodtrials(isnan(data.behavior.allRTs)) = false;
data.goodTrials 		= goodtrials;

% store the corresponding roi channel ids in data struct.
data.rois       = data.chanInfo;

% spectrogram samplint rate, and epoch limits
data.SpecSR 		= 1./mean(diff(data.Time));

switch  data.lockType
    case 'stim'
        data.epochLims   	= [-0.2 1]; % in seconds
        data.baseLine 		= [-0.2 0];
        offset                  = zeros(data.nTrials,1);
    case 'RT'
        data.epochLims  	= [-1 0.2]; % in seconds
        % baseline comes from stim-locked data
        offset 				= round(data.behavior.allRTs*data.SpecSR);
end

data.epochLimsSamps = round(data.epochLims*data.SpecSR);

% normalize and get the trialSpectrogram
[data.Power,data.avgChanPower]   = normalizeSpectrogram(data.Power);
data.trialSpectrogram                   = epochSpectrogram(data.Power,data.EventSamps+offset,data.epochLimsSamps);
data.Power                                  =[];

% convert to log-scale
data.trialSpectrogram 			= 10*log10(data.trialSpectrogram);

data.nEpSamps = diff(data.epochLimsSamps)+1;
data.epochTime 	= linspace(data.epochLims (1),data.epochLims(2),...
    data.nEpSamps);

% Correct for baseline fluectuations before trial onset. In case of RT
% locked analysis, it uses the baselines from the stim locked (loaded outside)
if strcmp(data.lockType,'stim')
    baselineIdx = (data.epochTime>= data.baseLine(1)) & (data.epochTime<=data.baseLine(2)) ;
    data.baseLineMeans = nanmean(data.trialSpectrogram(:,:,:,baselineIdx),4);
end

% baseline correct by channel, frequency and trial.
data.nFreqs = numel(data.Freqs);
for ii = 1:data.nChans
    for jj = 1:data.nFreqs
        for kk = 1:data.nTrials
            data.trialSpectrogram(ii,jj,kk,:) = data.trialSpectrogram(ii,jj,kk,:)-data.baseLineMeans(ii,jj,kk);
        end
    end
end

% Separate trials based on condition
data.Hits 	= data.behavior.hits	 & data.goodTrials;
data.CRs 	= data.behavior.cr & data.goodTrials ;

% get across trial statistics per channel/band by condition
stats = {'mean','median','num','std', 'tStat','signRankP'};
conds = {'Hits','CRs'};

fprintf('getting univariate stats by condition \n')
for ss = 1:numel(stats)
    for cc = 1:numel(conds)
        if strcmp(stats{ss},'tStat')
            [data.([stats{ss} conds{cc}]), data.([stats{ss} 'Pval' conds{cc}])] = ...
                getOneSampStat(data.trialSpectrogram(:,:,data.(conds{cc}),:),stats{ss},3);
        else
            data.([stats{ss} conds{cc}]) = getOneSampStat ...
                (data.trialSpectrogram(:,:,data.(conds{cc}),:),stats{ss},3);
        end
    end
end

% get across conditions statitiscis
fprintf('getting univariate stats across conditions \n')
stats = {'tStat','ranksSum'};
for ss = 1:numel(stats)
    data.(['H_CRs' stats{ss}]) = zeros(data.nChans,data.nFreqs,data.nEpSamps); 
    data.(['H_CRs' stats{ss} 'Pval']) = zeros(data.nChans,data.nFreqs,data.nEpSamps); 
end

for ii = 1:data.nChans
    for jj = 1:data.nFreqs
        X = squeeze(data.trialSpectrogram(ii,jj,data.Hits,:));
        Y = squeeze(data.trialSpectrogram(ii,jj,data.CRs,:));        
        for ss = 1:numel(stats)            
            [data.(['H_CRs' stats{ss}])(ii,jj,:), data.(['H_CRs' stats{ss} 'Pval'])(ii,jj,:)] = ...
                getTwoSampStat(X,Y,stats{ss});
        end
    end
end

end % end the main function

% auxiliary internal functions
function [out1,out2] = getOneSampStat(X,stat,dim)
out2 = [];
switch stat
    case 'mean'
        out1 = squeeze(nanmean(X,dim));
    case 'median'
        out1 = squeeze(nanmedian(X,dim));
    case 'num'
        out1 = size(X,dim);
    case 'std'
        out1  = squeeze(nanstd(X,[],dim));
    case 'tStat'
        if dim==3
            out1 = zeros(size(X,1),size(X,2),size(X,4));
            out2 = zeros(size(X,1),size(X,2),size(X,4));
            for ii = 1:size(X,1)
                for jj = 1:size(X,2)
                    [~, a2,~, a4]  = ttest(squeeze(X(ii,jj,:,:)));
                    out1(ii,jj,:) = a4.tstat;
                    out2(ii,jj,:) = a2;
                end
            end
        else
            error('cannot get tstat on that dimension')
        end
    case 'signRankP'
        if dim==3
            out1 = zeros(size(X,1),size(X,2),size(X,4));
            for ii = 1:size(X,1)
                for jj = 1:size(X,2)
                    for kk = 1:size(X,4)
                        p  = signrank(squeeze(X(ii,jj,:,kk)));
                        out1(ii,jj,kk) = p;
                    end
                end
            end
        else
            error('cannot get tPval on that dimension')
        end
    otherwise
        error('not an option');
end
end % end getOneSampStat

function [statVal,statPVal] = getTwoSampStat(X,Y,stat)

switch stat
    case 'tStat'
        [~, a2, ~, a4]  = ttest2(X,Y);
        statVal = a4.tstat;
        statPVal = a2;
        
    case 'ranksSum'
        [a1, a2]  = ranksum2(X,Y);
        statPVal = a1;
        statVal = a2;
    otherwise
        error('not an option ');
end
end  % end getTwoSampStat

