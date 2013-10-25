function out=exportLPCData2R(data,opts)
% fucntion vectorizes the data into columns so it can be used in R

% Columns:
% 1  -> mean data subtracted
% 3  -> T scores Hits-CRs
% 5  -> Z value data from mann whitney (Hits - CRs)
% 7  -> Bin time
% 8  -> channel id
% 9  -> subject id
% 10 -> block id
% 11 -> roi id
% 12 -> dPrime for the block
% 13 -> hit rate for the block
% 14 -> FAR rate for the block
% 15 -> hemisphere
% 16 -> sub roi id
% 17 -> ITC_Z;  inter trial coherence   z score
% 18 -> ITP_Z;  inter trial phase       z score
% 19 -> ZcStat  RT-amp correlation Z score (H-CRs)
% 20 -> ZcHits; RT-amp correlation Z score Hits
% 21 -> ZcCRs ; RT-amp correlation Z score CRs
% 22 -> zHits;  score agains zero for hit trials
% 23 -> zCRs ;  score agains zero for CRs trials

switch opts.bin
    case 'Bin'
        binIdx  = data.Bins(:,1) >= opts.time(1) & data.Bins(:,2) <= opts.time(2);
        nBins   = sum(binIdx);
    case 'BigBin'
        binIdx  = data.Bigbins(:,1) >= opts.time(1) & data.Bigbins(:,2) <= opts.time(2);
        nBins   = sum(binIdx);
end

nChans  = numel(data.LPCchanId);
nSubjs  = numel(unique(data.subjChans));
if opts.byBlockFlag
    preFix = 'BinBlock';
    nBlocks = data.maxNumBlocks;
else
    preFix = opts.bin;
    nBlocks = 1;
end

% prealloaction
out = nan(nChans*nBins*nBlocks,23);

switch opts.type
    case 'itc'
        x = data.BinITC_Z(:,binIdx);
        out(:,17)   = x(:);
        x = data.BinITP_Z(:,binIdx);
        out(:,18)   = x(:);
    otherwise
        %x = data.([preFix 'condDiff']);
        %out(:,1)    = x(:);
        %x = data.([preFix 'TStat']);
        %out(:,3)    = x(:);
        x = data.([preFix 'ZStat'])(:,binIdx);
        out(:,5)    = x(:);
        x = data.([preFix 'ZcStat'])(:,binIdx);
        out(:,19)   = x(:);
        x = data.([preFix 'ZcHits'])(:,binIdx);
        out(:,20)   = x(:);
        x = data.([preFix 'ZcCRs'])(:,binIdx);
        out(:,21)   = x(:);
        x = data.([preFix 'zHits'])(:,binIdx);
        out(:,22)   = x(:);
        x = data.([preFix 'zCRs'])(:,binIdx);
        out(:,23)   = x(:);
end

% bin time:
x = 1:nBins;
x = repmat(x,[nChans 1 nBlocks]);
out(:,7) = x(:);

% channel id
x = 1:nChans;
x = repmat(x,[1 nBins nBlocks]);
out(:,8) = x(:);

% subject id/ this is by channel
x = data.subjChans(:)';
x = repmat(x,[1 nBins nBlocks]);
out(:,9) = x(:);

% block id
x = zeros(1,1,nBlocks);
x(1:nBlocks) = 1:nBlocks;
x = repmat(x,[nChans nBins 1]);
out(:,10) = x(:);

% roi id/ by channel
x = data.ROIid(:)';
x = repmat(x,[1 nBins nBlocks]);
out(:,11) = x(:);

% hemisphere id/ by channel
x = data.hemChanId(:)';
x = repmat(x,[1 nBins nBlocks]);
out(:,15) = x(:);

% sub roi id/ by channel
x = data.subROIid(:)';
x = repmat(x,[1 nBins nBlocks]);
out(:,16) = x(:);

% dPrime, rates
for s = 1:nSubjs
    if opts.byBlockFlag
        for bl = 1:nBlocks
            ids = (out(:,9)==s)&(out(:,10)==bl);
            out(ids,12) = data.dP_Block(s,bl);
            out(ids,13) = data.HR_Block(s,bl);
            out(ids,14) = data.FAR_Block(s,bl);
        end
    else
        ids = (out(:,9)==s);
        out(ids,12) = data.dPrime(s);
    end
end


