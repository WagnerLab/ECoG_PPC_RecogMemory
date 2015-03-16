% make event txt file script
%calls on_analyze_ecog

%cd /biac4/wagner/biac3/wagner7/ecog/sub17b/ecog/SS2/BehavData/
%addpath(genpath('/biac-wagner/biac3/wagner7/ecog/scripts'))
addpath(('/biac4/wagner/biac3/wagner7/ecog/scripts/alex'))
addpath(('/biac4/wagner/biac3/wagner7/ecog/scripts/alex/lib'))
%addpath(genpath('/biac-wagner/biac3/wagner7/ecog/eeg_scripts'))

behav_perf =[];
behav_perf.subnum = '19';
behav_perf.sub = 'RB';
behav_perf.expt = 'SS3';
behav_perf.conds = {'old', 'new', 'HCOresp','LCOresp', 'HCNresp', 'LCNresp',...
    'NoAn','HChits','LChits','hits','miss','NoAn2Old','HCcr','LCcr','cr','fa','NoAn2New',...
    'nhits','hitRTs','ncr','crRTs','nmiss','missRTs','nfa','faRTs','noan','allRTs',...
    'nHChits','nHCcr','nNoAn2Old','nNoAn2New'};


behav_perf.blocknums = [0];

path = ['/biac4/wagner/biac3/wagner7/ecog/subj' behav_perf.subnum '/ecog/' behav_perf.expt '/BehavData/'];

for i=1:numel(behav_perf.conds)
        behav_perf.(behav_perf.conds{i}) = [];
end


% analyze data

teststamps = cell(numel(behav_perf.blocknums),1);
hcmf = cell(numel(behav_perf.blocknums),1);
concruns =[];
cnt = 1;
for run = behav_perf.blocknums
    [teststamps{cnt} hcmf{cnt} hmcfn hmcfnRT testRTs pairs behav_perf.S{cnt}] = SS3_analyze_ecog(run,behav_perf.sub,path);
    
    textfile = sprintf('%s/SS3.%s.%i.out.txt',path,behav_perf.sub,run);
    fid = fopen(textfile,'wt');
    
    for n = 1:numel(hcmf{cnt})
        fprintf(fid,'%4f \t %d \n',[teststamps{cnt}(n); hcmf{cnt}(n)]);
    end
    fclose(fid);
    
    
    for i=1:numel(behav_perf.conds)
        behav_perf.(behav_perf.conds{i}) = vertcat(behav_perf.(behav_perf.conds{i}), ...
            behav_perf.S{cnt}.(behav_perf.conds{i}));
    end
    
    concruns = strcat(concruns,num2str(run));
    cnt = cnt +1;
    
end

textfile = sprintf('%s/SS3.%s.%s.out.txt',path,behav_perf.sub,concruns);
fid = fopen(textfile,'wt');

cnt = 1;
for run = 1:numel(behav_perf.blocknums)
    for n = 1:numel(hcmf{cnt})
        fprintf(fid,'%4f \t %d \n',[teststamps{cnt}(n); hcmf{cnt}(n)]);
    end
    cnt = cnt +1;
end
fclose(fid);

for i=1:numel(behav_perf.conds)
        behav_perf.nConds.(behav_perf.conds{i}) = sum(behav_perf.(behav_perf.conds{i}));
end

% calculate performance
[behav_perf.dPrime behav_perf.c] = calc_dPrime(sum(behav_perf.nhits), sum(behav_perf.nmiss), sum(behav_perf.nfa), sum(behav_perf.ncr));
behav_perf.hitrate = sum(behav_perf.nhits) / (sum(behav_perf.nhits)+ sum(behav_perf.nmiss));
behav_perf.farate = sum(behav_perf.nfa) / (sum(behav_perf.nfa) + sum(behav_perf.ncr));

[behav_perf.dPrimeHC behav_perf.cHC] = calc_dPrime(behav_perf.nHChits, behav_perf.nmiss, behav_perf.nfa, behav_perf.nHCcr);

behav_perf.hitrate = behav_perf.nhits / (behav_perf.nhits+ behav_perf.nmiss);
behav_perf.farate = behav_perf.nfa / (behav_perf.nfa + behav_perf.ncr);

behav_perf.hitRTStats = [];
behav_perf.hitRTStats = calc_RTstats(behav_perf.hitRTs,behav_perf.hitRTStats);

behav_perf.crRTStats = [];
behav_perf.crRTStats = calc_RTstats(behav_perf.crRTs,behav_perf.crRTStats);

behav_perf.missRTStats = [];
behav_perf.missRTStats = calc_RTstats(behav_perf.missRTs,behav_perf.missRTStats);

behav_perf.faRTStats = [];
behav_perf.faRTStats = calc_RTstats(behav_perf.faRTs,behav_perf.faRTStats);

% ttest
[~,P,CI] = ttest2(behav_perf.hitRTs,behav_perf.crRTs);
behav_perf.two_samp_ttest_P_hcr = P;
behav_perf.two_samp_ttest_CI_hcr = CI;

[H,P,CI] = ttest2(behav_perf.hitRTs,behav_perf.faRTs);
behav_perf.two_samp_ttest_P_hfa = P;
behav_perf.two_samp_ttest_CI_hfa = CI;

if behav_perf.blocknums ~= 0
    save([path concruns 'perf2.mat' ],'behav_perf')
else
    save([path 'perf2.mat'],'behav_perf')
end

path2= '/Users/alexgonzalez/Documents/ECOG/Results/BehavData/';
save([path2 'Subj' behav_perf.subnum 'behav_perf.mat'],'behav_perf')

fprintf('\n\nTotal Performance for subject %s \n', behav_perf.sub)
fprintf(['HChits  ' num2str(behav_perf.nHChits) '\n']);
fprintf(['hits  ' num2str(behav_perf.nhits) '\n']);
fprintf(['miss  ' num2str(behav_perf.nmiss) '\n']);
fprintf(['HCcr  ' num2str(behav_perf.nHCcr) '\n']);
fprintf(['cr  ' num2str(behav_perf.ncr) '\n']);
fprintf(['fa  ' num2str(behav_perf.nfa) '\n']);
fprintf(['noan  ' num2str(behav_perf.noan) '\n']);
fprintf(['noan2old  ' num2str(behav_perf.nNoAn2Old) '\n']);
fprintf(['noan2new  ' num2str(behav_perf.nNoAn2New) '\n\n']);


fprintf(['Hit Rate : ' num2str(behav_perf.hitrate) '\n']);
fprintf(['FA Rate  : ' num2str(behav_perf.farate) '\n']);
fprintf(['dprime   : ' num2str(behav_perf.dPrime) '\n']);
fprintf(['c        : ' num2str(behav_perf.c) '\n']);
fprintf(['HC dprime: ' num2str(behav_perf.dPrimeHC) '\n']);
fprintf(['HC c     : ' num2str(behav_perf.cHC) '\n\n']);

fprintf('RTs (hits miss crj flsa)\n');
disp([behav_perf.hitRTStats.RTmedian behav_perf.missRTStats.RTmedian ...
    behav_perf.crRTStats.RTmedian behav_perf.faRTStats.RTmedian])
fprintf('P value for hitRTs vs crRTs\n')
fprintf(['P         : ' num2str(behav_perf.two_samp_ttest_P_hcr) '\n\n'])

fprintf('P value for hitRTs vs faRTs\n')
fprintf(['P         : ' num2str(behav_perf.two_samp_ttest_P_hfa) '\n\n'])

