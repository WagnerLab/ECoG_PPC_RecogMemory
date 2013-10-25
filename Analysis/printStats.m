function printStats(data,opts)
% main statistics from time courses

% number of tests
mMain           = 1;
mInter          = 1*3;
type            = 'Bin';
MAIN_alpha      = 0.05/mMain;
INTER_alpha     = 0.05/mInter;

% time bins of interest
BOT         = find((data.Bins(:,1) >= opts.time(1)) & (data.Bins(:,2) <= opts.time(2)));

LhemChans   = data.hemChanId==1;
LIPSch      = data.ROIid.*LhemChans ==1;
LSPLch      = data.ROIid.*LhemChans ==2;
LAGch       = data.ROIid.*LhemChans ==3;

RhemChans   = data.hemChanId==2;
RIPSch      = data.ROIid.*RhemChans ==1;
RSPLch      = data.ROIid.*RhemChans ==2;
RAGch       = data.ROIid.*RhemChans ==3;

switch type, 
    case 'Bin' 
        time = data.Bins(BOT,:);
    case 'BigBin' 
        time = data.BigBins; 
end

%%
display('Lefts')
% IPS
display('IPS t test results')
Y1 = data.([type 'ZStat'])(LIPSch,BOT);
ttestPrint(Y1,MAIN_alpha,time)
% SPL
display('SPL t test results')
Y2 = data.([type 'ZStat'])(LSPLch,BOT);
ttestPrint(Y2,MAIN_alpha,time)
% AG
display('AG t test results')
Y3 = data.([type 'ZStat'])(LAGch,BOT);
ttestPrint(Y3,MAIN_alpha,time)

% AG-SPL interaction
display('AG-IPS 2 sample t test results')
ttest2Print(Y3,Y1,INTER_alpha,time)

% IPS-SPL interaction
display('AG-SPL 2 sample t test results')
ttest2Print(Y3,Y2,INTER_alpha,time)

% IPS-SPL interaction
display('IPS-SPL 2 sample t test results')
ttest2Print(Y1,Y2,INTER_alpha,time)

%%
display('Rights')
% IPS
display('IPS t test results')
Y1 = data.([type 'ZStat'])(RIPSch,BOT);
ttestPrint(Y1,MAIN_alpha,time)
% SPL
display('SPL t test results')
Y2 = data.([type 'ZStat'])(RSPLch,BOT);
ttestPrint(Y2,MAIN_alpha,time)
% AG
display('AG t test results')
Y3 = data.([type 'ZStat'])(RAGch,BOT);
ttestPrint(Y3,MAIN_alpha,time)

% AG-SPL interaction
display('AG-IPS 2 sample t test results')
ttest2Print(Y3,Y1,INTER_alpha,time)

% IPS-SPL interaction
display('AG-SPL 2 sample t test results')
ttest2Print(Y3,Y2,INTER_alpha,time)

% IPS-SPL interaction
display('IPS-SPL 2 sample t test results')
ttest2Print(Y1,Y2,INTER_alpha,time)

function ttestPrint(Y,alpha,time)

XX = mean(Y,2);
[~,p,~,stat]=ttest(XX,0,alpha);
display('Main Effect')
fprintf('T = %g, P = %g \n',stat.tstat,p);

[h,~,~,stat]=ttest(Y,0,alpha);

if sum(h)>0
    X = cell(sum(h)+1,3);
    X{1,1} = 'T Stat'; X{1,2} = 'T1'; X{1,3} = 'T2';
    X(2:end,1) = num2cell(stat.tstat(h==1)');
    X(2:end,2) = num2cell(time(h==1,1));
    X(2:end,3) = num2cell(time(h==1,2));
    display(X);
else
    display('no significant results')
end


function ttest2Print(Y1,Y2,alpha,time)
[h,~,~,stat]=ttest2(Y1,Y2,alpha);
if sum(h)>0
    X = cell(sum(h)+1,3);
    X{1,1} = 'T Stat'; X{1,2} = 'T1'; X{1,3} = 'T2';
    X(2:end,1) = num2cell(stat.tstat(h==1)');
    X(2:end,2) = num2cell(time(h==1,1));
    X(2:end,3) = num2cell(time(h==1,2));
    display(X);
else
    display('no significant results')
end