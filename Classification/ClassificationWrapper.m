function S = ClassificationWrapper(opts)
% this wrapper loads the appropiate data and sets parameters for
% classification

% dependencies:
%   getClassificationParams
%   balancedBootStrapIdx
%   ECoGClassify
%   calcBAC
%   class_perf_metrics

%% load data
data        = [];
dataPath    = '~/Documents/ECOG/Results/';
nSubjs      = 7;

switch opts.dataType
    case 'erp'
        opts.bands = {''};
        nBands      = 1;
        dataPath = [dataPath 'ERP_Data/group/'];
        fileName = ['allERPsGroup' opts.lockType 'LocksubAmp' ...
            opts.reference num2str(opts.nRefChans)];
        load([dataPath fileName])
        
        allData   = data.([opts.timeType 'ERP']);
    case 'power'
        dataPath    = [dataPath 'Spectral_Data/group/'];
        
        nBands      = numel(opts.bands);
        
        allData = cell(nSubjs,1);
        for band = 1:nBands
            
            if strcmp(opts.bands{band},'erp')                
                fileName = ['allERPsGroup' opts.lockType 'LocksubAmp' ...
                        opts.reference num2str(opts.nRefChans)];
                load(['~/Documents/ECOG/Results/ERP_Data/group/' fileName])
            else
                fileName = ['allERSPs' opts.bands{band} 'Group' opts.lockType  ...
                    'LocksublogPower' opts.reference num2str(opts.nRefChans)];
                load([dataPath fileName])
            end

            for s = 1:nSubjs
                allData{s}(:,:,:,band) = data.([opts.timeType 'ERP']){s};
            end
        end
end

%% set parameters

% this section deals with selecting the appropiate feature samples for
% decoding:
% WinSamps is the output of this section and it is a matrix of indexes that
% is of size nWin X nSamps;
switch opts.timeFeatures
    case 'window'
        nWin            = data.nBins;
        if strcmp(opts.timeType,'Bin')
            WinSamps    = eye(nWin)==1;
        else
            WinSamps    = data.BinSamps;
        end
    case 'trial'
        nWin            =  1;
        if strcmp(opts.timeType,'Bin')
            WinSamps    = (data.Bins(:,1)>=opts.timeLims(1) & data.Bins(:,2)<=opts.timeLims(2))';
        else
            WinSamps    = true(1,data.nTrialSamps);
        end
    otherwise
        error('not supported option for time feature')
end

% this section deals with the settings for the selections of channels
switch opts.channelGroupingType
    case 'channel'
        % this just means that the iterations are going to be every channel
        nChansSubjIter = data.nSubjLPCchans;
    case 'ROI'
        % selection based on roi's
        for s = 1:nSubjs
            nChansSubjIter(s) = numel(unique(data.ROIid(data.subjChans==s)));
        end
    case 'IPS-SPL'
        nChansSubjIter = ones(nSubjs,1);  
    case 'all'
        nChansSubjIter = ones(nSubjs,1);  
    otherwise
        error('not supported option for channel features')
end

%% wrapper section for the classification

% prepare structure classification settigns and output
S                       = [];
S.opts                  = opts;
S.classificationParams  = getClassificationParams(opts.toolboxNum);
S.extStr                = S.classificationParams.extStr;
S.ROIs                  = data.ROIs;
S.ROIid                 = data.ROIid(:);
S.hemChanId             = data.hemChanId(:);
S.subROIid              = data.subROIid(:);
S.subjChans             = data.subjChans(:);
S.Bins                  = data.Bins;

if strcmp( S.classificationParams.bootStrapData,'boot')
    nBoots      = S.classificationParams.nBoots;
    S.outDim    = {'subject','channel/roi','windows','bootstrap'};
    S.out       = cell(nSubjs,max(nChansSubjIter),nWin,nBoots);
    S.perf      = nan(nSubjs,max(nChansSubjIter),nWin,nBoots);
    S.model     = cell(nSubjs,max(nChansSubjIter),nWin);
    S.perfFA    = nan(nSubjs,max(nChansSubjIter),nWin);
    S.perfMISS  = nan(nSubjs,max(nChansSubjIter),nWin);
    
else
    S.outDim    = {'subject','channel/roi','windows'};
    S.out       = cell(nSubjs,max(nChansSubjIter),nWin);
    S.perf      = nan(nSubjs,max(nChansSubjIter),nWin);
    S.model     = cell(nSubjs,max(nChansSubjIter),nWin);
end

