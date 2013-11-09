function data=preProcessRawData(subj,expt)
% function filters the raw data traces and concantenates data blocks for
% later processing
%
%   inputs:
%       subuject name and experiments
%
%   data dependencies:
%       photo-diode event markers in the same sample space as the data
%       Raw data for each block
%       
%   file dependencies: 
%       subjChanInfo.m
%       subjExptInfo.m
%       channelFilt.m
%       ts_adaptivezscore.m
% 
%   Author: A.Gonzl. 
%% intial settings

data                = [];
data.subjnum        = subj;
data.expt           = expt;
data.date           = date;
temp                = subjChanInfo(data.subjnum);
data.chanInfo       = temp;
data.nChans         = numel(data.chanInfo.allChans);
data.standarized    = false;

if data.standarized, zscore_str = 'zscored';else zscore_str='';end
temp = subjExptInfo(subj,expt,'allChCAR');

data.exptInfo   = temp;
data.blocklist  = temp.blocklist; blocklist =data.blocklist;
data.nBlocks    = numel(data.blocklist);

%% Parameters

data.SRorig     = 3051.76;
data.lowpass    = 180;  lp = data.lowpass; % low pass filter
data.hipass     = 1;    hp = data.hipass;% high pass filter
data.notch      = [60 120]; notches = data.notch; % notch; notches =
data.comp       = 7; comp=data.comp;% compression factor
data.SR         = data.SRorig/data.comp; SR = data.SR;

%% Decompose channels and save
mainPath                = data.exptInfo.DataPath;
data.trialOnsets        = [];
data.blockOffset(1)     =0;

refChan = data.chanInfo.refChannel; data.refChan = refChan;

data.savepath = ['../Results/' ...
    'ERP_Data/subj' data.subjnum '/BandPassedSignals/'];

if ~exist(data.savepath,'dir'), mkdir(data.savepath),end;
data.signal =[];

for b = 1: data.nBlocks
    
    display(['Prossesing Block ' data.blocklist{b} ])
    data.eventsfile{b} = [mainPath 'BehavData/pdioevents_' data.blocklist{b} '.mat'];
    load(data.eventsfile{b})
    
    % event time points
    data.nevents(b) = numel(truestamps);
    
    % pre-allocation
    rawdatafile = [mainPath 'RawData/' data.blocklist{b} '/iEEG' data.blocklist{b} '_01.mat'];
    
    x           = load(rawdatafile);
    nBlockSamps = ceil(length(x.wave)/data.comp); clear x;
    
    data.blockOffset(b+1) = data.blockOffset(b)+nBlockSamps;
    data.trialOnsets = [data.trialOnsets ; ceil(truestamps*data.SR)+data.blockOffset(b)];
    
    signal = zeros(data.nChans,nBlockSamps);
        
    parfor ch = 1:data.nChans    
        if (ch~=refChan)            
            channel = num2str(ch);
            display(['Prossesing Channel ' channel])
            zerosstr = num2str(zeros(1,2-numel(channel)));
            rawdatafile = [mainPath 'RawData/' blocklist{b} ...
                '/iEEG' blocklist{b} '_' zerosstr channel '.mat'];
            
            % load data
            x = load(rawdatafile);
            x = -double(x.wave);
            % detrend and downsample
            x = detrend(x,'linear');
            x = decimate(x,comp);
            % bandpass data
            x = channelFilt(x,SR,lp,hp,[]);
            for n = notches
                % notch data
                x = channelFilt(x,SR,[],[],n);
            end            
            if data.standarized
                x = ts_adaptivezscore(x);
            end
            signal(ch,:) = x;
        end
    end
    data.signal = cat(2,data.signal,signal);
end

savepath = [data.savepath '/'];
if (~exist(savepath,'dir')), mkdir(savepath); end;
save([savepath '/BandPass' zscore_str date '.mat'] , 'data')

