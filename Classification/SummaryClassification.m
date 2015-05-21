
function data = SummaryClassification(data,opts)
% data = SummaryClassification(data,opts)
% function that groups the decoding results

% limits for random chance adjustment;
a= 0.49; b = 0.51;

nBoots      = data.classificationParams.nBoots;
nSubjs      = 8;
nFeatures   = size(data.X,2)*numel(data.opts.bands);

% load univariate data for reference
dataPath = '~/Documents/ECOG/Results/Spectral_Data/group/';
fileName = ['allERSPshgamGroup' opts.lockType 'LocksublogPowernonLPCleasL1TvalCh10'];
temp = load([dataPath fileName]);

% channels IDs
data.ROIs       = temp.data.ROIs;
data.ROIid      = temp.data.ROIid(:);
data.hemChanId  = temp.data.hemChanId(:);
data.subROIid   = temp.data.subROIid(:);
data.subjChans  = temp.data.subjChans(:);
data.Bins       = temp.data.Bins;
data.RTs        = temp.data.RTs;

switch opts.timeFeatures
    case 'window'
        nWin = size(data.Bins,1);
    case 'trial'
        nWin = 1;
    otherwise
        error('not supported option for channel features')
end

switch opts.channelGroupingType
    case 'channel'
        nChans = numel(data.ROIid);
    case 'ROI'
        error('this is not really usefull to summarize')
    case 'all'
        error('this is not really usefull to summarize')
    otherwise
        error('not supported option for channel features')
end

data.mBAC   = nan(nChans,nWin);
data.pBAC   = nan(nChans,nWin);
data.cBAC   = nan(nChans,nWin);
data.meBAC  = nan(nChans,nWin);
data.sdBAC  = nan(nChans,nWin);
data.mZBAC  = nan(nChans,nWin);
data.meZBAC = nan(nChans,nWin);

nConfPoints     = 9;
data.confPoints = linspace(0.1,0.9,nConfPoints);

data.ACbyConf      = nan(nChans,nWin,3,nConfPoints);
data.mHsACbyConf   = nan(nChans,nWin,nConfPoints);
data.sdHsACbyConf  = nan(nChans,nWin,nConfPoints);
data.mCRsACbyConf  = nan(nChans,nWin,nConfPoints);
data.sdCRsACbyConf = nan(nChans,nWin,nConfPoints);

% incorrect trial performance; higher means
data.FAmeBAC        = nan(nChans,nWin);
data.MISSmeBAC      = nan(nChans,nWin);
data.FAmeZBAC       = nan(nChans,nWin);
data.MISSmeZBAC     = nan(nChans,nWin);

data.chModel        = nan(nChans,nWin,nFeatures);


if opts.toolboxNum==3
    data.lambdas    = data.classificationParams.options.lambda;
    data.nLambda    = numel(data.lambdas);
    data.elModel    = nan(nChans,nWin,nFeatures,data.nLambda);
    data.elCntModel = nan(nChans,nWin,nFeatures,data.nLambda);
end

mH_AC               = nan(nChans,nWin,nBoots);
mCRs_AC             = nan(nChans,nWin,nBoots);
RTsLogitCorr        = nan(nChans,nWin,nBoots);
RTsLogitCorrH       = nan(nChans,nWin,nBoots);
RTsLogitCorrCRs     = nan(nChans,nWin,nBoots);

RTsLogitCorrH_correct       = nan(nChans,nWin,nBoots);
RTsLogitCorrCRs_correct     = nan(nChans,nWin,nBoots);