for s = 1:nSubjs
    trials      = data.Hits{s} | data.CRs{s};
    Y           = data.Hits{s}; Y = Y(trials); % 1 for hits, 0 for CRs
    trials2     = data.FA  {s} | data.Miss{s};
    Y2          = data.FA  {s}; Y2 = Y2(trials2); % 1 for fa, 0 for miss
    
    nFA = sum(Y2==1);
    nMI = sum(Y2==0);
    
    nFolds          = S.classificationParams.nFolds;
    nSubsetTrials   = floor(S.classificationParams.PctTrials*numel(Y));
    nSubsetTrials   = 2*round(nSubsetTrials/2);
    
    S.trials{s}     = trials;
    S.sY{s}          = Y;
    %S.BootIdxMat{s} = balancedBootStrapIdx(nBoots,nSubsetTrials,nFolds,find(Y==1),find(Y==0));
    [S.testIdx{s}, S.testFoldIdx{s}, S.trainFoldIdx{s}]  = balancedBootStrapXVal(nBoots, ...
        nSubsetTrials,nFolds,find(Y==1),find(Y==0));

    for chanIter = 1:nChansSubjIter(s)
        
        fprintf( 'Classifying Subject %d Channel %d \n',s,chanIter)
        
        % channel indexes per subject
        switch opts.channelGroupingType
            case 'channel'
                chIdx = chanIter;
            case 'ROI'
                chIdx = find(data.ROIid(data.subjChans==s)==chanIter);
            case 'IPS-SPL'
                chIdx = find(data.ROIid(data.subjChans==s)==1|data.ROIid(data.subjChans==s)==2);
            case 'all'
                chIdx = 1:data.nSubjLPCchans(s);
        end
        
        for winIter = 1:nWin
            
            X       = selectData(trials);
            X2      = selectData(trials2);
            
            % check that the dimensions make sense
            nTrials     = sum(trials);
            nChans      = numel(chIdx); nSamps = sum(WinSamps(winIter,:));
            nFeatures   = nChans*nSamps*nBands;
            
            assert(nTrials   == size(X,1) ,'number of trials did not match');
            assert(nFeatures == size(X,2) ,'number of features did not match');
            
            S.X = X;
            S.Y = Y;
            
            % classify
            if strcmp( S.classificationParams.bootStrapData,'boot')
                mean_model = nan(nBoots,nFeatures+1);
                %if s==2 && chanIter == 1; keyboard; end;
                for bs = 1:nBoots;
                    S_in         = S;
                    
                    S_in.BootTestIdx  = S.testIdx{s}(:,bs);
                    S_in.BootTestFoldIdx  = S.testFoldIdx{s}(:,:,bs);
                    S_in.BootTrainFoldIdx = S.trainFoldIdx{s}(:,:,bs);
                    %S_in.X       = X(S.BootIdxMat{s}(:,bs),:);
                    %S_in.Y       = Y(S.BootIdxMat{s}(:,bs));
                    
                    S.out{s,chanIter,winIter,bs}    = ECoGClassify(S_in);
                    S.out{s,chanIter,winIter,bs}.Y  = Y(S_in.BootTestIdx);
                    S.perf(s,chanIter,winIter,bs)   = calcBAC(1,0,Y(S_in.BootTestIdx)==1,S.out{s,chanIter,winIter,bs}.predictions==1);
                    
                    if strcmp(S.classificationParams.toolbox,'liblinear') || strcmp(S.classificationParams.toolbox,'glmnet')
                        if nFeatures > 1
                            %mean_model(bs,:) = median(zscore(S.out{s,chanIter,winIter,bs}.weights(:,1:nFeatures),[],2));
                            mean_model(bs,:) = mean(S.out{s,chanIter,winIter,bs}.weights);
                        else
                            mean_model(bs,:) = mean(S.out{s,chanIter,winIter,bs}.weights);
                        end
                        
                        S.perfFA(s,chanIter,winIter,bs)   = sum((Y2==1) & ([X2 ones(nFA+nMI,1)]*mean_model(bs,:)'>=0) )/nFA;
                        S.perfMISS(s,chanIter,winIter,bs) = sum((Y2==0) & ([X2 ones(nFA+nMI,1)]*mean_model(bs,:)'< 0) )/nMI;
                    end
                end
                if strcmp(S.classificationParams.toolbox,'liblinear') || strcmp(S.classificationParams.toolbox,'glmnet')
                    S.model{s,chanIter,winIter} = median(mean_model(:,1:nFeatures));
                end
            else
                S_in.X = X;
                S_in.Y = Y;
                S.out{s,chanIter,winIter}   = ECoGClassify(S_in);
                S.perf{s,chanIter,winIter}  = class_perf_metrics(Y == 1,S.out.predictions == 1);
            end
        end
    end
end

%% supplementary functions


    function x = selectData(trials)
        % function that selects data from the big cell matrix
        x = allData{s}(chIdx,trials,WinSamps(winIter,:),:);
        
        if (S.classificationParams.normalizeTrials)
            % normalize independently for each channel/trial and band
            x = zscore(x,0,3);
        end
        
        % reformate data such that it is nTrial X nFeatures
        x = permute(x(:,:,:),[2,1,3]);
        x = x(:,:);
    end

end