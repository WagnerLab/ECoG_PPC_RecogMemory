function S = subjinfo(subjnum,expt)
% bad trials calculated based on Low passes erp data,
% re-referenced to all channels. used with CalculateBadTrials.m with a
% tthreshold of 2. stim-locked data

% Patient CM
if strcmp(subjnum,'04') && strcmp(expt,'PC1')
    S.channels = [2:64]; % 1 is ref
    S.date = '27-Oct-2011';
    S.blocklist = {'st07-14', 'st07-24','st07-25'};
    
    % Patient KB
elseif strcmp(subjnum,'10') && strcmp(expt,'PC1')
    S.channels = [1:35]; % 36 is ref
    S.date = '30-Oct-2011';
    S.blocklist = {'KB0510_07', 'KB0510_09'};
    
    % Patient SRb
elseif strcmp(subjnum,'16b')
    S.channels = [1:61,63:114]; % 62 is ref
    if strcmp(expt,'SS2')
        S.date = '19-Oct-2011';
        S.blocklist = {'SRb-26', 'SRb-28', 'SRb-30', 'SRb-32'};
        %S.badtrials = [15    37    86    96   159]; 
         %S.badtrials = [3     5    43   109     4     6    42    70    71   108   120   156   157];
        S.badtrials = [15 22 26 34 37 64 101 128];
    elseif strcmp(expt,'PC1')
        S.date = '19-Oct-2011';
        S.blocklist = {'SRb-21', 'SRb-22', 'SRb-23', 'SRb-24'};
    end
    
    % Patient RHb
elseif strcmp(subjnum,'17b')
    S.channels = [1:56,58:74]; % 57 is ref
    if strcmp(expt,'SS2')
        S.date = '20-Oct-2011';
        S.blocklist = { 'RHb0211-09', 'RHb0211-11'};
        %S.badtrials = [  49    72    75]; 
         S.badtrials = [12    13    27    65    64    75];
    elseif strcmp(expt,'PC1')
        S.date = '20-Oct-2011';
        S.blocklist = {'RHb0211-02', 'RHb0211-07'};
    end
    
    % Patient MD
elseif strcmp(subjnum,'18') && strcmp(expt,'SS2')
    S.channels = [1:94,96:108]; % ref is 95
    S.date = '20-Oct-2011';
    S.blocklist = {'MD0311-15', 'MD0311-17'};
    %S.badtrials = [1    65    74    77];
    %S.badtrials  = [27    23    36    37    64];
    S.badtrials = [1 74 75];
    % Patient RB
elseif strcmp(subjnum,'19')
    S.channels = [1:63, 65:112]; % ref is 64
    if strcmp(expt,'SS3') || strcmp(expt,'SS2')
        S.date = '19-Oct-2011';
        S.blocklist = {'RB-0911-66'};
        %S.badtrials = [ 112   161   189];
        S.badtrials = [16    41    75   158   159   227   233   248    34   205   240   256   287   297];
    elseif strcmp(expt,'PC1')
        S.date = '20-Oct-2011';
        S.blocklist = {'RB0911-71', 'RB0911-72', 'RB0911-73'};
    end
    
    % Patient DZa
elseif strcmp(subjnum,'20')
    S.channels = 1:118; %setdiff([33:88],[77]);
    if strcmp(expt,'SS3')
        S.blocklist = {'DZ1211-04', 'DZ1211-05'};
    elseif strcmp(expt,'PC1')
        S.blocklist = {'DZ1211-06', 'DZ1211-07', 'DZ1211-08'};
    end
    
    % Patient DZb
elseif strcmp(subjnum,'20b') && strcmp(expt,'PC1')
    S.channels = 1:118;%setdiff(1:96,[23, 24, 73, 74, 75, 81, 82, 83, 84, 85, 89, 90, 91]);
    S.blocklist = {'DZb1211-9', 'DZb1211-10'};
    
    % Patient JT
elseif strcmp(subjnum,'21') && strcmp(expt,'PC1')
    S.channels = 1:118;%setdiff(33:96,[1, 93:96]);
    S.blocklist = {'JT0112-49', 'JT0112-50', 'JT0112-51'};
    
    % Patient TC
elseif strcmp(subjnum,'22')
    S.channels = [1:60,62:90]; % 61 is ref
    if strcmp(expt,'SS2')
        S.blocklist = {'TC0212-21', 'TC0212-23', 'TC0212-25'};
    elseif strcmp(expt,'PC1')
        S.blocklist = {'TC0212-14', 'TC0212-15', 'TC0212-16'};
    end
    % Patient LK
elseif strcmp(subjnum,'24')
    S.channels = [1:7,9:122]; % 8 is ref
    if strcmp(expt,'SS2')
        S.blocklist = {'LK_14', 'LK_16','LK_18', 'LK_20'};
        %S.badtrials = [ 55   102   129   157   159];
        %S.badtrials = [17    47    54    65    72    87    92    93    12    25    75    88    90    91 98];
        S.badtrials = [48 55 85 87 92];
    end
    % Patient NC
elseif strcmp(subjnum,'28')
    S.channels = [1:104,106]; % 8 is ref
    if strcmp(expt,'SS2')
        S.blocklist = {'NC_11', 'NC_13', 'NC_15', 'NC_17'};
        %S.badtrials = [ 52    56    59   101   104   114   134   138   156];
        %S.badtrials = [23    24    30    34    36    42   139   140    26    29    35    40    77   116 132   133   135   136   138];
        S.badtrials = [37 56 134 138 143];
    end
    % Patient JT
elseif strcmp(subjnum,'29')
    S.channels = [1:20,22:128]; % 21 is ref
    if strcmp(expt,'SS2')
        S.blocklist = {'JT2_09', 'JT2_11', 'JT2_13', 'JT2_15'};
        %S.badtrials = [2     4    23    44    76    77    91];
        S.badtrials = [4    23    34    44    76    77    91     2     3     6    93   144];
    end
else
    display('incorrect subject or experiment!')
    return
end