
function out = matchChannelPatterns(data,S,opts)

% this function takes pairs of channels in IPS and SPL that had significant
% decoding accuracy and tries to match patterns obtaining a lag coefficient
% between each pair
% it was designed to work with IPS and SPL electrodes and high gamma power,
% it hasn't been generalized yet....
%
% a.gonzl Sept 18 2013

% dependencies:
%   

% settings
classThr    = 0.001;    % classifier threshold for channel selection
segLength   = 250;       % number of samples to match
maxLag      = 25;       % maximum samples of lag allowed
nS          = 3;        % number of starting points for matching
subjectNums = [1 3 4];  % subjects with IPS/SPL coverage in the left
analysis    = opts.analysis; % {'component','trial'}
nC          = 5;        % number of components


% window of time to look at
switch opts.lockType
    case 'RT'
        timeLims    = [-0.7 0.2];   % trial time limits
        startRange  = [-0.5 -0.1];  % approximate range of points for start matching
    case 'stim'
        timeLims    = [0 0.9];          % trial time limits
        startRange  = [0.2 0.6];     % approximate range of points for start matching
        
end
% because time stamps and samples don't always match, we approximate the
% trial times to sample ids.
trialSampsIds       = data.trialTime>=timeLims(1) & data.trialTime<=timeLims(2);
trialTimes          = data.trialTime(trialSampsIds);
T                   = sum(trialSampsIds); % total number of timepoints to consider
SR                  = round(data.SR); % sampling rate
%% grid search settings
% get the time stamps for the start parameter
ss                          = find(trialTimes>=startRange(1) & trialTimes<=startRange(end));
StartRangeSampEndPoint      = min(ss(end),T-segLength-maxLag);
StartRangeSampStartPoint    = max(ss(1), maxLag);
startMatchPoints            = round(linspace(StartRangeSampStartPoint,StartRangeSampEndPoint,nS));
startMatchTimes             = trialTimes(startMatchPoints);

% get the lag search points
lagPoints                = -maxLag:2:maxLag;
lagTimes                 = lagPoints/SR;
%% store all the settings

settings                = [];
settings.SR             = SR;
settings.analysis       = analysis;

if strcmp(analysis,'component') , settings.nC       = nC; end

settings.subjectNums    = subjectNums;
settings.segLeng        = segLength;
settings.maxLag         = maxLag;
settings.nSamps         = T;
settings.startMatchTimes     = startMatchTimes;
settings.startMatchSamps= startMatchPoints;
settings.trialSampsIds  = trialSampsIds;
settings.trialTimes     = trialTimes;
settings.lagPoints      = lagPoints;
settings.lagTimes       = lagTimes;
settings.classThr       = classThr;

% low pass filter settings for the data, this is just to smooth in time a
% little bit
settings.numLPorder  = 10;
settings.LPcutOff    = 50;
settings.LP          = fir1(settings.numLPorder,settings.LPcutOff*2/data.SR, ...
    window(@hann,settings.numLPorder+1));

% output structute
out             = [];
out.settings    = settings;
out.sigChans    = S.pBAC < classThr;
out.IPSsigChans = (S.ROIid==1) & out.sigChans;
out.SPLsigChans = (S.ROIid==2) & out.sigChans;
out.chanSet1    = cell(4,1); % IPS channels
out.chanSet2    = cell(4,1); % SPL channels
out.numChanPairs= cell(4,1);

out.L2matching.score    = cell(4,1);
out.L2matching.lag      = cell(4,1);
out.L2matching.start    = cell(4,1);

out.DTWmatching.score   = cell(4,1);
out.DTWmatching.lag     = cell(4,1);
out.DTWmatching.start   = cell(4,1);