ChCount = 0;
for s =1:nSubjs
    nSubjChans  = sum(data.subjChans==s);
    rts         = log10(data.RTs{s}(data.trials{s}));
    
    nTrials     = sum(data.trials{s});    
    for ch = 1:nSubjChans
        ChCount = ChCount +1;
        
        y   = data.perf(s,ch,:,:);
        y2  = data.perfFA(s,ch,:,:);
        y3  = data.perfMISS(s,ch,:,:);
        
        for bi = 1:nWin
               
            x           = squeeze(squeeze(y(:,:,bi,:)));
            [m,me,sd]   = grpstats(x,[],{'mean','median','std'});
            [~,p]       = ttest(x,0.5,0.05,'right');
            
            
            data.mBAC(ChCount,bi)    = m;
            data.pBAC(ChCount,bi)    = p;
            data.qBAC(ChCount,bi,:)  = quantile(x,[0.025,0.5 0.975]);
            data.cBAC(ChCount,bi)    = mean(x>0.5);
            data.meBAC(ChCount,bi)   = me;
            data.sdBAC(ChCount,bi)   = sd;
            data.mZBAC(ChCount,bi)   = (m-0.5) /sd;
            data.meZBAC(ChCount,bi)  = (me-0.5)/sd;
            
            if opts.toolboxNum~=4
                
                data.chModel(ChCount,bi,:) = data.model{s,ch,bi};
                
                % false alarms
                x        =squeeze(squeeze(y2(:,:,bi,:)));
                [m,me,sd]=grpstats(x,[],{'mean','median','std'});
                data.FAmBAC(ChCount,bi)    = m;
                data.FAsdBAC(ChCount,bi)   = sd;
                data.FAmeBAC(ChCount,bi)   = me;
                data.FAmZBAC(ChCount,bi)   = (m-0.5) /sd;
                data.FAmeZBAC(ChCount,bi)  = (me-0.5)/sd;
                
                % misses
                x        =squeeze(squeeze(y3(:,:,bi,:)));
                [m,me,sd]=grpstats(x,[],{'mean','median','std'});
                data.MISSmBAC(ChCount,bi)    = m;
                data.MISSmeBAC(ChCount,bi)   = me;
                data.MISSsdBAC(ChCount,bi)   = sd;
                data.MISSmZBAC(ChCount,bi)   = (m-0.5) /sd;
                data.MISSmeZBAC(ChCount,bi)  = (me-0.5)/sd;
                
                
                if opts.toolboxNum==3
                    model = nan(nFeatures,data.nLambda);
                end
                % correlate logits and RTs
                %if ChCount == 4; keyboard;end
                
                probBootMat = nan(nTrials,nBoots);
                for boot = 1:nBoots
                    bIds    = data.testIdx{s}(:,boot);
                    r1      = rts(bIds);
                    
                    probBootMat(bIds,boot) = data.out{s,ch,bi,boot}.probEst+0.5;
                    x                   = probBootMat(bIds,boot);                    
                    
                    % deal with chance x at random.
                    CxId    = x==0.5; nCx = sum(CxId);
                    x(CxId) = a + (b-a)*rand(nCx,1);
                    
                    yb      = data.out{s,ch,bi,boot}.Y;
                    
                    xPos    = x > 0.5;
                    xNeg    = x < 0.5;
                    mH_AC(ChCount,bi,boot)      = mean(xPos(yb==1));
                    mCRs_AC(ChCount,bi,boot)    = mean(xNeg(yb==0));
                    
                    % adjust for numerical errors:
                    x(x<=0) = eps;
                    x(x>=1) = 1-eps;
                    
                    % convert probabilities to logits
                    xL      = log(x./(1-x));
                    
                    RTsLogitCorr(ChCount,bi,boot)       = corr(abs(xL),r1,'type','spearman');
                    RTsLogitCorrH(ChCount,bi,boot)      = corr(xL(yb==1),r1(yb==1),'type','spearman');
                    RTsLogitCorrCRs(ChCount,bi,boot)    = corr(xL(yb==0),r1(yb==0),'type','spearman');
                    
                    if sum(yb==1 & xPos ) >= 4
                        RTsLogitCorrH_correct(ChCount,bi,boot)      = corr(xL(yb==1 & xPos),r1(yb==1 & xPos));
                    else
                        RTsLogitCorrH_correct(ChCount,bi,boot)      = 0;
                    end
                    if sum(yb==0 & xNeg ) >= 4
                        RTsLogitCorrCRs_correct(ChCount,bi,boot)   = corr(xL(yb==0 & xNeg),r1(yb==0 & xNeg));
                    else
                        RTsLogitCorrCRs_correct(ChCount,bi,boot)  = 0;
                    end
                    
                    if opts.toolboxNum==3
                        model(:,:,boot) = data.out{s,ch,bi,boot}.betasPath';
                    end         
                end
                
                [acc1, acc0, accT]     = accByConf(probBootMat,data.sY{s}, data.confPoints);
                
                data.ACbyConf(ChCount,bi,:,:)      = quantile(accT,[0.025 0.5 0.975],1);
                data.mHsACbyConf(ChCount,bi,:)     = nanmean(acc1);
                data.sdHsACbyConf(ChCount,bi,:)    = nanstd(acc1);
                data.mCRsACbyConf(ChCount,bi,:)    = nanmean(acc0);
                data.sdCRsACbyConf(ChCount,bi,:)   = nanstd(acc0);
                
                if opts.toolboxNum==3
                    data.elModel(ChCount,bi,:,:)    = median(model,3);
                    data.elCntModel(ChCount,bi,:,:) = mean(model~=0,3);
                end
            end
            
        end
    end
end

if opts.toolboxNum~=4
    data.mH_AC              = nanmean(mH_AC,3);
    data.mCRs_AC            = nanmean(mCRs_AC,3);
    data.RTsLogitCorr       = nanmedian(RTsLogitCorr,3);
    data.RTsLogitCorrH      = nanmedian(RTsLogitCorrH,3);
    data.RTsLogitCorrCRs    = nanmedian(RTsLogitCorrCRs,3);
    
    data.RTsLogitCorrH_correct      = nanmedian(RTsLogitCorrH_correct,3);
    data.RTsLogitCorrCRs_correct    = nanmedian(RTsLogitCorrCRs_correct,3);
end