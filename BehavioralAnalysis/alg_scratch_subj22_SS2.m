% scratch_subj22 SS2

%% SS2
% Setup parameters
expt = 'SS2';
subj = 'subj22';
blocklist = {'TC0212-21', 'TC0212-23', 'TC0212-25'};


addpath(genpath( '/biac4/wagner/biac3/wagner7/ecog/scripts/alex'))
addpath(genpath( '~/Documents/MATLAB/Mylib/vistasoft/'))

basepath = ['/biac4/wagner/biac3/wagner7/ecog/' subj '/ecog/' expt];

bef_win = 0.2;
aft_win = 1;

condnames = {...
    
        'all','HChits','LChits','HCcr','HCcr', 'LCcr'...
        'hits','cr','misses','fa','old','new'};
       
% load a parfile
parfile = fullfile(basepath,'RawData',blocklist{1},['parSubj' subj(5:end) expt '.mat']); 
if exist(parfile,'file')
    load(parfile);
else % first time creating parfile
    cd(basepath);
    funcname = ['makeparSubj' subj(5:end) expt];
    cmd = ['par = ' funcname '(blocklist{1},basepath,parfile)'];
    eval(cmd);
end

% Update path info based on par.basepath
par.basepath = basepath;
par = ecogPathUpdate(par);
par.bef_win = bef_win;
par.aft_win = aft_win;

% Remove unwanted channels from electrode list
elecs = [1:par.nchan];
if isfield(par,'missingchan')
    elecs=elecs(~ismember(elecs,par.missingchan));
end
elecs=elecs(~ismember(elecs,par.badchan));
% elecs=elecs(~ismember(elecs,par.epichan));
elecs=elecs(~ismember(elecs,par.refchan));
par.elecs = elecs;
%% preprocess files
% flags:
% p: Create parfile, otherwise load existing parfile.
% f: Filter (ecogNoiseFiltData)
% a: Artifact replacement (ecogArtReplace)
% c: Common average reference (ecogCommonAvgRef)
% b: Calculate broadband power shift
% d: Calculate amplitude & phase (ecogDataDecompose)
% t: Set timestamps (ecogStampfunc)
% r: save tcinfo for AZERPs
% e: Make ERPs (ecogERP)
% s: Make ERSPs (ecogERSP)
% z: Make ZERPs (ecogZERP) normalized ERPs
% k: Make ERBB (ecogERBB)

overwrite=0;
for b=1:length(blocklist)
    alg_ecogBatch_SS2(subj(5:end),blocklist{b},'es',basepath,bef_win,aft_win,overwrite); 
end


%%

% Make Average ERP and ERSP
for n = 7:length(condnames)
%     ecogAvgERP(par,elecs,blocklist,condnames{n},bef_win,aft_win);
    ecogAvgERSP(par,elecs,blocklist,condnames{n},bef_win,aft_win);
    %ecogAvgZERP(par,elecs,blocklist,condnames{n},bef_win,aft_win);
end

%% View results
% ecogPlotERP_GUI(par,bef_win,aft_win,condnames);
ecogPlotERSP_GUI(par,bef_win,aft_win,condnames,'ersp');
%ecogPlotZERP_GUI(par,bef_win,aft_win,condnames);
%ecogPlotERBB_GUI(par,bef_win,aft_win,condnames,4,10);

%%
% Trial counts
fprintf('#trials\t');
for n = 1:length(condnames)
    fprintf(['\t' condnames{n}]);
end
fprintf('\n');
for n = 1:length(blocklist)
    block = blocklist{n};
    fprintf(block);
    tlist = load(fullfile(basepath,'BehavData',['pdioevents_' block '.mat']),'conds');
%     for c = condstoprocess
%         tcount = length(find(tlist.conds==c));
%         fprintf(['\t' num2str(tcount)]);
%     end
    fprintf('\n');
end
    
