% make event txt file script
%calls on_analyze_ecog

behav_perf =[];
behav_perf.expt = 'SS2';
behav_perf.sub = 'RR';
behav_perf.conds = {'old', 'new', 'HCOresp','LCOresp', 'HCNresp', 'LCNresp',...
    'NoAn','HChits','LChits','hits','miss','NoAn2Old','HCcr','LCcr','cr','fa','NoAn2New',...
    'nhits','hitRTs','ncr','crRTs','nmiss','missRTs','nfa','faRTs','noan','allRTs'};

if strcmp(behav_perf.sub,'SRb')
    behav_perf.subnum = '16b';
    behav_perf.nruns = 4;
    behav_perf.run_nums = 1:4;
elseif strcmp(behav_perf.sub,'RHb')
    behav_perf.subnum = '17b';
    behav_perf.nruns = 2;
    behav_perf.run_nums = 1:2;
elseif strcmp(behav_perf.sub,'MD')
    behav_perf.subnum = '18';
    behav_perf.nruns=2;
    behav_perf.run_nums = 1:2;
elseif strcmp(behav_perf.sub,'TC')
    behav_perf.subnum = '22';
    behav_perf.nruns=3;
    behav_perf.run_nums = 1:3;
elseif strcmp(behav_perf.sub,'LK')
    behav_perf.subnum = '24';
    behav_perf.nruns=4;
    behav_perf.run_nums = 2:5;
elseif strcmp(behav_perf.sub,'KS')
    behav_perf.subnum = '27';
    behav_perf.nruns=4;
    behav_perf.run_nums = 1:4;
elseif strcmp(behav_perf.sub,'NC')
    behav_perf.subnum = '28';
    behav_perf.nruns=4;
    behav_perf.run_nums = 1:4;
elseif strcmp(behav_perf.sub,'JT')
    behav_perf.subnum = '29';
    behav_perf.nruns=4;
    behav_perf.run_nums = 1:4;
elseif strcmp(behav_perf.sub,'RR')
    behav_perf.subnum = '30';
    behav_perf.nruns=7;
    behav_perf.run_nums = 1:7;
end

path = ['/Volumes/group/awagner/biac3/wagner7/ecog/subj' behav_perf.subnum '/ecog/' behav_perf.expt '/BehavData/'];


for i=1:numel(behav_perf.conds)
    behav_perf.(behav_perf.conds{i}) = [];
end

for run = 1: behav_perf.nruns
    run_num = behav_perf.run_nums(run);
    
    [teststamps hcmf hmcfn hmcfnRT testRTs pairs{run} behav_perf.S{run}] = SS2_analyze_ecog(run_num,behav_perf.sub,path);
    
    for i=1:numel(behav_perf.conds)
        behav_perf.(behav_perf.conds{i}) = vertcat(behav_perf.(behav_perf.conds{i}), ...
            behav_perf.S{run}.(behav_perf.conds{i}));
    end
    
    %behav_perf.codes = vertcat(behav_perf.codes, hcmf);
    
end

for i=1:numel(behav_perf.conds)
    behav_perf.nConds.(behav_perf.conds{i}) = sum(behav_perf.(behav_perf.conds{i}));
end

[behav_perf.dPrime behav_perf.c] = calc_dPrime(sum(behav_perf.nhits), sum(behav_perf.nmiss), sum(behav_perf.nfa), sum(behav_perf.ncr));
behav_perf.hitrate = sum(behav_perf.nhits) / (sum(behav_perf.nhits)+ sum(behav_perf.nmiss));
behav_perf.farate = sum(behav_perf.nfa) / (sum(behav_perf.nfa) + sum(behav_perf.ncr));

behav_perf.hitRTStats = [];
behav_perf.hitRTStats = calc_RTstats(behav_perf.hitRTs,behav_perf.hitRTStats);

behav_perf.crRTStats = [];
behav_perf.crRTStats = calc_RTstats(behav_perf.crRTs,behav_perf.crRTStats);

behav_perf.missRTStats = [];
behav_perf.missRTStats = calc_RTstats(behav_perf.missRTs,behav_perf.missRTStats);

behav_perf.faRTStats = [];
behav_perf.faRTStats = calc_RTstats(behav_perf.faRTs,behav_perf.faRTStats);

% ttest
[H,P,CI] = ttest2(behav_perf.hitRTs,behav_perf.crRTs);
behav_perf.two_samp_ttest_P_hcr = P;
behav_perf.two_samp_ttest_CI_hcr = CI;

[H,P,CI] = ttest2(behav_perf.hitRTs,behav_perf.faRTs);
behav_perf.two_samp_ttest_P_hfa = P;
behav_perf.two_samp_ttest_CI_hfa = CI;

save([path '/behav_perf.mat'],'behav_perf')
path2= '~/Documents/ECOG/Results/BehavData/';
save([path2 'Subj' behav_perf.subnum 'behav_perf.mat'],'behav_perf')

fprintf('\n\nTotal Performance for subject: %s \n', behav_perf.sub)
fprintf(['Hit Rate : ' num2str(behav_perf.hitrate) '\n']);
fprintf(['FA Rate  : ' num2str(behav_perf.farate) '\n']);
fprintf(['dprime   : ' num2str(behav_perf.dPrime) '\n']);
fprintf(['c        : ' num2str(behav_perf.c) '\n\n']);

fprintf('RTs (hits miss crj flsa)\n');
disp([behav_perf.hitRTStats.RTmedian behav_perf.missRTStats.RTmedian ...
    behav_perf.crRTStats.RTmedian behav_perf.faRTStats.RTmedian])
fprintf('P value for hitRTs vs crRTs\n')
fprintf(['P         : ' num2str(behav_perf.two_samp_ttest_P_hcr) '\n\n'])

fprintf('P value for hitRTs vs faRTs\n')
fprintf(['P         : ' num2str(behav_perf.two_samp_ttest_P_hfa) '\n\n'])




