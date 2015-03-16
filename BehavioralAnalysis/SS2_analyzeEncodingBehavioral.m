
function [out] = SS2_analyzeEncodingBehavioral(data,subjname, runnum)

% output
out = [];
out.data = data;

% subject button response condition mapping:
if strcmp(subjname,'SRb')
    if (runnum < 4)
        key1 = '5'; % abstract
        key2 = '4'; % concrete
    else
        key1 = 'R'; % abstract
        key2 = 'L'; % concrete
    end
elseif strcmp(subjname,'MD')
    key1 = '4'; % abstract
    key2 = '5'; % concrete
elseif strcmp(subjname,'LK')
    key1 = '1'; % abstract
    key2 = '2'; % concrete
elseif strcmp(subjname,'NC')
    key1 = '2'; % abstract
    key2 = '1'; % concrete
elseif strcmp(subjname,'RHb')
    key1 = '5'; % abstract
    key2 = '4'; % concrete
elseif strcmp(subjname,'JT')
    key1 = '+'; % abstract
    key2 = '6'; % concrete
elseif strcmp(subjname,'RB')
    key1 = '2'; % abstract
    key2 = '1'; % concrete 
end

out.keys = {'abstract','concrete';key1,key2};

out.condition   = data.cond; % abstract ==1, concrete==2
out.nTrials      = numel(out.condition);

out.response    = zeros(out.nTrials,1);
out.RTs         = zeros(out.nTrials,1);

% abstracts
out.response(strcmp(data.resp',key1) | strcmp([data.ITIresp{:}]',key1)) =1;
% concretes
out.response(strcmp(data.resp',key2) | strcmp([data.ITIresp{:}]',key2)) =2;
% zero for no response

% RTs
respRTs = (data.ITIrespRT' <=0);
out.RTs(respRTs)  = data.respRT(respRTs)';
out.RTs(~respRTs) = data.ITIrespRT(~respRTs)+2;
out.RTs(out.response==0) = NaN; % no response

% codes for trials
out.codes = {'CorrectAbs','InCorrectAbs', 'CorrectConc', 'InCorrectConc','noAnswer' ;1,2,3,4,5};
out.trialType = ...
    1*((out.condition==1) & (out.response==1))+ ...
    2*((out.condition==2) & (out.response==1))+ ...
    3*((out.condition==2) & (out.response==2))+ ...
    4*((out.condition==1) & (out.response==2))+ ...
    5*(out.response==0);

% Number of conditions
out.nTrialTypes     = [ ...
    sum(out.trialType==1) ...
    sum(out.trialType==2) ...
    sum(out.trialType==3) ...
    sum(out.trialType==4) ...
    sum(out.trialType==5) ...
    ];

out.meanPerf = mean(out.condition == out.response);
out.dPrime = calc_dPrime(out.nTrialTypes(1),out.nTrialTypes(2),out.nTrialTypes(4),out.nTrialTypes(3));
out.medianRTCorrectAbs  = median(out.RTs(out.trialType==1));
out.medianRTCorrectConc = median(out.RTs(out.trialType==3));

return