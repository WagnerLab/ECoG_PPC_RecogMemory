function S = subjExptInfo(subj,expt,reference)
% function storing the experiment information for each subject

S =[];
switch subj
    case {'04','CM'}
        if strcmp(expt,'PC1')
            S.date = '27-Oct-2011';
            S.blocklist = {'st07-14', 'st07-24','st07-25'};
        end
    case {'10','KB'}
        if strcmp(expt,'PC1')
            S.date = '30-Oct-2011';
            S.blocklist = {'KB0510_07', 'KB0510_09'};
        end
    case {'16b','SRb'}
        S.subjNum = '16b';
        S.subjName = 'SRb';
        if strcmp(expt,'SS2')
            S.date = '19-Oct-2011';
            S.blocklist = {'SRb-26', 'SRb-28', 'SRb-30', 'SRb-32'};
            if strcmp(reference,'allChCAR')
                S.badtrials = [22 26 37 64 101 128];
            elseif strcmp(reference,'LPCChCAR')
                S.badtrials = [22 26 30 64 101 128];
            else % from original data
                S.badtrials = [26 37 63 64 97 101 128];
            end            
        elseif strcmp(expt,'PC1')
            S.date = '19-Oct-2011';
            S.blocklist = {'SRb-21', 'SRb-22', 'SRb-23', 'SRb-24'};
        end
    case {'17b','RHb'}
        S.subjNum = '17b';
        S.subjName = 'RHb';
        if strcmp(expt,'SS2')
            S.date = '20-Oct-2011';
            S.blocklist = { 'RHb0211-09', 'RHb0211-11'};
            S.badtrials = [12    13    27    65    64    75];
        elseif strcmp(expt,'PC1')
            S.date = '20-Oct-2011';
            S.blocklist = {'RHb0211-02', 'RHb0211-07'};
        end
    case {'18','MD'}
        S.subjNum = '18';
        S.subjName = 'MD';
        if strcmp(expt,'SS2')
            S.date = '20-Oct-2011';
            S.blocklist = {'MD0311-15', 'MD0311-17'};
            if strcmp(reference,'allChCAR')
                S.badtrials = [1 74];
            elseif strcmp(reference,'LPCChCAR')
                S.badtrials = [1 74];
            else
                S.badtrials = [1 16 65 74];
            end
        end
    case {'19','RB'}
        S.subjNum = '19';
        S.subjName = 'RB';
        if strcmp(expt,'SS3') || strcmp(expt,'SS2')
            S.date = '19-Oct-2011';
            S.blocklist = {'RB-0911-66'};
            S.badtrials = [16 41 75   158   159   227   233   248 34   205   240   256   287   297];
        elseif strcmp(expt,'PC1')
            S.date = '20-Oct-2011';
            S.blocklist = {'RB0911-71', 'RB0911-72', 'RB0911-73'};
        end
        
    case {'20','DZa'}
        S.subjNum = '20';
        S.subjName = 'DZa';
        if strcmp(expt,'SS3')
            S.blocklist = {'DZ1211-04', 'DZ1211-05'};
        elseif strcmp(expt,'PC1')
            S.blocklist = {'DZ1211-06', 'DZ1211-07', 'DZ1211-08'};
        end
    case {'20b','DZb'}
        if strcmp(expt,'PC1')
            S.blocklist = {'DZb1211-9', 'DZb1211-10'};
        end
    case {'21','JT'}
        S.blocklist = {'JT0112-49', 'JT0112-50', 'JT0112-51'};
    case {'22','TC'}
        if strcmp(expt,'SS2')
            S.blocklist = {'TC0212-21', 'TC0212-23', 'TC0212-25'};
        elseif strcmp(expt,'PC1')
            S.blocklist = {'TC0212-14', 'TC0212-15', 'TC0212-16'};
        end
        
    case {'24','LK'}
        S.subjNum = '24';
        S.subjName = 'LK';
        if strcmp(expt,'SS2')
            S.blocklist = {'LK_14', 'LK_16','LK_18', 'LK_20'};
            if strcmp(reference,'allChCAR')
                S.badtrials = [48 54 55 79 85 87 92];
            elseif strcmp(reference,'LPCChCAR')
                S.badtrials = [7 48 79 85 87 92];
            else
                S.badtrials = [34 39 55];
            end
        end
    case {'28','NC'}
        S.subjNum = '28';
        S.subjName = 'NC';
        if strcmp(expt,'SS2')
            S.blocklist = {'NC_11', 'NC_13', 'NC_15', 'NC_17'};
            if strcmp(reference,'allChCAR')
                S.badtrials = [37 56 134 138 143];
            elseif strcmp(reference,'LPCChCAR')
                S.badtrials = [37 56 134 138 143];
            else
                S.badtrials = [37 56 134 138];
            end
        end
    case {'29','JT2'}
        S.subjNum = '29';
        S.subjName = 'JT2';
        if strcmp(expt,'SS2')
            S.blocklist = {'JT2_09', 'JT2_11', 'JT2_13', 'JT2_15'};      
            S.badtrials = [4 23 34 44 76 77 91 2 3 6 93 144];
        end
    otherwise
        error('subject not found.')
end

S.expt = expt;
S.DataPath = ['/biac4/wagner/biac3/wagner7/ecog/subj' S.subjNum '/ecog/' ...
    S.expt '/'];

