function [teststamps hcmf hmcfn hmcfnRT testRTs pairs S] = SS2_analyze_ecog(run,sub,path)

%ecog behavioral data analysis
%a.gonzl
%Aug 5,2011
%mapping of responses
% sub1 button pressed   '+' ->  [2] new
%                       '4' ->  [1] old
%
% subject 2 had enough trials with confidence
% sub2 button pressed   '+' ->  [1] HC old   % switched
%                       '6' ->  [1] HC old
%                       '5' ->  [2] LC new
%                       '4' ->  [2] HC new
% sub3 button pressed   '+' ->  [2] new
%                       '4' ->  [1] old
% events codes:
% 0    -> no answer or late answer
% 1     -> HChits
% 2     -> HCcr
% 3     -> misses
% 4     -> fa
% 5     -> LChits
% 6     -> LCcr


% load data
% try
% d = dir(sprintf('test_%d.%s.out.mat', run,sub));
% datafile = d.name;
% load(datafile);
% catch
%     warning('data file not found in current directory')
%     return
% end
datapath = [path sprintf('test_%d.%s.out.mat', run,sub)];

load(datapath)

[teststamps hcmf hmcfn hmcfnRT testRTs pairs S] = analyze_test(theData,sub,run);

textfile = sprintf('SS2.%s.%d.out.txt',sub,run);
fid = fopen([path textfile],'wt');

for n = 1:numel(hcmf)
fprintf(fid,'%4f \t %d \n',[teststamps(n); hcmf(n)]);
end
fclose(fid);

% textfile = sprintf('SS2.$s.checklist.%d.txt',sub,run);
% fid = fopen(textfile,'wt');
% fprintf(fid,'%s \t\t %s \t %s \t %s \t  %s\n','timestamp','cond','resp','on','rt');
% for n = 1:length(hcmf)
%     fprintf(fid,'%4f \t %d \t\t %s \t\t %d \t\t %4.2f \t\n',teststamps(n),hcmf(n),pairs{n,1},pairs{n,2},testRTs(n));
% end
% fclose(fid);

end

function [stamps hcmf hmcfn hmcfnRT RT pairs S] = analyze_test(data,sub,run)


triallenght = numel(data.item);

% collapses across responses made during stim time and post stim
% time
RT = NaN(triallenght,1);
%resp = char(triallenght,1);
%tota_dur = 4.5;

for trial = 1:triallenght
    try
        % check for response at stim time
        if ~strcmp(data.stimresp(trial),'n')
            resp(trial,1) = data.stimresp(trial);
            RT(trial,1) = data.stimRT(trial);
            % check for response at post stim time
        elseif ~strcmp(data.poststimresp(trial), 'noanswer') ...
                && ~strcmp(data.poststimresp(trial), 'n');
            resp(trial,1) = data.poststimresp(trial);
            RT(trial,1) = data.poststimRT(trial)+1;
            % no response or other invalid response
        else
            resp(trial,1) = {'n'};
            RT(trial,1) = NaN;
        end
    catch ME
        keyboard
        resp(trial,1)={'n'};
    end
    if iscell(resp{trial}) && numel(resp{trial})==1
        resp(trial,1) = resp{trial};
    end
end

% loads conditions
cond = data.cond;
% pairs contains the response and condition pairs
pairs = [resp num2cell(cond)];

% mapping of button presses
if strcmp(sub,'MD') || strcmp(sub,'KS') ||strcmp(sub,'NC')||strcmp(sub,'RR')
    oldbutton = {'4','5'}; newbutton = {'+','6'};
elseif strcmp(sub,'SRb') && run == 4
     oldbutton = {'L','4'}; newbutton = {'+','6'};
elseif strcmp(sub,'SRb')||strcmp(sub,'LK')||strcmp(sub,'JT')
     oldbutton = {'4','5'}; newbutton = {'+','6'};
else
    oldbutton = {'+','6'}; newbutton = {'4','5'};
end


S.old = cell2num(pairs(:,2))==1; % old stimuli
S.new = cell2num(pairs(:,2))==2; % new stimuli
S.HCOresp = strcmp(oldbutton{1},pairs(:,1)); % high confidence old response
S.LCOresp = strcmp(oldbutton{2},pairs(:,1)); % low confidence old response
S.HCNresp = strcmp(newbutton{1},pairs(:,1)); % high confidence new response
S.LCNresp = strcmp(newbutton{2},pairs(:,1)); % low confidence new response
S.NoAn = strcmp('n',pairs(:,1)); % no response

% hits calculation
S.HChits = S.HCOresp & S.old;
S.LChits = S.LCOresp & S.old;
S.hits = S.HChits | S.LChits;
S.miss = ~S.hits & S.old & ~S.NoAn;
S.NoAn2Old = S.NoAn & S.old;

% cr calculation
S.HCcr = S.HCNresp & S.new;
S.LCcr = S.LCNresp & S.new;
S.cr = S.HCcr | S.LCcr;
S.fa = ~S.cr & S.new & ~S.NoAn;
S.NoAn2New = S.NoAn & S.new;


% performance measures
perf_mean = mean(sum([S.hits S.cr],2));
%perf_std = std(sum([hits cr],2));

hcmf = zeros(triallenght,1);
hcmf(S.HChits) = 1;
hcmf(S.HCcr) = 2;
hcmf(S.miss) = 3;
hcmf(S.fa) = 4;
hcmf(S.LChits) = 5;
hcmf(S.LCcr) = 6;

S.nHChits = sum(S.HChits);
S.nLChits = sum(S.LChits);
S.nhits = sum(S.hits);
S.nmiss = sum(S.miss);
S.nHCcr = sum(S.HCcr);
S.nLCcr = sum(S.LCcr);
S.ncr = sum(S.cr);
S.nfa = sum(S.fa);
S.noan = sum(S.NoAn);
S.nNoAn2Old = sum(S.NoAn2Old);
S.nNoAn2New = sum(S.NoAn2New);

hitsRT = mean(RT(S.hits));
S.hitRTs = RT(S.hits);

missRT = mean(RT(S.miss));
S.missRTs = RT(S.miss);

crRT = mean(RT(S.cr));
S.crRTs = RT(S.cr);

faRT = mean(RT(S.fa));
S.faRTs = RT(S.fa);

S.allRTs = RT;


% performance info
fprintf(['hits  ' num2str(S.nhits) '\n']);
fprintf(['miss  ' num2str(S.nmiss) '\n']);
fprintf(['corj  ' num2str(S.ncr) '\n']);
fprintf(['flsa  ' num2str(S.nfa) '\n']);
fprintf(['noan  ' num2str(S.noan) '\n']);
fprintf(['perf mean  ' num2str(perf_mean) '\n']);

[dPrime c] = calc_dPrime(S.nhits, S.nmiss, S.nfa, S.ncr);

if dPrime > 1e3
    [dPrime c] = calc_dPrime(S.nhits+1/triallenght, S.nmiss+1/triallenght, S.nfa+1/triallenght, S.ncr+1/triallenght);
end


fprintf(['dprime: ' num2str(dPrime) '\n']);
fprintf(['c: ' num2str(c) '\n\n']);

hmcfn = [S.nhits S.nmiss S.ncr S.nfa S.noan];
hmcfnRT = [hitsRT missRT crRT faRT 0];

fprintf('RTs (hits miss crj flsa)\n');
disp([hitsRT missRT crRT faRT])

stamps = [data.flip.VBLTimestamp]';
return;

end

