% This script analyzes the encoding SS2 data for ecog patients
% March 3, 2013

clearvars
addpath(genpath('./lib/'))
behav_perf =[];
behav_perf.subname   = 'RB';

behav_perf.expt      = 'SS2';
if strcmp(behav_perf.subname,'SRb')
    behav_perf.subnum = '16b';
    behav_perf.nruns = 4;
    behav_perf.run_nums = 1:4;
elseif strcmp(behav_perf.subname,'RHb')
    behav_perf.subnum = '17b';
    behav_perf.nruns = 2;
    behav_perf.run_nums = 1:2;
elseif strcmp(behav_perf.subname,'MD')
    behav_perf.subnum = '18';
    behav_perf.nruns=2;
    behav_perf.run_nums = 1:2;
elseif strcmp(behav_perf.subname,'TC')
    behav_perf.subnum = '22';
    behav_perf.nruns=3;
    behav_perf.run_nums = 1:3;
elseif strcmp(behav_perf.subname,'LK')
    behav_perf.subnum = '24';
    behav_perf.nruns=4;
    behav_perf.run_nums = 2:5;
elseif strcmp(behav_perf.subname,'KS')
    behav_perf.subnum = '27';
    behav_perf.nruns=4;
    behav_perf.run_nums = 1:4;
elseif strcmp(behav_perf.subname,'NC')
    behav_perf.subnum = '28';
    behav_perf.nruns=4;
    behav_perf.run_nums = 1:4;
elseif strcmp(behav_perf.subname,'JT')
    behav_perf.subnum = '29';
    behav_perf.nruns=4;
    behav_perf.run_nums = 1:4;
elseif strcmp(behav_perf.subname,'RB')
    behav_perf.subnum = '19';
    behav_perf.nruns=1;
    behav_perf.run_nums = 1;
    behav_perf.expt      = 'SS3';
end
path = ['/biac4/wagner/biac3/wagner7/ecog/subj' behav_perf.subnum '/ecog/' behav_perf.expt '/BehavData/'];

behav_perf.rundata      = cell(behav_perf.nruns,1);
behav_perf.nTrialTypes   = zeros(1,5);
behav_perf.trialType    = [];
behav_perf.RTs          = [];
for r = behav_perf.run_nums;
    if strcmp(behav_perf.expt,'SS3')
        filename = ['AGstudylonglist.' behav_perf.subname '.out.mat'];
    else
        filename = ['study_' num2str(r) '.' behav_perf.subname '.out.mat'];
    end
    
    temp = load([path filename]);    
    data = SS2_analyzeEncodingBehavioral(temp.theData,behav_perf.subname,r);
    fprintf(['\nSubject ' behav_perf.subnum ' Run ' num2str(r) '\n'])
    fprintf('Mean Performance %g \n', data.meanPerf);
    fprintf('dPrime %g\n', data.dPrime);
    
    behav_perf.rundata{r}   = data;
    behav_perf.trialType    = vertcat(behav_perf.trialType,data.trialType); 
    behav_perf.RTs          = vertcat(behav_perf.RTs,data.RTs);
    behav_perf.nTrialTypes   = behav_perf.nTrialTypes+data.nTrialTypes;
end

behav_perf.dPrime = calc_dPrime(behav_perf.nTrialTypes(1),behav_perf.nTrialTypes(2),behav_perf.nTrialTypes(4),behav_perf.nTrialTypes(3));
behav_perf.meanPerf  = mean((behav_perf.trialType==1)|(behav_perf.trialType==3));
behav_perf.medianRTCorrectConc = median(behav_perf.RTs(behav_perf.trialType==3));
behav_perf.medianRTCorrectAbs = median(behav_perf.RTs(behav_perf.trialType==1));
[~,p]= ttest2(behav_perf.RTs(behav_perf.trialType==1),behav_perf.RTs(behav_perf.trialType==3));
behav_perf.pvalRTs =  p;

fprintf(['\nSubject ' behav_perf.subnum ' Total Encoding Performance \n'])
fprintf('Mean Performance %g \n', behav_perf.meanPerf);
fprintf('dPrime %g\n', behav_perf.dPrime);
fprintf('Median RTs Abstract: %g \n',behav_perf.medianRTCorrectAbs);
fprintf('Median RTs Concrete: %g \n',behav_perf.medianRTCorrectConc);
fprintf('RTs Ttest Pvalue   : %g \n',behav_perf.pvalRTs);