%%
for subj = [1 3 4]
    out.chanSet1{subj} = find(out.IPSsigChans(S.subjChans==subj));
    out.chanSet2{subj} = find(out.SPLsigChans(S.subjChans==subj));
    out.numChanPairs{subj} = numel(out.chanSet1{subj})*numel(out.chanSet2{subj});
    % number of pairs
    nP          = out.numChanPairs{subj};
    out.subjChanPairs{subj} = zeros(nP,2);
    
    % computation is only for relevant trials
    % hard coded for now ...
    h           = data.Hits{subj};
    crs         = data.CRs{subj};
    nT          = numel(h);
    trials      = find(h|crs)';  % trial Ids
    
    % component combination vs number of trials
    if strcmp(analysis,'component'),  nT = nC^2;
        
        out.DTWmatching.scoreH{subj}  = nan(nT,nP);
        out.DTWmatching.lagH  {subj}  = nan(nT,nP);
        out.DTWmatching.startH{subj}  = nan(nT,nP);
        
        out.DTWmatching.scoreC{subj} = nan(nT,nP);
        out.DTWmatching.lagC  {subj} = nan(nT,nP);
        out.DTWmatching.startC{subj} = nan(nT,nP);
    end
    
    pairCounter = 1;
    for ch1 = out.chanSet1{subj}'
        X   = squeeze(data.ERP{subj}(ch1,:,:)); % IPS channel
        % lowpass
        X           = applyFilter(settings.LP,X);
        % subselect time points
        X          = X(:,trialSampsIds);
        
        if strcmp(analysis,'component'),
            [SxH VxH DxH] = svd(X(h,:),'econ');
            [SxC VxC DxC] = svd(X(crs,:),'econ');
        end
        for ch2 = out.chanSet2{subj}'
            
            fprintf('\nFinding match for pair %g \n', pairCounter); tic
            out.subjChanPairs{subj}(pairCounter,:) = [ch1 ch2];
            
            Y   = squeeze(data.ERP{subj}(ch2,:,:)); % SPL channel
            % lowpass
            Y           = applyFilter(settings.LP,Y);
            % subselect time points
            Y          = Y(:,trialSampsIds);
            if strcmp(analysis,'component'),
                [SyH VyH DyH] = svd(Y(h,:),'econ');
                [SyC VyC DyC] = svd(Y(crs,:),'econ');
            end
            
            switch analysis
                case 'trial'
                    for trId = trials
                        x   = X(trId,:);
                        y   = Y(trId,:);
                        
                        % L2 matching
                        temp = ATSPM(x,y,segLength,lagPoints,startMatchPoints,'L2');
                        out.L2matching.score{subj}(trId,pairCounter)    = temp.score;
                        out.L2matching.lag{subj}(trId,pairCounter)      = lagTimes(temp.bestLagIdx);
                        out.L2matching.start{subj}(trId,pairCounter)    = startMatchTimes(temp.bestStartIdx);
                        
                        % DTW matching
                        temp = ATSPM(x,y,segLength,lagPoints,startMatchPoints,'DTW');
                        out.DTWmatching.score{subj}(trId,pairCounter)   = temp.score;
                        out.DTWmatching.lag{subj}(trId,pairCounter)     = lagTimes(temp.bestLagIdx);
                        out.DTWmatching.start{subj}(trId,pairCounter)   = startMatchTimes(temp.bestStartIdx);
                        
                    end
                case 'component'
                    compCounter = 1;
                    for c1 = 1:nC
                        for c2 = 1:nC
                            % hits
                            x   = DxH(:,c1)';
                            y   = DyH(:,c2)';
                            
                            temp = ATSPM(x,y,segLength,lagPoints,startMatchPoints,'L2');
                            out.DTWmatching.scoreH{subj}(compCounter,pairCounter)    = temp.score;
                            out.DTWmatching.lagH{subj}(compCounter,pairCounter)      = lagTimes(temp.bestLagIdx);
                            out.DTWmatching.startH{subj}(compCounter,pairCounter)    = startMatchTimes(temp.bestStartIdx);
                            
                            % crs
                            x   = DxC(:,c1)';
                            y   = DyC(:,c2)';
                            temp = ATSPM(x,y,segLength,lagPoints,startMatchPoints,'DTW');
                            out.DTWmatching.scoreC{subj}(compCounter,pairCounter)   = temp.score;
                            out.DTWmatching.lagC{subj}(compCounter,pairCounter)     = lagTimes(temp.bestLagIdx);
                            out.DTWmatching.startC{subj}(compCounter,pairCounter)   = startMatchTimes(temp.bestStartIdx);
                            
                            compCounter = compCounter +1;
                        end
                    end
            end
            fprintf('Computation finished. Time elapsed %g \n', toc);
            pairCounter = pairCounter + 1 ;
        end
    end
end





