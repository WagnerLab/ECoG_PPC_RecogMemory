function data=reReferenceData(data, reReference, nRefChans)
% function that reReferences the data.
% nRefChans gets overwritten to zero if the re referencing doesn't need
% that parameter.
%
% no file dependencies.
% data should be the output of preProcessRawData.m

data.reReferencing = reReference; %{'allChCAR','LPCChCAR','origCAR'}
%% Decompose channels and save
refChan = data.chanInfo.refChannel; data.refChan = refChan;

% common averagening
switch data.reReferencing
    case 'LPCChCAR'
        data.nRefChans = 0;
        CARch = data.chanInfo.LPC;
    case 'allChCAR'
        data.nRefChans = 0;
        CARch = data.chanInfo.CARChannels;
    case 'nonLPCCh'
        data.nRefChans = 0;
        CARch = data.chanInfo.other;
    case 'nonLPCleastVarCh'
        data.nRefChans = nRefChans;
        % sort by variance
        data.chanVar = var(data.signal,0,2);
        [~,i]=sort(data.chanVar);
        temp = i(ismember(i,data.chanInfo.other));
        CARch = temp(1:nRefChans);
    case 'nonLPCleasL1TvalCh'
        data.nRefChans = nRefChans;
        [~,i]=sort(data.RefChanTotalTstat);
        temp = i(ismember(i,data.chanInfo.other))';
        CARch = temp(1:nRefChans);        
    otherwise
        data.nRefChans = 0;
        CARch = refChan;
end
data.CARch = CARch;
data.CARSignal = mean(data.signal(CARch,:),1);
data.signal = bsxfun(@minus,data.signal,data.CARSignal);
data.signal(refChan,:) = data.CARSignal;

